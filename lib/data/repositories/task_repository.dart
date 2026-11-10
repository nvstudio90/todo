import 'package:drift/drift.dart';

import '../../domain/models/models.dart';
import '../db/database.dart';

class TaskRepository {
  TaskRepository(this._db);

  final AppDatabase _db;

  /// Includes removed tasks: their stars still count toward points.
  Stream<List<TaskItem>> watchAll() =>
      (_db.select(_db.tasks)..orderBy([
            (t) => OrderingTerm(expression: t.sortOrder),
            (t) => OrderingTerm(expression: t.id),
          ]))
          .watch();

  Future<int> add({
    required TaskType type,
    required String emoji,
    required String title,
    required int points,
  }) async {
    final maxOrder = _db.tasks.sortOrder.max();
    final row =
        await (_db.selectOnly(_db.tasks)
              ..addColumns([maxOrder])
              ..where(_db.tasks.type.equalsValue(type)))
            .getSingle();
    return _db
        .into(_db.tasks)
        .insert(
          TasksCompanion.insert(
            emoji: emoji,
            title: Value(title.trim()),
            points: points,
            type: type,
            sortOrder: (row.read(maxOrder) ?? -1) + 1,
            createdAt: DateTime.now(),
          ),
        );
  }

  /// A null [title] keeps a seeded task translatable.
  Future<void> edit(
    int id, {
    required String emoji,
    required String? title,
    required int points,
  }) => (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
    TasksCompanion(
      emoji: Value(emoji),
      title: Value(title?.trim()),
      points: Value(points),
    ),
  );

  Future<void> archive(int id) =>
      (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
        TasksCompanion(archivedAt: Value(DateTime.now())),
      );

  Future<void> reorder(List<int> ids) => _db.batch((b) {
    for (final (i, id) in ids.indexed) {
      b.update(
        _db.tasks,
        TasksCompanion(sortOrder: Value(i)),
        where: (t) => t.id.equals(id),
      );
    }
  });
}
