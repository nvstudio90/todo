// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $KidsTable extends Kids with TableInfo<$KidsTable, Kid> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KidsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _seedKeyMeta = const VerificationMeta(
    'seedKey',
  );
  @override
  late final GeneratedColumn<String> seedKey = GeneratedColumn<String>(
    'seed_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    seedKey,
    name,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kids';
  @override
  VerificationContext validateIntegrity(
    Insertable<Kid> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('seed_key')) {
      context.handle(
        _seedKeyMeta,
        seedKey.isAcceptableOrUnknown(data['seed_key']!, _seedKeyMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Kid map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Kid(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      seedKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_key'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $KidsTable createAlias(String alias) {
    return $KidsTable(attachedDatabase, alias);
  }
}

class KidsCompanion extends UpdateCompanion<Kid> {
  final Value<int> id;
  final Value<String?> seedKey;
  final Value<String?> name;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  const KidsCompanion({
    this.id = const Value.absent(),
    this.seedKey = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  KidsCompanion.insert({
    this.id = const Value.absent(),
    this.seedKey = const Value.absent(),
    this.name = const Value.absent(),
    required int sortOrder,
    required DateTime createdAt,
  }) : sortOrder = Value(sortOrder),
       createdAt = Value(createdAt);
  static Insertable<Kid> custom({
    Expression<int>? id,
    Expression<String>? seedKey,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seedKey != null) 'seed_key': seedKey,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  KidsCompanion copyWith({
    Value<int>? id,
    Value<String?>? seedKey,
    Value<String?>? name,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
  }) {
    return KidsCompanion(
      id: id ?? this.id,
      seedKey: seedKey ?? this.seedKey,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seedKey.present) {
      map['seed_key'] = Variable<String>(seedKey.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KidsCompanion(')
          ..write('id: $id, ')
          ..write('seedKey: $seedKey, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _seedKeyMeta = const VerificationMeta(
    'seedKey',
  );
  @override
  late final GeneratedColumn<String> seedKey = GeneratedColumn<String>(
    'seed_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TaskType>($TasksTable.$convertertype);
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    seedKey,
    emoji,
    title,
    points,
    type,
    sortOrder,
    createdAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('seed_key')) {
      context.handle(
        _seedKeyMeta,
        seedKey.isAcceptableOrUnknown(data['seed_key']!, _seedKeyMeta),
      );
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      seedKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_key'],
      ),
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      type: $TasksTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskType, String, String> $convertertype =
      const EnumNameConverter<TaskType>(TaskType.values);
}

class TasksCompanion extends UpdateCompanion<TaskItem> {
  final Value<int> id;
  final Value<String?> seedKey;
  final Value<String> emoji;
  final Value<String?> title;
  final Value<int> points;
  final Value<TaskType> type;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime?> archivedAt;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.seedKey = const Value.absent(),
    this.emoji = const Value.absent(),
    this.title = const Value.absent(),
    this.points = const Value.absent(),
    this.type = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    this.seedKey = const Value.absent(),
    required String emoji,
    this.title = const Value.absent(),
    required int points,
    required TaskType type,
    required int sortOrder,
    required DateTime createdAt,
    this.archivedAt = const Value.absent(),
  }) : emoji = Value(emoji),
       points = Value(points),
       type = Value(type),
       sortOrder = Value(sortOrder),
       createdAt = Value(createdAt);
  static Insertable<TaskItem> custom({
    Expression<int>? id,
    Expression<String>? seedKey,
    Expression<String>? emoji,
    Expression<String>? title,
    Expression<int>? points,
    Expression<String>? type,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? archivedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seedKey != null) 'seed_key': seedKey,
      if (emoji != null) 'emoji': emoji,
      if (title != null) 'title': title,
      if (points != null) 'points': points,
      if (type != null) 'type': type,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (archivedAt != null) 'archived_at': archivedAt,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<String?>? seedKey,
    Value<String>? emoji,
    Value<String?>? title,
    Value<int>? points,
    Value<TaskType>? type,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime?>? archivedAt,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      seedKey: seedKey ?? this.seedKey,
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      points: points ?? this.points,
      type: type ?? this.type,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seedKey.present) {
      map['seed_key'] = Variable<String>(seedKey.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TasksTable.$convertertype.toSql(type.value),
      );
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('seedKey: $seedKey, ')
          ..write('emoji: $emoji, ')
          ..write('title: $title, ')
          ..write('points: $points, ')
          ..write('type: $type, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }
}

class $CompletionsTable extends Completions
    with TableInfo<$CompletionsTable, Completion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kidIdMeta = const VerificationMeta('kidId');
  @override
  late final GeneratedColumn<int> kidId = GeneratedColumn<int>(
    'kid_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kids (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> date =
      GeneratedColumn<String>(
        'date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($CompletionsTable.$converterdate);
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kidId,
    taskId,
    date,
    points,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Completion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kid_id')) {
      context.handle(
        _kidIdMeta,
        kidId.isAcceptableOrUnknown(data['kid_id']!, _kidIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kidIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {kidId, taskId, date},
  ];
  @override
  Completion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Completion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kidId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kid_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      date: $CompletionsTable.$converterdate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}date'],
        )!,
      ),
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CompletionsTable createAlias(String alias) {
    return $CompletionsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterdate = const DayConverter();
}

class CompletionsCompanion extends UpdateCompanion<Completion> {
  final Value<int> id;
  final Value<int> kidId;
  final Value<int> taskId;
  final Value<DateTime> date;
  final Value<int> points;
  final Value<DateTime> createdAt;
  const CompletionsCompanion({
    this.id = const Value.absent(),
    this.kidId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.date = const Value.absent(),
    this.points = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CompletionsCompanion.insert({
    this.id = const Value.absent(),
    required int kidId,
    required int taskId,
    required DateTime date,
    required int points,
    required DateTime createdAt,
  }) : kidId = Value(kidId),
       taskId = Value(taskId),
       date = Value(date),
       points = Value(points),
       createdAt = Value(createdAt);
  static Insertable<Completion> custom({
    Expression<int>? id,
    Expression<int>? kidId,
    Expression<int>? taskId,
    Expression<String>? date,
    Expression<int>? points,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kidId != null) 'kid_id': kidId,
      if (taskId != null) 'task_id': taskId,
      if (date != null) 'date': date,
      if (points != null) 'points': points,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CompletionsCompanion copyWith({
    Value<int>? id,
    Value<int>? kidId,
    Value<int>? taskId,
    Value<DateTime>? date,
    Value<int>? points,
    Value<DateTime>? createdAt,
  }) {
    return CompletionsCompanion(
      id: id ?? this.id,
      kidId: kidId ?? this.kidId,
      taskId: taskId ?? this.taskId,
      date: date ?? this.date,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kidId.present) {
      map['kid_id'] = Variable<int>(kidId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(
        $CompletionsTable.$converterdate.toSql(date.value),
      );
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompletionsCompanion(')
          ..write('id: $id, ')
          ..write('kidId: $kidId, ')
          ..write('taskId: $taskId, ')
          ..write('date: $date, ')
          ..write('points: $points, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RewardsTable extends Rewards with TableInfo<$RewardsTable, Reward> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _seedKeyMeta = const VerificationMeta(
    'seedKey',
  );
  @override
  late final GeneratedColumn<String> seedKey = GeneratedColumn<String>(
    'seed_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    seedKey,
    emoji,
    title,
    cost,
    sortOrder,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rewards';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reward> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('seed_key')) {
      context.handle(
        _seedKeyMeta,
        seedKey.isAcceptableOrUnknown(data['seed_key']!, _seedKeyMeta),
      );
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reward map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reward(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      seedKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_key'],
      ),
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $RewardsTable createAlias(String alias) {
    return $RewardsTable(attachedDatabase, alias);
  }
}

class RewardsCompanion extends UpdateCompanion<Reward> {
  final Value<int> id;
  final Value<String?> seedKey;
  final Value<String> emoji;
  final Value<String?> title;
  final Value<int> cost;
  final Value<int> sortOrder;
  final Value<DateTime?> archivedAt;
  const RewardsCompanion({
    this.id = const Value.absent(),
    this.seedKey = const Value.absent(),
    this.emoji = const Value.absent(),
    this.title = const Value.absent(),
    this.cost = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archivedAt = const Value.absent(),
  });
  RewardsCompanion.insert({
    this.id = const Value.absent(),
    this.seedKey = const Value.absent(),
    required String emoji,
    this.title = const Value.absent(),
    required int cost,
    required int sortOrder,
    this.archivedAt = const Value.absent(),
  }) : emoji = Value(emoji),
       cost = Value(cost),
       sortOrder = Value(sortOrder);
  static Insertable<Reward> custom({
    Expression<int>? id,
    Expression<String>? seedKey,
    Expression<String>? emoji,
    Expression<String>? title,
    Expression<int>? cost,
    Expression<int>? sortOrder,
    Expression<DateTime>? archivedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seedKey != null) 'seed_key': seedKey,
      if (emoji != null) 'emoji': emoji,
      if (title != null) 'title': title,
      if (cost != null) 'cost': cost,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (archivedAt != null) 'archived_at': archivedAt,
    });
  }

  RewardsCompanion copyWith({
    Value<int>? id,
    Value<String?>? seedKey,
    Value<String>? emoji,
    Value<String?>? title,
    Value<int>? cost,
    Value<int>? sortOrder,
    Value<DateTime?>? archivedAt,
  }) {
    return RewardsCompanion(
      id: id ?? this.id,
      seedKey: seedKey ?? this.seedKey,
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      cost: cost ?? this.cost,
      sortOrder: sortOrder ?? this.sortOrder,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seedKey.present) {
      map['seed_key'] = Variable<String>(seedKey.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardsCompanion(')
          ..write('id: $id, ')
          ..write('seedKey: $seedKey, ')
          ..write('emoji: $emoji, ')
          ..write('title: $title, ')
          ..write('cost: $cost, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }
}

class $RedemptionsTable extends Redemptions
    with TableInfo<$RedemptionsTable, Redemption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RedemptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kidIdMeta = const VerificationMeta('kidId');
  @override
  late final GeneratedColumn<int> kidId = GeneratedColumn<int>(
    'kid_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kids (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _rewardIdMeta = const VerificationMeta(
    'rewardId',
  );
  @override
  late final GeneratedColumn<int> rewardId = GeneratedColumn<int>(
    'reward_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rewards (id)',
    ),
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _redeemedAtMeta = const VerificationMeta(
    'redeemedAt',
  );
  @override
  late final GeneratedColumn<DateTime> redeemedAt = GeneratedColumn<DateTime>(
    'redeemed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kidId, rewardId, cost, redeemedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'redemptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Redemption> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kid_id')) {
      context.handle(
        _kidIdMeta,
        kidId.isAcceptableOrUnknown(data['kid_id']!, _kidIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kidIdMeta);
    }
    if (data.containsKey('reward_id')) {
      context.handle(
        _rewardIdMeta,
        rewardId.isAcceptableOrUnknown(data['reward_id']!, _rewardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rewardIdMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('redeemed_at')) {
      context.handle(
        _redeemedAtMeta,
        redeemedAt.isAcceptableOrUnknown(data['redeemed_at']!, _redeemedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_redeemedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Redemption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Redemption(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kidId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kid_id'],
      )!,
      rewardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reward_id'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost'],
      )!,
      redeemedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}redeemed_at'],
      )!,
    );
  }

  @override
  $RedemptionsTable createAlias(String alias) {
    return $RedemptionsTable(attachedDatabase, alias);
  }
}

class RedemptionsCompanion extends UpdateCompanion<Redemption> {
  final Value<int> id;
  final Value<int> kidId;
  final Value<int> rewardId;
  final Value<int> cost;
  final Value<DateTime> redeemedAt;
  const RedemptionsCompanion({
    this.id = const Value.absent(),
    this.kidId = const Value.absent(),
    this.rewardId = const Value.absent(),
    this.cost = const Value.absent(),
    this.redeemedAt = const Value.absent(),
  });
  RedemptionsCompanion.insert({
    this.id = const Value.absent(),
    required int kidId,
    required int rewardId,
    required int cost,
    required DateTime redeemedAt,
  }) : kidId = Value(kidId),
       rewardId = Value(rewardId),
       cost = Value(cost),
       redeemedAt = Value(redeemedAt);
  static Insertable<Redemption> custom({
    Expression<int>? id,
    Expression<int>? kidId,
    Expression<int>? rewardId,
    Expression<int>? cost,
    Expression<DateTime>? redeemedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kidId != null) 'kid_id': kidId,
      if (rewardId != null) 'reward_id': rewardId,
      if (cost != null) 'cost': cost,
      if (redeemedAt != null) 'redeemed_at': redeemedAt,
    });
  }

  RedemptionsCompanion copyWith({
    Value<int>? id,
    Value<int>? kidId,
    Value<int>? rewardId,
    Value<int>? cost,
    Value<DateTime>? redeemedAt,
  }) {
    return RedemptionsCompanion(
      id: id ?? this.id,
      kidId: kidId ?? this.kidId,
      rewardId: rewardId ?? this.rewardId,
      cost: cost ?? this.cost,
      redeemedAt: redeemedAt ?? this.redeemedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kidId.present) {
      map['kid_id'] = Variable<int>(kidId.value);
    }
    if (rewardId.present) {
      map['reward_id'] = Variable<int>(rewardId.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (redeemedAt.present) {
      map['redeemed_at'] = Variable<DateTime>(redeemedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RedemptionsCompanion(')
          ..write('id: $id, ')
          ..write('kidId: $kidId, ')
          ..write('rewardId: $rewardId, ')
          ..write('cost: $cost, ')
          ..write('redeemedAt: $redeemedAt')
          ..write(')'))
        .toString();
  }
}

class $WeekNotesTable extends WeekNotes
    with TableInfo<$WeekNotesTable, WeekNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeekNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kidIdMeta = const VerificationMeta('kidId');
  @override
  late final GeneratedColumn<int> kidId = GeneratedColumn<int>(
    'kid_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kids (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> weekStart =
      GeneratedColumn<String>(
        'week_start',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($WeekNotesTable.$converterweekStart);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [kidId, weekStart, body, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'week_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeekNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kid_id')) {
      context.handle(
        _kidIdMeta,
        kidId.isAcceptableOrUnknown(data['kid_id']!, _kidIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kidIdMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['text']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kidId, weekStart};
  @override
  WeekNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeekNote(
      kidId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kid_id'],
      )!,
      weekStart: $WeekNotesTable.$converterweekStart.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}week_start'],
        )!,
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WeekNotesTable createAlias(String alias) {
    return $WeekNotesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterweekStart =
      const DayConverter();
}

class WeekNotesCompanion extends UpdateCompanion<WeekNote> {
  final Value<int> kidId;
  final Value<DateTime> weekStart;
  final Value<String> body;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WeekNotesCompanion({
    this.kidId = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.body = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeekNotesCompanion.insert({
    required int kidId,
    required DateTime weekStart,
    required String body,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : kidId = Value(kidId),
       weekStart = Value(weekStart),
       body = Value(body),
       updatedAt = Value(updatedAt);
  static Insertable<WeekNote> custom({
    Expression<int>? kidId,
    Expression<String>? weekStart,
    Expression<String>? body,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kidId != null) 'kid_id': kidId,
      if (weekStart != null) 'week_start': weekStart,
      if (body != null) 'text': body,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeekNotesCompanion copyWith({
    Value<int>? kidId,
    Value<DateTime>? weekStart,
    Value<String>? body,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WeekNotesCompanion(
      kidId: kidId ?? this.kidId,
      weekStart: weekStart ?? this.weekStart,
      body: body ?? this.body,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kidId.present) {
      map['kid_id'] = Variable<int>(kidId.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<String>(
        $WeekNotesTable.$converterweekStart.toSql(weekStart.value),
      );
    }
    if (body.present) {
      map['text'] = Variable<String>(body.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeekNotesCompanion(')
          ..write('kidId: $kidId, ')
          ..write('weekStart: $weekStart, ')
          ..write('body: $body, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $KidsTable kids = $KidsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $CompletionsTable completions = $CompletionsTable(this);
  late final $RewardsTable rewards = $RewardsTable(this);
  late final $RedemptionsTable redemptions = $RedemptionsTable(this);
  late final $WeekNotesTable weekNotes = $WeekNotesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    kids,
    tasks,
    completions,
    rewards,
    redemptions,
    weekNotes,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'kids',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('completions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'kids',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('redemptions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'kids',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('week_notes', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$KidsTableCreateCompanionBuilder = KidsCompanion Function({
  Value<int> id,
  Value<String?> seedKey,
  Value<String?> name,
  required int sortOrder,
  required DateTime createdAt,
});
typedef $$KidsTableUpdateCompanionBuilder = KidsCompanion Function({
  Value<int> id,
  Value<String?> seedKey,
  Value<String?> name,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
});

final class $$KidsTableReferences
    extends BaseReferences<_$AppDatabase, $KidsTable, Kid> {
  $$KidsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CompletionsTable, List<Completion>>
  _completionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.completions,
    aliasName: 'kids__id__completions__kid_id',
  );

  $$CompletionsTableProcessedTableManager get completionsRefs {
    final manager = $$CompletionsTableTableManager(
      $_db,
      $_db.completions,
    ).filter((f) => f.kidId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_completionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RedemptionsTable, List<Redemption>>
  _redemptionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.redemptions,
    aliasName: 'kids__id__redemptions__kid_id',
  );

  $$RedemptionsTableProcessedTableManager get redemptionsRefs {
    final manager = $$RedemptionsTableTableManager(
      $_db,
      $_db.redemptions,
    ).filter((f) => f.kidId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_redemptionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WeekNotesTable, List<WeekNote>>
  _weekNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weekNotes,
    aliasName: 'kids__id__week_notes__kid_id',
  );

  $$WeekNotesTableProcessedTableManager get weekNotesRefs {
    final manager = $$WeekNotesTableTableManager(
      $_db,
      $_db.weekNotes,
    ).filter((f) => f.kidId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_weekNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KidsTableFilterComposer extends Composer<_$AppDatabase, $KidsTable> {
  $$KidsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> completionsRefs(
    Expression<bool> Function($$CompletionsTableFilterComposer f) f,
  ) {
    final $$CompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completions,
      getReferencedColumn: (t) => t.kidId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletionsTableFilterComposer(
            $db: $db,
            $table: $db.completions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> redemptionsRefs(
    Expression<bool> Function($$RedemptionsTableFilterComposer f) f,
  ) {
    final $$RedemptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.redemptions,
      getReferencedColumn: (t) => t.kidId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RedemptionsTableFilterComposer(
            $db: $db,
            $table: $db.redemptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weekNotesRefs(
    Expression<bool> Function($$WeekNotesTableFilterComposer f) f,
  ) {
    final $$WeekNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weekNotes,
      getReferencedColumn: (t) => t.kidId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeekNotesTableFilterComposer(
            $db: $db,
            $table: $db.weekNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KidsTableOrderingComposer extends Composer<_$AppDatabase, $KidsTable> {
  $$KidsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KidsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KidsTable> {
  $$KidsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get seedKey =>
      $composableBuilder(column: $table.seedKey, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> completionsRefs<T extends Object>(
    Expression<T> Function($$CompletionsTableAnnotationComposer a) f,
  ) {
    final $$CompletionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completions,
      getReferencedColumn: (t) => t.kidId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletionsTableAnnotationComposer(
            $db: $db,
            $table: $db.completions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> redemptionsRefs<T extends Object>(
    Expression<T> Function($$RedemptionsTableAnnotationComposer a) f,
  ) {
    final $$RedemptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.redemptions,
      getReferencedColumn: (t) => t.kidId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RedemptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.redemptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> weekNotesRefs<T extends Object>(
    Expression<T> Function($$WeekNotesTableAnnotationComposer a) f,
  ) {
    final $$WeekNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weekNotes,
      getReferencedColumn: (t) => t.kidId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeekNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.weekNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KidsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KidsTable,
          Kid,
          $$KidsTableFilterComposer,
          $$KidsTableOrderingComposer,
          $$KidsTableAnnotationComposer,
          $$KidsTableCreateCompanionBuilder,
          $$KidsTableUpdateCompanionBuilder,
          (Kid, $$KidsTableReferences),
          Kid,
          PrefetchHooks Function({
            bool completionsRefs,
            bool redemptionsRefs,
            bool weekNotesRefs,
          })
        > {
  $$KidsTableTableManager(_$AppDatabase db, $KidsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KidsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KidsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KidsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> seedKey = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => KidsCompanion(
                id: id,
                seedKey: seedKey,
                name: name,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> seedKey = const Value.absent(),
                Value<String?> name = const Value.absent(),
                required int sortOrder,
                required DateTime createdAt,
              }) => KidsCompanion.insert(
                id: id,
                seedKey: seedKey,
                name: name,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KidsTable, Kid>(table),
                  $$KidsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                completionsRefs = false,
                redemptionsRefs = false,
                weekNotesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (completionsRefs) db.completions,
                    if (redemptionsRefs) db.redemptions,
                    if (weekNotesRefs) db.weekNotes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (completionsRefs)
                        await $_getPrefetchedDataByColumns<
                          Kid,
                          $KidsTable,
                          Completion,
                          $CompletionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$KidsTableReferences
                              ._completionsRefsTable(db),
                          managerFromTypedResult: (p0) => $$KidsTableReferences(
                            db,
                            table,
                            p0,
                          ).completionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'kid_id',
                          typedResults: items,
                        ),
                      if (redemptionsRefs)
                        await $_getPrefetchedDataByColumns<
                          Kid,
                          $KidsTable,
                          Redemption,
                          $RedemptionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$KidsTableReferences
                              ._redemptionsRefsTable(db),
                          managerFromTypedResult: (p0) => $$KidsTableReferences(
                            db,
                            table,
                            p0,
                          ).redemptionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'kid_id',
                          typedResults: items,
                        ),
                      if (weekNotesRefs)
                        await $_getPrefetchedDataByColumns<
                          Kid,
                          $KidsTable,
                          WeekNote,
                          $WeekNotesTable
                        >(
                          currentTable: table,
                          referencedTable: $$KidsTableReferences
                              ._weekNotesRefsTable(db),
                          managerFromTypedResult: (p0) => $$KidsTableReferences(
                            db,
                            table,
                            p0,
                          ).weekNotesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'kid_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$KidsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KidsTable,
      Kid,
      $$KidsTableFilterComposer,
      $$KidsTableOrderingComposer,
      $$KidsTableAnnotationComposer,
      $$KidsTableCreateCompanionBuilder,
      $$KidsTableUpdateCompanionBuilder,
      (Kid, $$KidsTableReferences),
      Kid,
      PrefetchHooks Function({
        bool completionsRefs,
        bool redemptionsRefs,
        bool weekNotesRefs,
      })
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  Value<String?> seedKey,
  required String emoji,
  Value<String?> title,
  required int points,
  required TaskType type,
  required int sortOrder,
  required DateTime createdAt,
  Value<DateTime?> archivedAt,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  Value<String?> seedKey,
  Value<String> emoji,
  Value<String?> title,
  Value<int> points,
  Value<TaskType> type,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime?> archivedAt,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, TaskItem> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CompletionsTable, List<Completion>>
  _completionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.completions,
    aliasName: 'tasks__id__completions__task_id',
  );

  $$CompletionsTableProcessedTableManager get completionsRefs {
    final manager = $$CompletionsTableTableManager(
      $_db,
      $_db.completions,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_completionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskType, TaskType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> completionsRefs(
    Expression<bool> Function($$CompletionsTableFilterComposer f) f,
  ) {
    final $$CompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completions,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletionsTableFilterComposer(
            $db: $db,
            $table: $db.completions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get seedKey =>
      $composableBuilder(column: $table.seedKey, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> completionsRefs<T extends Object>(
    Expression<T> Function($$CompletionsTableAnnotationComposer a) f,
  ) {
    final $$CompletionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completions,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletionsTableAnnotationComposer(
            $db: $db,
            $table: $db.completions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          TaskItem,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TaskItem, $$TasksTableReferences),
          TaskItem,
          PrefetchHooks Function({bool completionsRefs})
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> seedKey = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<TaskType> type = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                seedKey: seedKey,
                emoji: emoji,
                title: title,
                points: points,
                type: type,
                sortOrder: sortOrder,
                createdAt: createdAt,
                archivedAt: archivedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> seedKey = const Value.absent(),
                required String emoji,
                Value<String?> title = const Value.absent(),
                required int points,
                required TaskType type,
                required int sortOrder,
                required DateTime createdAt,
                Value<DateTime?> archivedAt = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                seedKey: seedKey,
                emoji: emoji,
                title: title,
                points: points,
                type: type,
                sortOrder: sortOrder,
                createdAt: createdAt,
                archivedAt: archivedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, TaskItem>(table),
                  $$TasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({completionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (completionsRefs) db.completions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (completionsRefs)
                    await $_getPrefetchedDataByColumns<
                      TaskItem,
                      $TasksTable,
                      Completion,
                      $CompletionsTable
                    >(
                      currentTable: table,
                      referencedTable: $$TasksTableReferences
                          ._completionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TasksTableReferences(db, table, p0).completionsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'task_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      TaskItem,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TaskItem, $$TasksTableReferences),
      TaskItem,
      PrefetchHooks Function({bool completionsRefs})
    >;
typedef $$CompletionsTableCreateCompanionBuilder =
    CompletionsCompanion Function({
      Value<int> id,
      required int kidId,
      required int taskId,
      required DateTime date,
      required int points,
      required DateTime createdAt,
    });
typedef $$CompletionsTableUpdateCompanionBuilder =
    CompletionsCompanion Function({
      Value<int> id,
      Value<int> kidId,
      Value<int> taskId,
      Value<DateTime> date,
      Value<int> points,
      Value<DateTime> createdAt,
    });

final class $$CompletionsTableReferences
    extends BaseReferences<_$AppDatabase, $CompletionsTable, Completion> {
  $$CompletionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $KidsTable _kidIdTable(_$AppDatabase db) =>
      db.kids.createAlias('completions__kid_id__kids__id');

  $$KidsTableProcessedTableManager get kidId {
    final $_column = $_itemColumn<int>('kid_id')!;

    final manager = $$KidsTableTableManager(
      $_db,
      $_db.kids,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kidIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('completions__task_id__tasks__id');

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<int>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $CompletionsTable> {
  $$CompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get date =>
      $composableBuilder(
        column: $table.date,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$KidsTableFilterComposer get kidId {
    final $$KidsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidId,
      referencedTable: $db.kids,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidsTableFilterComposer(
            $db: $db,
            $table: $db.kids,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompletionsTable> {
  $$CompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$KidsTableOrderingComposer get kidId {
    final $$KidsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidId,
      referencedTable: $db.kids,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidsTableOrderingComposer(
            $db: $db,
            $table: $db.kids,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompletionsTable> {
  $$CompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$KidsTableAnnotationComposer get kidId {
    final $$KidsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidId,
      referencedTable: $db.kids,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidsTableAnnotationComposer(
            $db: $db,
            $table: $db.kids,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompletionsTable,
          Completion,
          $$CompletionsTableFilterComposer,
          $$CompletionsTableOrderingComposer,
          $$CompletionsTableAnnotationComposer,
          $$CompletionsTableCreateCompanionBuilder,
          $$CompletionsTableUpdateCompanionBuilder,
          (Completion, $$CompletionsTableReferences),
          Completion,
          PrefetchHooks Function({bool kidId, bool taskId})
        > {
  $$CompletionsTableTableManager(_$AppDatabase db, $CompletionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> kidId = const Value.absent(),
                Value<int> taskId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CompletionsCompanion(
                id: id,
                kidId: kidId,
                taskId: taskId,
                date: date,
                points: points,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int kidId,
                required int taskId,
                required DateTime date,
                required int points,
                required DateTime createdAt,
              }) => CompletionsCompanion.insert(
                id: id,
                kidId: kidId,
                taskId: taskId,
                date: date,
                points: points,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CompletionsTable, Completion>(table),
                  $$CompletionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({kidId = false, taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (kidId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.kidId,
                        referencedTable: $$CompletionsTableReferences
                            ._kidIdTable(db),
                        referencedColumn: $$CompletionsTableReferences
                            ._kidIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$CompletionsTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$CompletionsTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompletionsTable,
      Completion,
      $$CompletionsTableFilterComposer,
      $$CompletionsTableOrderingComposer,
      $$CompletionsTableAnnotationComposer,
      $$CompletionsTableCreateCompanionBuilder,
      $$CompletionsTableUpdateCompanionBuilder,
      (Completion, $$CompletionsTableReferences),
      Completion,
      PrefetchHooks Function({bool kidId, bool taskId})
    >;
typedef $$RewardsTableCreateCompanionBuilder = RewardsCompanion Function({
  Value<int> id,
  Value<String?> seedKey,
  required String emoji,
  Value<String?> title,
  required int cost,
  required int sortOrder,
  Value<DateTime?> archivedAt,
});
typedef $$RewardsTableUpdateCompanionBuilder = RewardsCompanion Function({
  Value<int> id,
  Value<String?> seedKey,
  Value<String> emoji,
  Value<String?> title,
  Value<int> cost,
  Value<int> sortOrder,
  Value<DateTime?> archivedAt,
});

final class $$RewardsTableReferences
    extends BaseReferences<_$AppDatabase, $RewardsTable, Reward> {
  $$RewardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RedemptionsTable, List<Redemption>>
  _redemptionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.redemptions,
    aliasName: 'rewards__id__redemptions__reward_id',
  );

  $$RedemptionsTableProcessedTableManager get redemptionsRefs {
    final manager = $$RedemptionsTableTableManager(
      $_db,
      $_db.redemptions,
    ).filter((f) => f.rewardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_redemptionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RewardsTableFilterComposer
    extends Composer<_$AppDatabase, $RewardsTable> {
  $$RewardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> redemptionsRefs(
    Expression<bool> Function($$RedemptionsTableFilterComposer f) f,
  ) {
    final $$RedemptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.redemptions,
      getReferencedColumn: (t) => t.rewardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RedemptionsTableFilterComposer(
            $db: $db,
            $table: $db.redemptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RewardsTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardsTable> {
  $$RewardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RewardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardsTable> {
  $$RewardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get seedKey =>
      $composableBuilder(column: $table.seedKey, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> redemptionsRefs<T extends Object>(
    Expression<T> Function($$RedemptionsTableAnnotationComposer a) f,
  ) {
    final $$RedemptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.redemptions,
      getReferencedColumn: (t) => t.rewardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RedemptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.redemptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RewardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardsTable,
          Reward,
          $$RewardsTableFilterComposer,
          $$RewardsTableOrderingComposer,
          $$RewardsTableAnnotationComposer,
          $$RewardsTableCreateCompanionBuilder,
          $$RewardsTableUpdateCompanionBuilder,
          (Reward, $$RewardsTableReferences),
          Reward,
          PrefetchHooks Function({bool redemptionsRefs})
        > {
  $$RewardsTableTableManager(_$AppDatabase db, $RewardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> seedKey = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<int> cost = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
              }) => RewardsCompanion(
                id: id,
                seedKey: seedKey,
                emoji: emoji,
                title: title,
                cost: cost,
                sortOrder: sortOrder,
                archivedAt: archivedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> seedKey = const Value.absent(),
                required String emoji,
                Value<String?> title = const Value.absent(),
                required int cost,
                required int sortOrder,
                Value<DateTime?> archivedAt = const Value.absent(),
              }) => RewardsCompanion.insert(
                id: id,
                seedKey: seedKey,
                emoji: emoji,
                title: title,
                cost: cost,
                sortOrder: sortOrder,
                archivedAt: archivedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RewardsTable, Reward>(table),
                  $$RewardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({redemptionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (redemptionsRefs) db.redemptions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (redemptionsRefs)
                    await $_getPrefetchedDataByColumns<
                      Reward,
                      $RewardsTable,
                      Redemption,
                      $RedemptionsTable
                    >(
                      currentTable: table,
                      referencedTable: $$RewardsTableReferences
                          ._redemptionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$RewardsTableReferences(
                        db,
                        table,
                        p0,
                      ).redemptionsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'reward_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RewardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardsTable,
      Reward,
      $$RewardsTableFilterComposer,
      $$RewardsTableOrderingComposer,
      $$RewardsTableAnnotationComposer,
      $$RewardsTableCreateCompanionBuilder,
      $$RewardsTableUpdateCompanionBuilder,
      (Reward, $$RewardsTableReferences),
      Reward,
      PrefetchHooks Function({bool redemptionsRefs})
    >;
typedef $$RedemptionsTableCreateCompanionBuilder =
    RedemptionsCompanion Function({
      Value<int> id,
      required int kidId,
      required int rewardId,
      required int cost,
      required DateTime redeemedAt,
    });
typedef $$RedemptionsTableUpdateCompanionBuilder =
    RedemptionsCompanion Function({
      Value<int> id,
      Value<int> kidId,
      Value<int> rewardId,
      Value<int> cost,
      Value<DateTime> redeemedAt,
    });

final class $$RedemptionsTableReferences
    extends BaseReferences<_$AppDatabase, $RedemptionsTable, Redemption> {
  $$RedemptionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $KidsTable _kidIdTable(_$AppDatabase db) =>
      db.kids.createAlias('redemptions__kid_id__kids__id');

  $$KidsTableProcessedTableManager get kidId {
    final $_column = $_itemColumn<int>('kid_id')!;

    final manager = $$KidsTableTableManager(
      $_db,
      $_db.kids,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kidIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RewardsTable _rewardIdTable(_$AppDatabase db) =>
      db.rewards.createAlias('redemptions__reward_id__rewards__id');

  $$RewardsTableProcessedTableManager get rewardId {
    final $_column = $_itemColumn<int>('reward_id')!;

    final manager = $$RewardsTableTableManager(
      $_db,
      $_db.rewards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rewardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RedemptionsTableFilterComposer
    extends Composer<_$AppDatabase, $RedemptionsTable> {
  $$RedemptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get redeemedAt => $composableBuilder(
    column: $table.redeemedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$KidsTableFilterComposer get kidId {
    final $$KidsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidId,
      referencedTable: $db.kids,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidsTableFilterComposer(
            $db: $db,
            $table: $db.kids,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RewardsTableFilterComposer get rewardId {
    final $$RewardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardId,
      referencedTable: $db.rewards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardsTableFilterComposer(
            $db: $db,
            $table: $db.rewards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RedemptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RedemptionsTable> {
  $$RedemptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get redeemedAt => $composableBuilder(
    column: $table.redeemedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$KidsTableOrderingComposer get kidId {
    final $$KidsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidId,
      referencedTable: $db.kids,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidsTableOrderingComposer(
            $db: $db,
            $table: $db.kids,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RewardsTableOrderingComposer get rewardId {
    final $$RewardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardId,
      referencedTable: $db.rewards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardsTableOrderingComposer(
            $db: $db,
            $table: $db.rewards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RedemptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RedemptionsTable> {
  $$RedemptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<DateTime> get redeemedAt => $composableBuilder(
    column: $table.redeemedAt,
    builder: (column) => column,
  );

  $$KidsTableAnnotationComposer get kidId {
    final $$KidsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidId,
      referencedTable: $db.kids,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidsTableAnnotationComposer(
            $db: $db,
            $table: $db.kids,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RewardsTableAnnotationComposer get rewardId {
    final $$RewardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardId,
      referencedTable: $db.rewards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardsTableAnnotationComposer(
            $db: $db,
            $table: $db.rewards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RedemptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RedemptionsTable,
          Redemption,
          $$RedemptionsTableFilterComposer,
          $$RedemptionsTableOrderingComposer,
          $$RedemptionsTableAnnotationComposer,
          $$RedemptionsTableCreateCompanionBuilder,
          $$RedemptionsTableUpdateCompanionBuilder,
          (Redemption, $$RedemptionsTableReferences),
          Redemption,
          PrefetchHooks Function({bool kidId, bool rewardId})
        > {
  $$RedemptionsTableTableManager(_$AppDatabase db, $RedemptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RedemptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RedemptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RedemptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> kidId = const Value.absent(),
                Value<int> rewardId = const Value.absent(),
                Value<int> cost = const Value.absent(),
                Value<DateTime> redeemedAt = const Value.absent(),
              }) => RedemptionsCompanion(
                id: id,
                kidId: kidId,
                rewardId: rewardId,
                cost: cost,
                redeemedAt: redeemedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int kidId,
                required int rewardId,
                required int cost,
                required DateTime redeemedAt,
              }) => RedemptionsCompanion.insert(
                id: id,
                kidId: kidId,
                rewardId: rewardId,
                cost: cost,
                redeemedAt: redeemedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RedemptionsTable, Redemption>(table),
                  $$RedemptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({kidId = false, rewardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (kidId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.kidId,
                        referencedTable: $$RedemptionsTableReferences
                            ._kidIdTable(db),
                        referencedColumn: $$RedemptionsTableReferences
                            ._kidIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (rewardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.rewardId,
                        referencedTable: $$RedemptionsTableReferences
                            ._rewardIdTable(db),
                        referencedColumn: $$RedemptionsTableReferences
                            ._rewardIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RedemptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RedemptionsTable,
      Redemption,
      $$RedemptionsTableFilterComposer,
      $$RedemptionsTableOrderingComposer,
      $$RedemptionsTableAnnotationComposer,
      $$RedemptionsTableCreateCompanionBuilder,
      $$RedemptionsTableUpdateCompanionBuilder,
      (Redemption, $$RedemptionsTableReferences),
      Redemption,
      PrefetchHooks Function({bool kidId, bool rewardId})
    >;
typedef $$WeekNotesTableCreateCompanionBuilder = WeekNotesCompanion Function({
  required int kidId,
  required DateTime weekStart,
  required String body,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$WeekNotesTableUpdateCompanionBuilder = WeekNotesCompanion Function({
  Value<int> kidId,
  Value<DateTime> weekStart,
  Value<String> body,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$WeekNotesTableReferences
    extends BaseReferences<_$AppDatabase, $WeekNotesTable, WeekNote> {
  $$WeekNotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $KidsTable _kidIdTable(_$AppDatabase db) =>
      db.kids.createAlias('week_notes__kid_id__kids__id');

  $$KidsTableProcessedTableManager get kidId {
    final $_column = $_itemColumn<int>('kid_id')!;

    final manager = $$KidsTableTableManager(
      $_db,
      $_db.kids,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kidIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeekNotesTableFilterComposer
    extends Composer<_$AppDatabase, $WeekNotesTable> {
  $$WeekNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get weekStart =>
      $composableBuilder(
        column: $table.weekStart,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$KidsTableFilterComposer get kidId {
    final $$KidsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidId,
      referencedTable: $db.kids,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidsTableFilterComposer(
            $db: $db,
            $table: $db.kids,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeekNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeekNotesTable> {
  $$WeekNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$KidsTableOrderingComposer get kidId {
    final $$KidsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidId,
      referencedTable: $db.kids,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidsTableOrderingComposer(
            $db: $db,
            $table: $db.kids,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeekNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeekNotesTable> {
  $$WeekNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<DateTime, String> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$KidsTableAnnotationComposer get kidId {
    final $$KidsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kidId,
      referencedTable: $db.kids,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KidsTableAnnotationComposer(
            $db: $db,
            $table: $db.kids,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeekNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeekNotesTable,
          WeekNote,
          $$WeekNotesTableFilterComposer,
          $$WeekNotesTableOrderingComposer,
          $$WeekNotesTableAnnotationComposer,
          $$WeekNotesTableCreateCompanionBuilder,
          $$WeekNotesTableUpdateCompanionBuilder,
          (WeekNote, $$WeekNotesTableReferences),
          WeekNote,
          PrefetchHooks Function({bool kidId})
        > {
  $$WeekNotesTableTableManager(_$AppDatabase db, $WeekNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeekNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeekNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeekNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> kidId = const Value.absent(),
                Value<DateTime> weekStart = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeekNotesCompanion(
                kidId: kidId,
                weekStart: weekStart,
                body: body,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int kidId,
                required DateTime weekStart,
                required String body,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WeekNotesCompanion.insert(
                kidId: kidId,
                weekStart: weekStart,
                body: body,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeekNotesTable, WeekNote>(table),
                  $$WeekNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({kidId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (kidId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.kidId,
                        referencedTable: $$WeekNotesTableReferences._kidIdTable(
                          db,
                        ),
                        referencedColumn: $$WeekNotesTableReferences
                            ._kidIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeekNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeekNotesTable,
      WeekNote,
      $$WeekNotesTableFilterComposer,
      $$WeekNotesTableOrderingComposer,
      $$WeekNotesTableAnnotationComposer,
      $$WeekNotesTableCreateCompanionBuilder,
      $$WeekNotesTableUpdateCompanionBuilder,
      (WeekNote, $$WeekNotesTableReferences),
      WeekNote,
      PrefetchHooks Function({bool kidId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$KidsTableTableManager get kids => $$KidsTableTableManager(_db, _db.kids);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$CompletionsTableTableManager get completions =>
      $$CompletionsTableTableManager(_db, _db.completions);
  $$RewardsTableTableManager get rewards =>
      $$RewardsTableTableManager(_db, _db.rewards);
  $$RedemptionsTableTableManager get redemptions =>
      $$RedemptionsTableTableManager(_db, _db.redemptions);
  $$WeekNotesTableTableManager get weekNotes =>
      $$WeekNotesTableTableManager(_db, _db.weekNotes);
}
