import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../../domain/models/models.dart';
import '../db/database.dart';
import '../db/tables.dart';

class FutureDayException implements Exception {
  const FutureDayException();
}

class CompletionRepository {
  CompletionRepository(this._db);

  final AppDatabase _db;

  Stream<List<Completion>> watchForKid(int kidId) => (_db.select(
    _db.completions,
  )..where((c) => c.kidId.equals(kidId))).watch();

  /// Returns whether the task is done after the toggle.
  Future<bool> toggle({
    required int kidId,
    required TaskItem task,
    required DateTime day,
    required DateTime today,
  }) {
    if (Dates.dateOnly(day).isAfter(Dates.dateOnly(today))) {
      throw const FutureDayException();
    }
    final ymd = const DayConverter().toSql(day);
    return _db.transaction(() async {
      final removed =
          await (_db.delete(_db.completions)..where(
                (c) =>
                    c.kidId.equals(kidId) &
                    c.taskId.equals(task.id) &
                    c.date.equals(ymd),
              ))
              .go();
      if (removed > 0) return false;
      await _db
          .into(_db.completions)
          .insert(
            CompletionsCompanion.insert(
              kidId: kidId,
              taskId: task.id,
              date: Dates.dateOnly(day),
              points: task.points,
              createdAt: DateTime.now(),
            ),
          );
      return true;
    });
  }
}
