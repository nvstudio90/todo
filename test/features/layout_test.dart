import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/core/layout/layout_config.dart';
import 'package:todo/features/home/dashboard_screen.dart';
import 'package:todo/features/progress/notes_card.dart';
import 'package:todo/widgets/star_toggle.dart';

import '../helpers/pump_app.dart';

/// Opens every screen on every device group and orientation; any overflow or
/// layout error fails the test.
void main() {
  for (final (locale, label) in const [
    (Locale('vi', 'VN'), 'vi'),
    (Locale('en', 'US'), 'en'),
  ]) {
    for (final MapEntry(key: name, value: size) in screenSizes.entries) {
      testWidgets('$name ($label) lays out every screen', (tester) async {
        await pumpTodoApp(tester, size: size, deviceLocales: [locale]);
        final usesTabs = LayoutConfig.fromSize(size).usesTabs;

        expect(find.byType(StarToggle), findsWidgets);
        if (!usesTabs) {
          expect(find.byType(DashboardScreen), findsOneWidget);
          await scrollThroughPage(tester);
          expect(find.byType(NotesCard), findsOneWidget);
          return;
        }

        final nav = size.width > size.height
            ? find.byType(NavigationRail)
            : find.byType(NavigationBar);
        expect(nav, findsOneWidget);
        for (final icon in const [
          Icons.today_outlined,
          Icons.calendar_view_week_outlined,
          Icons.card_giftcard_outlined,
          Icons.emoji_events_outlined,
        ]) {
          final destination = find.descendant(
            of: nav,
            matching: find.byIcon(icon),
          );
          if (destination.evaluate().isNotEmpty) {
            await tester.tap(destination);
            await tester.pumpAndSettle();
          }
          await scrollThroughPage(tester);
        }
        expect(find.byType(NotesCard), findsOneWidget);
      });
    }
  }

  testWidgets('large text on a small phone still lays out', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpTodoApp(tester, size: const Size(360, 640));
    await scrollThroughPage(tester);
  });

  testWidgets('dark mode renders the dashboard', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await pumpTodoApp(tester, size: const Size(1024, 768));
    expect(
      Theme.of(tester.element(find.byType(DashboardScreen))).brightness,
      Brightness.dark,
    );
    await scrollThroughPage(tester);
  });
}
