// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'package:todo/language/app_language.dart';
import 'package:todo/main.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  Future<AppLanguageController> pumpApp(
    WidgetTester tester, {
    List<Locale> deviceLocales = const [Locale('en', 'US')],
  }) async {
    tester.platformDispatcher.localesTestValue = deviceLocales;
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    final controller = await AppLanguageController.load();
    await tester.pumpWidget(MyApp(languageController: controller));
    await tester.pumpAndSettle();
    return controller;
  }

  Future<void> openLanguageMenu(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.translate));
    await tester.pumpAndSettle();
  }

  Future<void> pickLanguage(WidgetTester tester, String label) async {
    await openLanguageMenu(tester);
    await tester.tap(
      find.widgetWithText(CheckedPopupMenuItem<AppLanguage>, label),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await pumpApp(tester);

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

  group('device language', () {
    testWidgets('shows English on an English device', (tester) async {
      await pumpApp(tester);

      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
      expect(
        find.text('You have pushed the button this many times:'),
        findsOneWidget,
      );
      expect(find.byTooltip('Increment'), findsOneWidget);
    });

    testWidgets('shows Vietnamese on a Vietnamese device', (tester) async {
      await pumpApp(tester, deviceLocales: const [Locale('vi', 'VN')]);

      expect(find.text('Trang chủ Flutter Demo'), findsOneWidget);
      expect(find.text('Bạn đã nhấn nút số lần là:'), findsOneWidget);
      expect(find.byTooltip('Tăng'), findsOneWidget);
    });

    testWidgets('falls back to English for unsupported languages', (
      tester,
    ) async {
      await pumpApp(tester, deviceLocales: const [Locale('fr', 'FR')]);

      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
    });
  });

  group('language menu', () {
    testWidgets('picking Vietnamese overrides an English device', (
      tester,
    ) async {
      await pumpApp(tester);

      await pickLanguage(tester, 'Tiếng Việt');

      expect(find.text('Trang chủ Flutter Demo'), findsOneWidget);
      expect(find.byTooltip('Ngôn ngữ'), findsOneWidget);
    });

    testWidgets('picking English overrides a Vietnamese device', (
      tester,
    ) async {
      await pumpApp(tester, deviceLocales: const [Locale('vi', 'VN')]);

      await pickLanguage(tester, 'English');

      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
    });

    testWidgets('picking system default follows the device again', (
      tester,
    ) async {
      await pumpApp(tester);
      await pickLanguage(tester, 'Tiếng Việt');

      await pickLanguage(tester, 'Theo hệ thống');

      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
    });

    testWidgets('checks the current choice', (tester) async {
      await pumpApp(tester);
      await pickLanguage(tester, 'Tiếng Việt');

      await openLanguageMenu(tester);

      final checked = tester
          .widgetList<CheckedPopupMenuItem<AppLanguage>>(
            find.byType(CheckedPopupMenuItem<AppLanguage>),
          )
          .where((item) => item.checked)
          .map((item) => item.value);
      expect(checked, [AppLanguage.vietnamese]);
    });

    testWidgets('restores the saved choice on next launch', (tester) async {
      await pumpApp(tester);
      await pickLanguage(tester, 'Tiếng Việt');

      final relaunched = await pumpApp(tester);

      expect(relaunched.value, AppLanguage.vietnamese);
      expect(find.text('Trang chủ Flutter Demo'), findsOneWidget);
    });

    testWidgets('restores system default after it was picked', (tester) async {
      await pumpApp(tester);
      await pickLanguage(tester, 'Tiếng Việt');
      await pickLanguage(tester, 'Theo hệ thống');

      final relaunched = await pumpApp(tester);

      expect(relaunched.value, AppLanguage.system);
    });
  });

  group('language menu layout', () {
    const screens = {
      'phone portrait': Size(360, 640),
      'phone landscape': Size(640, 360),
      'fold inner': Size(673, 841),
      'tablet 7" portrait': Size(600, 960),
      'tablet 9" landscape': Size(1138, 720),
      'tablet 10"+ portrait': Size(800, 1280),
      'tablet 10"+ landscape': Size(1366, 1024),
    };

    for (final MapEntry(key: name, value: size) in screens.entries) {
      testWidgets('opens without overflow on $name', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await pumpApp(tester);

        await openLanguageMenu(tester);

        expect(tester.takeException(), isNull);
        expect(find.text('System default'), findsOneWidget);
        expect(find.text('English'), findsOneWidget);
        expect(find.text('Tiếng Việt'), findsOneWidget);
      });
    }
  });
}
