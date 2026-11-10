import 'package:drift/drift.dart';

import '../../domain/models/models.dart';
import '../db/database.dart';

class RewardRepository {
  RewardRepository(this._db);

  final AppDatabase _db;

  /// Includes removed rewards so the redemption history can still show them.
  Stream<List<Reward>> watchAll() =>
      (_db.select(_db.rewards)..orderBy([
            (r) => OrderingTerm(expression: r.sortOrder),
            (r) => OrderingTerm(expression: r.id),
          ]))
          .watch();

  Future<int> add({
    required String emoji,
    required String title,
    required int cost,
  }) async {
    final maxOrder = _db.rewards.sortOrder.max();
    final row = await (_db.selectOnly(
      _db.rewards,
    )..addColumns([maxOrder])).getSingle();
    return _db
        .into(_db.rewards)
        .insert(
          RewardsCompanion.insert(
            emoji: emoji,
            title: Value(title.trim()),
            cost: cost,
            sortOrder: (row.read(maxOrder) ?? -1) + 1,
          ),
        );
  }

  Future<void> edit(
    int id, {
    required String emoji,
    required String? title,
    required int cost,
  }) => (_db.update(_db.rewards)..where((r) => r.id.equals(id))).write(
    RewardsCompanion(
      emoji: Value(emoji),
      title: Value(title?.trim()),
      cost: Value(cost),
    ),
  );

  Future<void> archive(int id) =>
      (_db.update(_db.rewards)..where((r) => r.id.equals(id))).write(
        RewardsCompanion(archivedAt: Value(DateTime.now())),
      );

  Future<void> reorder(List<int> ids) => _db.batch((b) {
    for (final (i, id) in ids.indexed) {
      b.update(
        _db.rewards,
        RewardsCompanion(sortOrder: Value(i)),
        where: (r) => r.id.equals(id),
      );
    }
  });

  Stream<List<Redemption>> watchRedemptions(int kidId) =>
      (_db.select(_db.redemptions)
            ..where((r) => r.kidId.equals(kidId))
            ..orderBy([
              (r) => OrderingTerm(
                expression: r.redeemedAt,
                mode: OrderingMode.desc,
              ),
              (r) => OrderingTerm(expression: r.id, mode: OrderingMode.desc),
            ]))
          .watch();

  Future<void> redeem({required int kidId, required Reward reward}) => _db
      .into(_db.redemptions)
      .insert(
        RedemptionsCompanion.insert(
          kidId: kidId,
          rewardId: reward.id,
          cost: reward.cost,
          redeemedAt: DateTime.now(),
        ),
      );
}
