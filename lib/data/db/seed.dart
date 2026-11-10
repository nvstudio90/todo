import 'package:drift/drift.dart';

import '../../domain/models/models.dart';
import 'database.dart';

typedef SeedTask = ({String key, String emoji, int points, TaskType type});
typedef SeedReward = ({String key, String emoji, int cost});

/// Default data from docs/app-plan.md, section 4. Text lives in the ARB files.
const seedKidKeys = ['kid1', 'kid2'];

const List<SeedTask> seedTasks = [
  (key: 'makeBed', emoji: '🛏️', points: 2, type: TaskType.mustDo),
  (key: 'brushTeeth', emoji: '🪥', points: 2, type: TaskType.mustDo),
  (key: 'getDressed', emoji: '👕', points: 2, type: TaskType.mustDo),
  (key: 'packBag', emoji: '🎒', points: 2, type: TaskType.mustDo),
  (key: 'eatNeatly', emoji: '🍴', points: 2, type: TaskType.mustDo),
  (key: 'tidyToys', emoji: '🧸', points: 2, type: TaskType.mustDo),
  (key: 'homework', emoji: '📚', points: 3, type: TaskType.mustDo),
  (key: 'bedtime', emoji: '🚿', points: 2, type: TaskType.mustDo),
  (key: 'reading', emoji: '📖', points: 3, type: TaskType.optional),
  (key: 'chore', emoji: '🧹', points: 3, type: TaskType.optional),
  (key: 'foldClothes', emoji: '🧺', points: 2, type: TaskType.optional),
  (key: 'plants', emoji: '🪴', points: 2, type: TaskType.optional),
  (key: 'creative', emoji: '🎨', points: 2, type: TaskType.optional),
  (key: 'outdoor', emoji: '👟', points: 3, type: TaskType.optional),
  (key: 'english', emoji: '🇬🇧', points: 2, type: TaskType.optional),
  (key: 'learnNew', emoji: '💡', points: 3, type: TaskType.optional),
  (key: 'goodDeed', emoji: '❤️', points: 5, type: TaskType.optional),
];

const List<SeedReward> seedRewards = [
  (key: 'dessert', emoji: '🍦', cost: 20),
  (key: 'movie', emoji: '🎬', cost: 30),
  (key: 'game', emoji: '🎲', cost: 40),
  (key: 'outing', emoji: '🚗', cost: 50),
  (key: 'treat', emoji: '🎁', cost: 70),
  (key: 'experience', emoji: '🎡', cost: 100),
];

/// Seeded tasks count as active on every past day, so the install week can
/// still earn a streak.
final _seedEpoch = DateTime(2000);

Future<void> seedDefaults(AppDatabase db) async {
  final now = DateTime.now();
  await db.batch((b) {
    b.insertAll(db.kids, [
      for (final (i, key) in seedKidKeys.indexed)
        KidsCompanion.insert(seedKey: Value(key), sortOrder: i, createdAt: now),
    ]);
    final orderByType = <TaskType, int>{};
    b.insertAll(db.tasks, [
      for (final t in seedTasks)
        TasksCompanion.insert(
          seedKey: Value(t.key),
          emoji: t.emoji,
          points: t.points,
          type: t.type,
          sortOrder: orderByType.update(
            t.type,
            (n) => n + 1,
            ifAbsent: () => 0,
          ),
          createdAt: _seedEpoch,
        ),
    ]);
    b.insertAll(db.rewards, [
      for (final (i, r) in seedRewards.indexed)
        RewardsCompanion.insert(
          seedKey: Value(r.key),
          emoji: r.emoji,
          cost: r.cost,
          sortOrder: i,
        ),
    ]);
  });
}
