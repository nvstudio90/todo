// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  group('localization', () {
    Future<void> pumpWithLocales(
      WidgetTester tester,
      List<Locale> locales,
    ) async {
      tester.platformDispatcher.localesTestValue = locales;
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
    }

    testWidgets('shows English on an English device', (tester) async {
      await pumpWithLocales(tester, const [Locale('en', 'US')]);

      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
      expect(
        find.text('You have pushed the button this many times:'),
        findsOneWidget,
      );
      expect(find.byTooltip('Increment'), findsOneWidget);
    });

    testWidgets('shows Vietnamese on a Vietnamese device', (tester) async {
      await pumpWithLocales(tester, const [Locale('vi', 'VN')]);

      expect(find.text('Trang chủ Flutter Demo'), findsOneWidget);
      expect(find.text('Bạn đã nhấn nút số lần là:'), findsOneWidget);
      expect(find.byTooltip('Tăng'), findsOneWidget);
    });

    testWidgets('falls back to English for unsupported languages', (
      tester,
    ) async {
      await pumpWithLocales(tester, const [Locale('fr', 'FR')]);

      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
    });
  });
}
