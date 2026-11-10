import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:todo/data/db/database.dart';
import 'package:todo/data/repositories/completion_repository.dart';
import 'package:todo/data/repositories/kid_repository.dart';
import 'package:todo/data/repositories/note_repository.dart';
import 'package:todo/data/repositories/pin_repository.dart';
import 'package:todo/data/repositories/reward_repository.dart';
import 'package:todo/data/repositories/task_repository.dart';
import 'package:todo/domain/models/models.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late KidRepository kids;
  late TaskRepository tasks;
  late CompletionRepository completions;
  late RewardRepository rewards;
  late NoteRepository notes;
  final today = DateTime(2026, 11, 11);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    kids = KidRepository(db);
    tasks = TaskRepository(db);
    completions = CompletionRepository(db);
    rewards = RewardRepository(db);
    notes = NoteRepository(db);
  });

  tearDown(() => db.close());

  test('seeds two kids, 8 + 9 tasks and 6 rewards, all translatable', () async {
    final allKids = await kids.watchAll().first;
    final allTasks = await tasks.watchAll().first;
    final allRewards = await rewards.watchAll().first;
    expect(allKids.map((k) => k.seedKey), ['kid1', 'kid2']);
    expect(allKids.every((k) => k.name == null), isTrue);
    expect(allTasks.where((t) => t.type == TaskType.mustDo), hasLength(8));
    expect(allTasks.where((t) => t.type == TaskType.optional), hasLength(9));
    expect(allTasks.every((t) => t.title == null && t.seedKey != null), isTrue);
    expect(allRewards.map((r) => r.cost), [20, 30, 40, 50, 70, 100]);
  });

  group('stars', () {
    late Kid kid;
    late TaskItem task;

    setUp(() async {
      kid = (await kids.watchAll().first).first;
      task = (await tasks.watchAll().first).first;
    });

    test(
      'toggle stores the task points, toggling again removes the star',
      () async {
        expect(
          await completions.toggle(
            kidId: kid.id,
            task: task,
            day: today,
            today: today,
          ),
          isTrue,
        );
        var stars = await completions.watchForKid(kid.id).first;
        expect(stars.single.points, task.points);
        expect(stars.single.date, today);

        expect(
          await completions.toggle(
            kidId: kid.id,
            task: task,
            day: today,
            today: today,
          ),
          isFalse,
        );
        stars = await completions.watchForKid(kid.id).first;
        expect(stars, isEmpty);
      },
    );

    test('past days can be starred, future days cannot', () async {
      await completions.toggle(
        kidId: kid.id,
        task: task,
        day: DateTime(2026, 11, 9),
        today: today,
      );
      expect(
        () => completions.toggle(
          kidId: kid.id,
          task: task,
          day: DateTime(2026, 11, 12),
          today: today,
        ),
        throwsA(isA<FutureDayException>()),
      );
      expect(await completions.watchForKid(kid.id).first, hasLength(1));
    });

    test('editing task points leaves earlier stars alone', () async {
      await completions.toggle(
        kidId: kid.id,
        task: task,
        day: today,
        today: today,
      );
      await tasks.edit(task.id, emoji: task.emoji, title: null, points: 9);
      final stars = await completions.watchForKid(kid.id).first;
      expect(stars.single.points, 2);
      final edited = (await tasks.watchAll().first).firstWhere(
        (t) => t.id == task.id,
      );
      expect(edited.points, 9);
      expect(edited.title, isNull);
    });

    test('removing a task hides it but keeps its stars', () async {
      await completions.toggle(
        kidId: kid.id,
        task: task,
        day: today,
        today: today,
      );
      await tasks.archive(task.id);
      final archived = (await tasks.watchAll().first).firstWhere(
        (t) => t.id == task.id,
      );
      expect(archived.isArchived, isTrue);
      expect(await completions.watchForKid(kid.id).first, hasLength(1));
    });

    test('stars are per kid', () async {
      final other = (await kids.watchAll().first).last;
      await completions.toggle(
        kidId: kid.id,
        task: task,
        day: today,
        today: today,
      );
      expect(await completions.watchForKid(other.id).first, isEmpty);
    });
  });

  group('kids', () {
    test('add appends with a name, rename and reorder', () async {
      final id = await kids.add('  An  ');
      await kids.rename(id, 'Bình');
      var all = await kids.watchAll().first;
      expect(all.last.name, 'Bình');
      await kids.reorder([id, all[0].id, all[1].id]);
      all = await kids.watchAll().first;
      expect(all.first.id, id);
    });

    test('deleting a kid deletes their stars, redemptions and notes', () async {
      final [first, second] = await kids.watchAll().first;
      final task = (await tasks.watchAll().first).first;
      final reward = (await rewards.watchAll().first).first;
      for (final k in [first, second]) {
        await completions.toggle(
          kidId: k.id,
          task: task,
          day: today,
          today: today,
        );
        await rewards.redeem(kidId: k.id, reward: reward);
        await notes.save(k.id, DateTime(2026, 11, 9), 'note ${k.id}');
      }

      await kids.delete(first.id);

      expect(await db.select(db.completions).get(), hasLength(1));
      expect(await db.select(db.redemptions).get(), hasLength(1));
      expect(await db.select(db.weekNotes).get(), hasLength(1));
      expect(await notes.load(second.id, DateTime(2026, 11, 9)), isNotNull);
    });

    test('the last kid cannot be deleted', () async {
      final [first, second] = await kids.watchAll().first;
      await kids.delete(first.id);
      expect(() => kids.delete(second.id), throwsA(isA<LastKidException>()));
      expect(await kids.watchAll().first, hasLength(1));
    });
  });

  group('rewards and notes', () {
    test('redeem stores the cost at that moment', () async {
      final kid = (await kids.watchAll().first).first;
      final reward = (await rewards.watchAll().first).first;
      await rewards.redeem(kidId: kid.id, reward: reward);
      await rewards.edit(reward.id, emoji: reward.emoji, title: null, cost: 99);
      final history = await rewards.watchRedemptions(kid.id).first;
      expect(history.single.cost, 20);
    });

    test('a new task goes to the end of its own type', () async {
      final id = await tasks.add(
        type: TaskType.optional,
        emoji: '🎹',
        title: 'Piano',
        points: 4,
      );
      final optional = (await tasks.watchAll().first)
          .where((t) => t.type == TaskType.optional)
          .toList();
      expect(optional.last.id, id);
      expect(optional.last.sortOrder, 9);
    });

    test('notes are saved per kid and week, and overwritten', () async {
      final kid = (await kids.watchAll().first).first;
      final week = DateTime(2026, 11, 9);
      await notes.save(kid.id, week, 'first');
      await notes.save(kid.id, week, 'second');
      expect((await notes.load(kid.id, week))?.body, 'second');
      expect(await notes.load(kid.id, DateTime(2026, 11, 16)), isNull);
    });
  });

  group('PIN', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
    });

    test('stores a salted hash and verifies it', () async {
      final pin = PinRepository();
      expect(await pin.hasPin(), isFalse);
      expect(await pin.verify('1234'), isFalse);

      await pin.setPin('1234');

      expect(await pin.hasPin(), isTrue);
      expect(await pin.verify('1234'), isTrue);
      expect(await pin.verify('4321'), isFalse);
      final stored = await SharedPreferencesAsync().getAll();
      expect(stored.values.any((v) => '$v'.contains('1234')), isFalse);
    });
  });
}
