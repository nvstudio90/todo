import 'package:drift/drift.dart';

import '../../domain/models/models.dart';
import '../db/database.dart';
import '../db/tables.dart';

class NoteRepository {
  NoteRepository(this._db);

  final AppDatabase _db;

  Future<WeekNote?> load(int kidId, DateTime weekStart) =>
      (_db.select(_db.weekNotes)..where(
            (n) =>
                n.kidId.equals(kidId) &
                n.weekStart.equals(const DayConverter().toSql(weekStart)),
          ))
          .getSingleOrNull();

  Future<void> save(int kidId, DateTime weekStart, String body) => _db
      .into(_db.weekNotes)
      .insertOnConflictUpdate(
        WeekNotesCompanion.insert(
          kidId: kidId,
          weekStart: weekStart,
          body: body,
          updatedAt: DateTime.now(),
        ),
      );
}
