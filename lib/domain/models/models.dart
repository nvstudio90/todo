import 'package:flutter/foundation.dart';

import '../../core/utils/dates.dart';

enum TaskType { mustDo, optional }

@immutable
class Kid {
  const Kid({
    required this.id,
    this.seedKey,
    this.name,
    required this.sortOrder,
    required this.createdAt,
  });

  final int id;

  /// Set on rows the app seeded; their text comes from the ARB files until a
  /// parent edits it.
  final String? seedKey;
  final String? name;
  final int sortOrder;
  final DateTime createdAt;
}

@immutable
class TaskItem {
  const TaskItem({
    required this.id,
    this.seedKey,
    required this.emoji,
    this.title,
    required this.points,
    required this.type,
    required this.sortOrder,
    required this.createdAt,
    this.archivedAt,
  });

  final int id;
  final String? seedKey;
  final String emoji;
  final String? title;
  final int points;
  final TaskType type;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime? archivedAt;

  bool get isArchived => archivedAt != null;

  /// A task counts toward a day's must-do list from the day it was created
  /// until the day it was removed (exclusive).
  bool isActiveOn(DateTime day) {
    final d = Dates.dateOnly(day);
    if (Dates.dateOnly(createdAt).isAfter(d)) return false;
    final archived = archivedAt;
    return archived == null || Dates.dateOnly(archived).isAfter(d);
  }
}

@immutable
class Completion {
  const Completion({
    required this.id,
    required this.kidId,
    required this.taskId,
    required this.date,
    required this.points,
    required this.createdAt,
  });

  final int id;
  final int kidId;
  final int taskId;
  final DateTime date;

  /// The task's points when the star was given, so later edits keep history.
  final int points;
  final DateTime createdAt;
}

@immutable
class Reward {
  const Reward({
    required this.id,
    this.seedKey,
    required this.emoji,
    this.title,
    required this.cost,
    required this.sortOrder,
    this.archivedAt,
  });

  final int id;
  final String? seedKey;
  final String emoji;
  final String? title;
  final int cost;
  final int sortOrder;
  final DateTime? archivedAt;

  bool get isArchived => archivedAt != null;
}

@immutable
class Redemption {
  const Redemption({
    required this.id,
    required this.kidId,
    required this.rewardId,
    required this.cost,
    required this.redeemedAt,
  });

  final int id;
  final int kidId;
  final int rewardId;
  final int cost;
  final DateTime redeemedAt;
}

@immutable
class WeekNote {
  const WeekNote({
    required this.kidId,
    required this.weekStart,
    required this.body,
    required this.updatedAt,
  });

  final int kidId;
  final DateTime weekStart;
  final String body;
  final DateTime updatedAt;
}
