import 'package:flutter/widgets.dart';

import 'breakpoints.dart';

/// Every size that differs per device group; see design-system.md, 6.3–6.4.
@immutable
class LayoutConfig {
  const LayoutConfig._({
    required this.layoutClass,
    required this.orientation,
    required this.screenMargin,
    required this.cardPadding,
    required this.cardGap,
    required this.taskNameColumnWidth,
    required this.dayColumnMinWidth,
    required this.sideColumnWidth,
    required this.dialogMaxWidth,
    required this.displayLargeSize,
    required this.maxContentWidth,
    required this.rewardColumns,
  });

  factory LayoutConfig.fromSize(Size size) {
    final layoutClass = LayoutClass.fromShortestSide(size.shortestSide);
    final orientation = size.width > size.height
        ? Orientation.landscape
        : Orientation.portrait;
    final landscape = orientation == Orientation.landscape;

    T pick<T>(T compact, T medium, T expanded, T large) =>
        switch (layoutClass) {
          LayoutClass.compact => compact,
          LayoutClass.medium => medium,
          LayoutClass.expanded => expanded,
          LayoutClass.large => large,
        };

    return LayoutConfig._(
      layoutClass: layoutClass,
      orientation: orientation,
      screenMargin: pick(16, 20, 24, 24),
      cardPadding: pick(16, 16, 20, 20),
      cardGap: pick(12, 16, 16, 20),
      taskNameColumnWidth: pick(168, 220, 240, 260),
      dayColumnMinWidth: pick(44, 48, 52, 56),
      sideColumnWidth: landscape ? pick(null, 280, 300, 320) : null,
      dialogMaxWidth: pick(null, 480, 520, 560),
      displayLargeSize: pick(landscape ? 28 : 36, 36, 40, 40),
      maxContentWidth: layoutClass == LayoutClass.large
          ? (landscape ? 1200 : 960)
          : null,
      rewardColumns: layoutClass == LayoutClass.compact
          ? (landscape ? 3 : 2)
          : (landscape ? 1 : 3),
    );
  }

  static LayoutConfig of(BuildContext context) =>
      LayoutConfig.fromSize(MediaQuery.sizeOf(context));

  final LayoutClass layoutClass;
  final Orientation orientation;
  final double screenMargin;
  final double cardPadding;
  final double cardGap;
  final double taskNameColumnWidth;
  final double dayColumnMinWidth;

  /// Width of the right-hand column; null when there is none.
  final double? sideColumnWidth;

  /// Null means sheets and dialogs span the screen.
  final double? dialogMaxWidth;
  final double displayLargeSize;
  final double? maxContentWidth;
  final int rewardColumns;

  bool get isCompact => layoutClass == LayoutClass.compact;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get usesTabs => isCompact;

  @override
  bool operator ==(Object other) =>
      other is LayoutConfig &&
      other.layoutClass == layoutClass &&
      other.orientation == orientation;

  @override
  int get hashCode => Object.hash(layoutClass, orientation);
}
