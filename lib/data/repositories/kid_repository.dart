import 'package:drift/drift.dart';

import '../../domain/models/models.dart';
import '../db/database.dart';

class LastKidException implements Exception {
  const LastKidException();
}

class KidRepository {
  KidRepository(this._db);

  final AppDatabase _db;

  Stream<List<Kid>> watchAll() =>
      (_db.select(_db.kids)..orderBy([
            (k) => OrderingTerm(expression: k.sortOrder),
            (k) => OrderingTerm(expression: k.id),
          ]))
          .watch();

  Future<int> add(String name) async {
    final maxOrder = _db.kids.sortOrder.max();
    final row = await (_db.selectOnly(
      _db.kids,
    )..addColumns([maxOrder])).getSingle();
    return _db
        .into(_db.kids)
        .insert(
          KidsCompanion.insert(
            name: Value(name.trim()),
            sortOrder: (row.read(maxOrder) ?? -1) + 1,
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> rename(int id, String name) =>
      (_db.update(_db.kids)..where((k) => k.id.equals(id))).write(
        KidsCompanion(name: Value(name.trim())),
      );

  Future<void> reorder(List<int> ids) => _db.batch((b) {
    for (final (i, id) in ids.indexed) {
      b.update(
        _db.kids,
        KidsCompanion(sortOrder: Value(i)),
        where: (k) => k.id.equals(id),
      );
    }
  });

  /// Stars, redemptions and notes go with the kid through ON DELETE CASCADE.
  Future<void> delete(int id) => _db.transaction(() async {
    final count = await _db.kids.count().getSingle();
    if (count <= 1) throw const LastKidException();
    await (_db.delete(_db.kids)..where((k) => k.id.equals(id))).go();
  });
}
