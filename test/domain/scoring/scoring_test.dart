import 'package:flutter_test/flutter_test.dart';
import 'package:todo/core/utils/dates.dart';
import 'package:todo/domain/models/models.dart';
import 'package:todo/domain/scoring/levels.dart';
import 'package:todo/domain/scoring/scoring.dart';

final _epoch = DateTime(2000);

TaskItem _task(
  int id, {
  TaskType type = TaskType.mustDo,
  int points = 2,
  DateTime? createdAt,
  DateTime? archivedAt,
}) => TaskItem(
  id: id,
  emoji: '⭐',
  title: 'Task $id',
  points: points,
  type: type,
  sortOrder: id,
  createdAt: createdAt ?? _epoch,
  archivedAt: archivedAt,
);

var _nextId = 0;

Completion _done(int taskId, DateTime day, {int points = 2}) => Completion(
  id: _nextId++,
  kidId: 1,
  taskId: taskId,
  date: day,
  points: points,
  createdAt: day,
);

/// Stars every listed task on every day of the week.
List<Completion> _fullWeek(DateTime weekStart, List<TaskItem> tasks) => [
  for (final day in Dates.daysOfWeek(weekStart))
    for (final t in tasks) _done(t.id, day, points: t.points),
];

void main() {
  final monday = DateTime(2026, 11, 9);
  final mustDo = [_task(1), _task(2, points: 3)];
  final optional = _task(10, type: TaskType.optional, points: 5);
  final tasks = [...mustDo, optional];

  group('points', () {
    test('pointsOn sums the stored points of that day', () {
      final s = Scoring(
        tasks: tasks,
        completions: [
          _done(1, monday),
          _done(10, monday, points: 5),
          _done(1, Dates.addDays(monday, 1)),
        ],
      );
      expect(s.pointsOn(monday), 7);
      expect(s.pointsOn(monday, type: TaskType.mustDo), 2);
      expect(s.pointsOn(monday, type: TaskType.optional), 5);
      expect(s.pointsOn(Dates.addDays(monday, 2)), 0);
    });

    test('removing a star removes its points', () {
      final star = _done(1, monday);
      expect(Scoring(tasks: tasks, completions: [star]).pointsOn(monday), 2);
      expect(Scoring(tasks: tasks, completions: []).pointsOn(monday), 0);
    });

    test('history keeps the points a task had when it was starred', () {
      final edited = [_task(1, points: 10), mustDo[1], optional];
      final s = Scoring(tasks: edited, completions: [_done(1, monday)]);
      expect(s.pointsOn(monday), 2);
    });

    test('stars of a removed task still count', () {
      final removed = [_task(1, archivedAt: DateTime(2026, 11, 10)), mustDo[1]];
      final s = Scoring(tasks: removed, completions: [_done(1, monday)]);
      expect(s.totalEarned, 2);
    });

    test('taskPointsInWeek only counts that task inside the week', () {
      final s = Scoring(
        tasks: tasks,
        completions: [
          _done(1, monday),
          _done(1, Dates.addDays(monday, 6)),
          _done(1, Dates.addDays(monday, 7)),
          _done(2, monday, points: 3),
        ],
      );
      expect(s.taskPointsInWeek(1, monday), 4);
    });
  });

  group('streak', () {
    test('7/7 days with every must-do task earns the bonus', () {
      final s = Scoring(tasks: tasks, completions: _fullWeek(monday, mustDo));
      expect(s.streakDays(monday), everyElement(isTrue));
      expect(s.streakBonus(monday), streakBonusPoints);
      expect(s.weekPoints(monday), 7 * 5 + 10);
    });

    test('one missing task on one day loses the bonus', () {
      final completions = _fullWeek(monday, mustDo)
        ..removeWhere(
          (c) =>
              c.taskId == 2 &&
              Dates.isSameDay(c.date, Dates.addDays(monday, 3)),
        );
      final s = Scoring(tasks: tasks, completions: completions);
      expect(s.streakDays(monday).where((d) => d).length, 6);
      expect(s.streakBonus(monday), 0);
    });

    test('optional tasks do not matter for the streak', () {
      final s = Scoring(tasks: tasks, completions: _fullWeek(monday, mustDo));
      expect(s.mustDoDoneOn(monday), isTrue);
    });

    test('a streak does not carry across weeks', () {
      final lastWeek = Dates.addDays(monday, -7);
      final completions = [
        ...[
          for (final d in Dates.daysOfWeek(lastWeek).skip(3))
            for (final t in mustDo) _done(t.id, d),
        ],
        ...[
          for (final d in Dates.daysOfWeek(monday).take(4))
            for (final t in mustDo) _done(t.id, d),
        ],
      ];
      final s = Scoring(tasks: tasks, completions: completions);
      expect(s.streakBonus(lastWeek), 0);
      expect(s.streakBonus(monday), 0);
    });

    test('works for a week that spans two years', () {
      final week = DateTime(2025, 12, 29);
      final s = Scoring(tasks: tasks, completions: _fullWeek(week, mustDo));
      expect(s.streakBonus(week), streakBonusPoints);
      expect(s.totalEarned, 7 * 5 + 10);
    });

    test('a task removed mid-week is only required before its removal', () {
      final thursday = Dates.addDays(monday, 3);
      final withRemoval = [
        mustDo[0],
        _task(2, points: 3, archivedAt: thursday),
      ];
      final completions = [
        for (final d in Dates.daysOfWeek(monday)) _done(1, d),
        for (final d in Dates.daysOfWeek(monday).take(3))
          _done(2, d, points: 3),
      ];
      final s = Scoring(tasks: withRemoval, completions: completions);
      expect(s.streakBonus(monday), streakBonusPoints);
    });

    test('a task added mid-week is not required on earlier days', () {
      final wednesday = Dates.addDays(monday, 2);
      final withNew = [mustDo[0], _task(3, createdAt: wednesday)];
      final completions = [
        for (final d in Dates.daysOfWeek(monday)) _done(1, d),
        for (final d in Dates.daysOfWeek(monday).skip(2)) _done(3, d),
      ];
      final s = Scoring(tasks: withNew, completions: completions);
      expect(s.streakBonus(monday), streakBonusPoints);
    });

    test('a day with no must-do tasks does not count as done', () {
      final s = Scoring(tasks: [optional], completions: []);
      expect(s.mustDoDoneOn(monday), isFalse);
    });
  });

  group('totals', () {
    test('totalEarned adds every week and its bonus; available subtracts redemptions', () {
      final lastWeek = Dates.addDays(monday, -7);
      final s = Scoring(
        tasks: tasks,
        completions: [
          ..._fullWeek(lastWeek, mustDo),
          _done(10, monday, points: 5),
        ],
        redemptions: [
          Redemption(
            id: 1,
            kidId: 1,
            rewardId: 1,
            cost: 20,
            redeemedAt: monday,
          ),
        ],
      );
      expect(s.totalEarned, 35 + 10 + 5);
      expect(s.spent, 20);
      expect(s.available, 30);
    });

    test('redeeming does not lower the level', () {
      final s = Scoring(
        tasks: tasks,
        completions: _fullWeek(monday, mustDo),
        redemptions: [
          Redemption(
            id: 1,
            kidId: 1,
            rewardId: 1,
            cost: 40,
            redeemedAt: monday,
          ),
        ],
      );
      expect(s.totalEarned, 45);
      expect(s.available, 5);
      expect(s.level.current.number, 1);
    });
  });

  group('levels', () {
    for (final (points, level) in [
      (0, 1),
      (49, 1),
      (50, 2),
      (99, 2),
      (100, 3),
      (149, 3),
      (150, 4),
      (999, 4),
    ]) {
      test('$points points → level $level', () {
        expect(LevelProgress.forPoints(points).current.number, level);
      });
    }

    test('progress within the current level', () {
      final p = LevelProgress.forPoints(12);
      expect(p.next?.number, 2);
      expect(p.pointsToNext, 38);
      expect(p.fraction, closeTo(0.24, 1e-9));
    });

    test('top level is full', () {
      final p = LevelProgress.forPoints(200);
      expect(p.next, isNull);
      expect(p.pointsToNext, 0);
      expect(p.fraction, 1);
    });
  });
}
