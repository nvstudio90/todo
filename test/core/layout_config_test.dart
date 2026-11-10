import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/core/layout/breakpoints.dart';
import 'package:todo/core/layout/layout_config.dart';

void main() {
  group('LayoutClass.fromShortestSide', () {
    for (final (side, expected) in [
      (344.0, LayoutClass.compact),
      (599.9, LayoutClass.compact),
      (600.0, LayoutClass.medium),
      (690.0, LayoutClass.medium),
      (720.0, LayoutClass.expanded),
      (768.0, LayoutClass.expanded),
      (800.0, LayoutClass.large),
      (1032.0, LayoutClass.large),
    ]) {
      test('$side → ${expected.name}', () {
        expect(LayoutClass.fromShortestSide(side), expected);
      });
    }
  });

  group('LayoutConfig.fromSize', () {
    test('phone portrait uses tabs and two reward columns', () {
      final c = LayoutConfig.fromSize(const Size(411, 914));
      expect(c.layoutClass, LayoutClass.compact);
      expect(c.orientation, Orientation.portrait);
      expect(c.usesTabs, isTrue);
      expect(c.rewardColumns, 2);
      expect(c.displayLargeSize, 36);
      expect(c.sideColumnWidth, isNull);
      expect(c.dialogMaxWidth, isNull);
    });

    test('phone landscape stays compact with a smaller title', () {
      final c = LayoutConfig.fromSize(const Size(914, 411));
      expect(c.layoutClass, LayoutClass.compact);
      expect(c.isLandscape, isTrue);
      expect(c.rewardColumns, 3);
      expect(c.displayLargeSize, 28);
    });

    test('fold outer screen is compact, inner screen is medium', () {
      expect(LayoutConfig.fromSize(const Size(344, 882)).usesTabs, isTrue);
      final inner = LayoutConfig.fromSize(const Size(690, 829));
      expect(inner.layoutClass, LayoutClass.medium);
      expect(inner.usesTabs, isFalse);
      expect(inner.dialogMaxWidth, 480);
    });

    test('tablet landscape gets a side column', () {
      final c = LayoutConfig.fromSize(const Size(1024, 768));
      expect(c.layoutClass, LayoutClass.expanded);
      expect(c.sideColumnWidth, 300);
      expect(c.rewardColumns, 1);
    });

    test('large tablet caps content width per orientation', () {
      expect(LayoutConfig.fromSize(const Size(800, 1280)).maxContentWidth, 960);
      expect(
        LayoutConfig.fromSize(const Size(1280, 800)).maxContentWidth,
        1200,
      );
      expect(
        LayoutConfig.fromSize(const Size(768, 1024)).maxContentWidth,
        isNull,
      );
    });

    test('spacing grows with the device group', () {
      final margins = [
        for (final s in const [
          Size(400, 800),
          Size(600, 960),
          Size(768, 1024),
          Size(800, 1280),
        ])
          LayoutConfig.fromSize(s).screenMargin,
      ];
      expect(margins, [16, 20, 24, 24]);
    });
  });
}
