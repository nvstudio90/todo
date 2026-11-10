import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/models/models.dart';
import '../home/home_state.dart';

/// Toggles the current kid's star for [task] on [day]; future days are ignored.
Future<void> toggleStar(WidgetRef ref, TaskItem task, DateTime day) async {
  final kid = ref.read(currentKidProvider);
  final today = ref.read(todayProvider);
  if (kid == null || day.isAfter(today)) return;
  await ref
      .read(completionRepositoryProvider)
      .toggle(kidId: kid.id, task: task, day: day, today: today);
}
