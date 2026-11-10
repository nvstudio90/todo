import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:todo/app.dart';
import 'package:todo/data/db/database.dart';
import 'package:todo/data/providers.dart';
import 'package:todo/features/home/home_state.dart';
import 'package:todo/language/app_language.dart';

/// Wednesday, so the week has past, current and future days.
final testToday = DateTime(2026, 11, 11);

class FixedToday extends TodayNotifier {
  FixedToday(this.day);

  final DateTime day;

  @override
  DateTime build() => day;
}

class TestApp {
  TestApp(this.db, this.container);

  final AppDatabase db;
  final ProviderContainer container;
}

/// Every screen to check, in dp, per CLAUDE.md and design-system.md 6.6.
const screenSizes = <String, Size>{
  'phone portrait': Size(411, 914),
  'phone landscape': Size(914, 411),
  'small phone portrait': Size(360, 640),
  'small phone landscape': Size(640, 360),
  'fold outer portrait': Size(344, 882),
  'fold outer landscape': Size(882, 344),
  'fold inner portrait': Size(690, 829),
  'fold inner landscape': Size(829, 690),
  'tablet 7" portrait': Size(600, 960),
  'tablet 7" landscape': Size(960, 600),
  'tablet 9" portrait': Size(768, 1024),
  'tablet 9" landscape': Size(1024, 768),
  'tablet 10" portrait': Size(800, 1280),
  'tablet 10" landscape': Size(1280, 800),
  'tablet 13" portrait': Size(1032, 1376),
  'tablet 13" landscape': Size(1376, 1032),
};

void setScreenSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
}

Future<TestApp> pumpTodoApp(
  WidgetTester tester, {
  Size size = const Size(411, 914),
  List<Locale> deviceLocales = const [Locale('en', 'US')],
  bool freshPrefs = true,
}) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  if (freshPrefs) {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  }
  setScreenSize(tester, size);
  addTearDown(tester.view.reset);
  tester.platformDispatcher.localesTestValue = deviceLocales;
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);

  final db = AppDatabase(NativeDatabase.memory());
  final language = await AppLanguageController.load();
  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
      appLanguageControllerProvider.overrideWithValue(language),
      todayProvider.overrideWith(() => FixedToday(testToday)),
    ],
  );
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    container.dispose();
    await db.close();
  });
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const TodoApp()),
  );
  await tester.pumpAndSettle();
  return TestApp(db, container);
}

/// Scrolls the main vertical list to the end so every card gets built.
Future<void> scrollThroughPage(WidgetTester tester) async {
  final list = find.byType(ListView).first;
  final vertical = find.descendant(
    of: list,
    matching: find.byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
    ),
  );
  final position = tester.state<ScrollableState>(vertical.first).position;
  // Jumps a screen at a time; a drag could land on a text field that keeps
  // the gesture, and every lazily built card still gets laid out.
  for (var i = 0; i < 50 && position.pixels < position.maxScrollExtent; i++) {
    position.jumpTo(
      (position.pixels + position.viewportDimension * 0.8).clamp(
        0,
        position.maxScrollExtent,
      ),
    );
    await tester.pumpAndSettle();
  }
  expect(position.pixels, position.maxScrollExtent);
}
