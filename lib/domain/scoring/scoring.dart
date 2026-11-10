import '../../core/utils/dates.dart';
import '../models/models.dart';
import 'levels.dart';

const streakBonusPoints = 10;

/// Point rules from docs/app-plan.md, section 3, for one kid.
class Scoring {
  Scoring({
    required List<TaskItem> tasks,
    required List<Completion> completions,
    this._redemptions = const [],
  }) : _tasks = tasks,
       _taskById = {for (final t in tasks) t.id: t} {
    for (final c in completions) {
      final day = Dates.toYmd(c.date);
      (_byDay[day] ??= []).add(c);
      _done.add(_key(c.taskId, day));
    }
  }

  final List<TaskItem> _tasks;
  final List<Redemption> _redemptions;
  final Map<int, TaskItem> _taskById;
  final Map<String, List<Completion>> _byDay = {};
  final Set<String> _done = {};

  static String _key(int taskId, String ymd) => '$taskId@$ymd';

  List<Completion> _on(DateTime day) => _byDay[Dates.toYmd(day)] ?? const [];

  bool isDone(int taskId, DateTime day) =>
      _done.contains(_key(taskId, Dates.toYmd(day)));

  int pointsOn(DateTime day, {TaskType? type}) =>
      _on(day)
          .where((c) => type == null || _taskById[c.taskId]?.type == type)
          .fold(0, (sum, c) => sum + c.points);

  int taskPointsInWeek(int taskId, DateTime weekStart) =>
      Dates.daysOfWeek(weekStart)
          .expand(_on)
          .where((c) => c.taskId == taskId)
          .fold(0, (s, c) => s + c.points);

  /// A day with no must-do tasks in effect does not count as done.
  bool mustDoDoneOn(DateTime day) {
    final required = _tasks.where(
      (t) => t.type == TaskType.mustDo && t.isActiveOn(day),
    );
    return required.isNotEmpty && required.every((t) => isDone(t.id, day));
  }

  List<bool> streakDays(DateTime weekStart) =>
      Dates.daysOfWeek(weekStart).map(mustDoDoneOn).toList();

  int streakBonus(DateTime weekStart) =>
      streakDays(weekStart).every((done) => done) ? streakBonusPoints : 0;

  int weekPoints(DateTime weekStart) =>
      Dates.daysOfWeek(weekStart).fold(0, (s, d) => s + pointsOn(d)) +
      streakBonus(weekStart);

  late final int totalEarned = _sumAllWeeks();

  int _sumAllWeeks() {
    final weeks = {
      for (final ymd in _byDay.keys)
        Dates.weekStartOf(Dates.fromYmd(ymd)).millisecondsSinceEpoch,
    };
    final starPoints = _byDay.values
        .expand((list) => list)
        .fold(0, (s, c) => s + c.points);
    final bonus = weeks.fold(
      0,
      (s, ms) => s + streakBonus(DateTime.fromMillisecondsSinceEpoch(ms)),
    );
    return starPoints + bonus;
  }

  int get spent => _redemptions.fold(0, (s, r) => s + r.cost);

  int get available => totalEarned - spent;

  late final LevelProgress level = LevelProgress.forPoints(totalEarned);
}
