import 'package:flutter/foundation.dart';

@immutable
class LevelInfo {
  const LevelInfo({
    required this.number,
    required this.emoji,
    required this.seedKey,
    required this.minPoints,
    this.maxPoints,
  });

  final int number;
  final String emoji;
  final String seedKey;
  final int minPoints;

  /// Null for the top level, which has no ceiling.
  final int? maxPoints;
}

const levels = [
  LevelInfo(
    number: 1,
    emoji: '🌱',
    seedKey: 'level1',
    minPoints: 0,
    maxPoints: 49,
  ),
  LevelInfo(
    number: 2,
    emoji: '🌿',
    seedKey: 'level2',
    minPoints: 50,
    maxPoints: 99,
  ),
  LevelInfo(
    number: 3,
    emoji: '🪴',
    seedKey: 'level3',
    minPoints: 100,
    maxPoints: 149,
  ),
  LevelInfo(number: 4, emoji: '🌳', seedKey: 'level4', minPoints: 150),
];

@immutable
class LevelProgress {
  const LevelProgress._(this.current, this.next, this.points);

  factory LevelProgress.forPoints(int totalEarned) {
    final index = levels.lastIndexWhere((l) => totalEarned >= l.minPoints);
    final current = levels[index < 0 ? 0 : index];
    final next = current.number < levels.length ? levels[current.number] : null;
    return LevelProgress._(current, next, totalEarned);
  }

  final LevelInfo current;
  final LevelInfo? next;
  final int points;

  int get pointsToNext => next == null ? 0 : next!.minPoints - points;

  /// Share of the way from the current level to the next, 1 at the top.
  double get fraction {
    final n = next;
    if (n == null) return 1;
    final span = n.minPoints - current.minPoints;
    return ((points - current.minPoints) / span).clamp(0, 1).toDouble();
  }
}
