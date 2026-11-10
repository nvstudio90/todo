import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/models/models.dart';
import 'seed.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Kids, Tasks, Completions, Rewards, Redemptions, WeekNotes],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'todo'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await seedDefaults(this);
    },
    // SQLite leaves foreign keys off per connection; cascades need them.
    beforeOpen: (details) => customStatement('PRAGMA foreign_keys = ON'),
  );
}
