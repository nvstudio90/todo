import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/data/db/database.dart';
import 'package:todo/language/app_language.dart';

import '../helpers/pump_app.dart';

Future<void> _openLanguageMenu(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.translate));
  await tester.pumpAndSettle();
}

Future<void> _pickLanguage(WidgetTester tester, String label) async {
  await _openLanguageMenu(tester);
  await tester.tap(
    find.widgetWithText(CheckedPopupMenuItem<AppLanguage>, label),
  );
  await tester.pumpAndSettle();
}

AppLanguage _current(TestApp app) =>
    app.container.read(appLanguageControllerProvider).value;

void main() {
  group('device language', () {
    testWidgets('English device shows English everywhere, seeds included', (
      tester,
    ) async {
      await pumpTodoApp(tester);
      expect(find.text('My Points Today'), findsOneWidget);
      expect(find.textContaining('Must-Do Tasks'), findsOneWidget);
      expect(find.text('Kid 1'), findsOneWidget);
      expect(find.text('Brush teeth morning + night'), findsOneWidget);
      expect(find.text('Wed'), findsOneWidget);
    });

    testWidgets('Vietnamese device shows Vietnamese everywhere', (
      tester,
    ) async {
      await pumpTodoApp(tester, deviceLocales: const [Locale('vi', 'VN')]);
      expect(find.text('Điểm hôm nay'), findsOneWidget);
      expect(find.textContaining('Việc bắt buộc'), findsOneWidget);
      expect(find.text('Bé 1'), findsOneWidget);
      expect(find.text('Đánh răng sáng + tối'), findsOneWidget);
      expect(find.text('T4'), findsOneWidget);
      expect(find.text('9/11 – 15/11/2026'), findsOneWidget);
    });

    testWidgets('unsupported languages fall back to English', (tester) async {
      await pumpTodoApp(tester, deviceLocales: const [Locale('fr', 'FR')]);
      expect(find.text('My Points Today'), findsOneWidget);
    });
  });

  group('language menu', () {
    testWidgets('picking Vietnamese overrides an English device', (
      tester,
    ) async {
      await pumpTodoApp(tester);
      await _pickLanguage(tester, 'Tiếng Việt');
      expect(find.text('Đánh răng sáng + tối'), findsOneWidget);
      expect(find.byTooltip('Ngôn ngữ'), findsOneWidget);
    });

    testWidgets('picking English overrides a Vietnamese device', (
      tester,
    ) async {
      await pumpTodoApp(tester, deviceLocales: const [Locale('vi', 'VN')]);
      await _pickLanguage(tester, 'English');
      expect(find.text('Brush teeth morning + night'), findsOneWidget);
    });

    testWidgets('picking system default follows the device again', (
      tester,
    ) async {
      await pumpTodoApp(tester);
      await _pickLanguage(tester, 'Tiếng Việt');
      await _pickLanguage(tester, 'Theo hệ thống');
      expect(find.text('My Points Today'), findsOneWidget);
    });

    testWidgets('checks the current choice', (tester) async {
      await pumpTodoApp(tester);
      await _pickLanguage(tester, 'Tiếng Việt');
      await _openLanguageMenu(tester);
      final checked = tester
          .widgetList<CheckedPopupMenuItem<AppLanguage>>(
            find.byType(CheckedPopupMenuItem<AppLanguage>),
          )
          .where((item) => item.checked)
          .map((item) => item.value);
      expect(checked, [AppLanguage.vietnamese]);
    });

    testWidgets('restores the saved choice on next launch', (tester) async {
      await pumpTodoApp(tester);
      await _pickLanguage(tester, 'Tiếng Việt');

      final relaunched = await pumpTodoApp(tester, freshPrefs: false);

      expect(_current(relaunched), AppLanguage.vietnamese);
      expect(find.text('Điểm hôm nay'), findsOneWidget);
    });

    testWidgets('a renamed seeded task no longer follows the language', (
      tester,
    ) async {
      final app = await pumpTodoApp(tester);
      final teeth = await (app.db.select(
        app.db.tasks,
      )..where((t) => t.seedKey.equals('brushTeeth'))).getSingle();
      await (app.db.update(app.db.tasks)..where((t) => t.id.equals(teeth.id)))
          .write(const TasksCompanion(title: Value('Floss too')));
      await tester.pumpAndSettle();
      await _pickLanguage(tester, 'Tiếng Việt');
      expect(find.text('Floss too'), findsOneWidget);
      expect(find.text('Đánh răng sáng + tối'), findsNothing);
    });
  });

  for (final MapEntry(key: name, value: size) in screenSizes.entries) {
    testWidgets('language menu opens without overflow on $name', (
      tester,
    ) async {
      await pumpTodoApp(tester, size: size);
      await _openLanguageMenu(tester);
      expect(find.text('System default'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Tiếng Việt'), findsOneWidget);
    });
  }
}
