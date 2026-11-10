import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../data/providers.dart';
import '../../domain/models/models.dart';
import '../../domain/scoring/scoring.dart';

/// Today's date; rolls over at midnight so stars unlock without a restart.
class TodayNotifier extends Notifier<DateTime> {
  Timer? _timer;

  @override
  DateTime build() {
    ref.onDispose(() => _timer?.cancel());
    _scheduleRollover();
    return Dates.dateOnly(DateTime.now());
  }

  void refresh() {
    final now = Dates.dateOnly(DateTime.now());
    if (now != state) state = now;
  }

  void _scheduleRollover() {
    _timer?.cancel();
    final now = DateTime.now();
    final tomorrow = Dates.addDays(Dates.dateOnly(now), 1);
    _timer = Timer(tomorrow.difference(now) + const Duration(seconds: 1), () {
      refresh();
      _scheduleRollover();
    });
  }
}

final todayProvider = NotifierProvider<TodayNotifier, DateTime>(
  TodayNotifier.new,
);

class SelectedKidNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void select(int kidId) => state = kidId;
}

final selectedKidIdProvider = NotifierProvider<SelectedKidNotifier, int?>(
  SelectedKidNotifier.new,
);

/// Falls back to the first kid when nothing is picked or the pick was deleted.
final currentKidProvider = Provider<Kid?>((ref) {
  final kids = ref.watch(kidsProvider).value;
  if (kids == null || kids.isEmpty) return null;
  final id = ref.watch(selectedKidIdProvider);
  return kids.firstWhereOrNull((k) => k.id == id) ?? kids.first;
});

class SelectedWeekNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => Dates.weekStartOf(ref.read(todayProvider));

  void previous() => state = Dates.addDays(state, -DateTime.daysPerWeek);
  void next() => state = Dates.addDays(state, DateTime.daysPerWeek);
  void goToCurrent() => state = Dates.weekStartOf(ref.read(todayProvider));
}

final selectedWeekProvider = NotifierProvider<SelectedWeekNotifier, DateTime>(
  SelectedWeekNotifier.new,
);

/// Weekday index (0 = Monday) kept across week changes.
class SelectedDayIndexNotifier extends Notifier<int> {
  @override
  int build() => ref.read(todayProvider).weekday - DateTime.monday;

  void select(int index) => state = index;
}

final selectedDayIndexProvider =
    NotifierProvider<SelectedDayIndexNotifier, int>(
      SelectedDayIndexNotifier.new,
    );

final selectedDayProvider = Provider<DateTime>(
  (ref) => Dates.addDays(
    ref.watch(selectedWeekProvider),
    ref.watch(selectedDayIndexProvider),
  ),
);

final visibleTasksProvider = Provider.family<List<TaskItem>?, TaskType>((
  ref,
  type,
) {
  final tasks = ref.watch(allTasksProvider).value;
  return tasks?.where((t) => t.type == type && !t.isArchived).toList();
});

final activeRewardsProvider = Provider<List<Reward>?>((ref) {
  final rewards = ref.watch(allRewardsProvider).value;
  return rewards?.where((r) => !r.isArchived).toList();
});

/// Null while the kid's data is still loading.
final scoringProvider = Provider.family<Scoring?, int>((ref, kidId) {
  final tasks = ref.watch(allTasksProvider).value;
  final completions = ref.watch(completionsProvider(kidId)).value;
  final redemptions = ref.watch(redemptionsProvider(kidId)).value;
  if (tasks == null || completions == null || redemptions == null) {
    return null;
  }
  return Scoring(
    tasks: tasks,
    completions: completions,
    redemptions: redemptions,
  );
});

final currentScoringProvider = Provider<Scoring?>((ref) {
  final kid = ref.watch(currentKidProvider);
  return kid == null ? null : ref.watch(scoringProvider(kid.id));
});

/// True only while the PIN-gated edit screen is open.
class ManageUnlockedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void unlock() => state = true;
  void lock() => state = false;
}

final manageUnlockedProvider = NotifierProvider<ManageUnlockedNotifier, bool>(
  ManageUnlockedNotifier.new,
);
