import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../../domain/models/models.dart';

/// Stores calendar days as `yyyy-MM-dd` so they sort and compare as text.
class DayConverter extends TypeConverter<DateTime, String> {
  const DayConverter();

  @override
  DateTime fromSql(String fromDb) => Dates.fromYmd(fromDb);

  @override
  String toSql(DateTime value) => Dates.toYmd(value);
}

@UseRowClass(Kid)
class Kids extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get seedKey => text().nullable()();
  TextColumn get name => text().nullable()();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get createdAt => dateTime()();
}

@UseRowClass(TaskItem)
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get seedKey => text().nullable()();
  TextColumn get emoji => text()();
  TextColumn get title => text().nullable()();
  IntColumn get points => integer()();
  TextColumn get type => textEnum<TaskType>()();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
}

@UseRowClass(Completion)
class Completions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kidId =>
      integer().references(Kids, #id, onDelete: KeyAction.cascade)();
  IntColumn get taskId => integer().references(Tasks, #id)();
  TextColumn get date => text().map(const DayConverter())();
  IntColumn get points => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {kidId, taskId, date},
  ];
}

@UseRowClass(Reward)
class Rewards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get seedKey => text().nullable()();
  TextColumn get emoji => text()();
  TextColumn get title => text().nullable()();
  IntColumn get cost => integer()();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
}

@UseRowClass(Redemption)
class Redemptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kidId =>
      integer().references(Kids, #id, onDelete: KeyAction.cascade)();
  IntColumn get rewardId => integer().references(Rewards, #id)();
  IntColumn get cost => integer()();
  DateTimeColumn get redeemedAt => dateTime()();
}

@UseRowClass(WeekNote)
class WeekNotes extends Table {
  IntColumn get kidId =>
      integer().references(Kids, #id, onDelete: KeyAction.cascade)();
  TextColumn get weekStart => text().map(const DayConverter())();
  TextColumn get body => text().named('text')();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {kidId, weekStart};
}
