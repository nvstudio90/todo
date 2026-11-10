import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/models.dart';
import 'db/database.dart';
import 'repositories/completion_repository.dart';
import 'repositories/kid_repository.dart';
import 'repositories/note_repository.dart';
import 'repositories/pin_repository.dart';
import 'repositories/reward_repository.dart';
import 'repositories/task_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final kidRepositoryProvider = Provider(
  (ref) => KidRepository(ref.watch(databaseProvider)),
);
final taskRepositoryProvider = Provider(
  (ref) => TaskRepository(ref.watch(databaseProvider)),
);
final completionRepositoryProvider = Provider(
  (ref) => CompletionRepository(ref.watch(databaseProvider)),
);
final rewardRepositoryProvider = Provider(
  (ref) => RewardRepository(ref.watch(databaseProvider)),
);
final noteRepositoryProvider = Provider(
  (ref) => NoteRepository(ref.watch(databaseProvider)),
);
final pinRepositoryProvider = Provider((ref) => PinRepository());

final kidsProvider = StreamProvider<List<Kid>>(
  (ref) => ref.watch(kidRepositoryProvider).watchAll(),
);

/// All tasks, removed ones included.
final allTasksProvider = StreamProvider<List<TaskItem>>(
  (ref) => ref.watch(taskRepositoryProvider).watchAll(),
);

final allRewardsProvider = StreamProvider<List<Reward>>(
  (ref) => ref.watch(rewardRepositoryProvider).watchAll(),
);

final completionsProvider = StreamProvider.family<List<Completion>, int>(
  (ref, kidId) => ref.watch(completionRepositoryProvider).watchForKid(kidId),
);

final redemptionsProvider = StreamProvider.family<List<Redemption>, int>(
  (ref, kidId) => ref.watch(rewardRepositoryProvider).watchRedemptions(kidId),
);
