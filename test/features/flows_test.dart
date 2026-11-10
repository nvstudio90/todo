import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:todo/core/router/app_router.dart';
import 'package:todo/core/theme/app_theme.dart';
import 'package:todo/core/utils/dates.dart';
import 'package:todo/data/db/database.dart';
import 'package:todo/data/repositories/pin_repository.dart';
import 'package:todo/features/home/dashboard_screen.dart';
import 'package:todo/features/home/home_state.dart';
import 'package:todo/features/manage/manage_screen.dart';
import 'package:todo/features/pin/pin_dialog.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/widgets/celebration.dart';
import 'package:todo/widgets/kid_chips.dart';

import '../helpers/pump_app.dart';

const _bed = 'Make the bed after waking up';

Future<void> _tapTab(WidgetTester tester, IconData icon) async {
  await tester.tap(find.byIcon(icon));
  await tester.pumpAndSettle();
}

Future<void> _enterPin(WidgetTester tester, String pin) async {
  await tester.enterText(
    find.descendant(
      of: find.byType(PinField),
      matching: find.byType(TextField),
    ),
    pin,
  );
  await tester.pumpAndSettle();
}

/// Gives the first kid [days] stars of the 5-point good-deed task.
Future<void> _giveGoodDeeds(AppDatabase db, int days) async {
  final kid = await (db.select(db.kids)..limit(1)).getSingle();
  final task = await (db.select(
    db.tasks,
  )..where((t) => t.seedKey.equals('goodDeed'))).getSingle();
  for (var i = 0; i < days; i++) {
    await db
        .into(db.completions)
        .insert(
          CompletionsCompanion.insert(
            kidId: kid.id,
            taskId: task.id,
            date: Dates.addDays(testToday, -i),
            points: 5,
            createdAt: testToday,
          ),
        );
  }
}

void main() {
  group('stars', () {
    testWidgets('starring today adds points, starring again removes them', (
      tester,
    ) async {
      final app = await pumpTodoApp(tester);
      final star = find.bySemanticsLabel('$_bed, Wed: not done');
      expect(star, findsOneWidget);

      await tester.tap(star);
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('$_bed, Wed: done'), findsOneWidget);
      final stored = await app.db.select(app.db.completions).get();
      expect(stored.single.points, 2);
      expect(stored.single.date, testToday);

      await tester.tap(find.bySemanticsLabel('$_bed, Wed: done'));
      await tester.pumpAndSettle();
      expect(await app.db.select(app.db.completions).get(), isEmpty);
    });

    testWidgets('future days are shown but locked', (tester) async {
      final app = await pumpTodoApp(tester);
      await tester.tap(find.text('Thu'));
      await tester.pumpAndSettle();

      expect(find.text('Stars unlock on that day.'), findsOneWidget);
      final locked = find.bySemanticsLabel('$_bed, Thu: not yet');
      expect(locked, findsOneWidget);
      await tester.tap(locked, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(await app.db.select(app.db.completions).get(), isEmpty);
    });

    testWidgets('each kid has their own stars', (tester) async {
      await pumpTodoApp(tester);
      await tester.tap(find.bySemanticsLabel('$_bed, Wed: not done'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kid 2'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('$_bed, Wed: not done'), findsOneWidget);
    });

    testWidgets('week table stars past days', (tester) async {
      final app = await pumpTodoApp(tester, size: const Size(1024, 768));
      await tester.tap(find.bySemanticsLabel('$_bed, Mon: not done'));
      await tester.pumpAndSettle();
      final stored = await app.db.select(app.db.completions).get();
      expect(stored.single.date, DateTime(2026, 11, 9));
    });
  });

  group('rewards', () {
    testWidgets('redeeming asks to confirm, creates the PIN, spends points', (
      tester,
    ) async {
      final app = await pumpTodoApp(tester);
      await _giveGoodDeeds(app.db, 4);
      await tester.pumpAndSettle();
      await _tapTab(tester, Icons.card_giftcard_outlined);
      expect(find.text('20 points left'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Redeem').first);
      await tester.pumpAndSettle();
      expect(
        find.text('Spend 20 ⭐ on "Pick a favorite dessert"?'),
        findsOneWidget,
      );
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Redeem'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Set a PIN'), findsOneWidget);
      await _enterPin(tester, '1234');
      expect(find.text('Enter the PIN again'), findsOneWidget);
      await tester.enterText(
        find.descendant(
          of: find.byType(PinField),
          matching: find.byType(TextField),
        ),
        '1234',
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      // Confetti advances on wall-clock time, so fake time never ends it.
      app.container.read(celebrationProvider).stop(clearAllParticles: true);
      await tester.pumpAndSettle();

      expect(find.text('0 points left'), findsOneWidget);
      expect(find.text('Kid 1 got "Pick a favorite dessert"!'), findsOneWidget);
      final history = await app.db.select(app.db.redemptions).get();
      expect(history.single.cost, 20);
      expect(await PinRepository().verify('1234'), isTrue);
    });

    testWidgets('a wrong PIN does not spend points', (tester) async {
      final app = await pumpTodoApp(tester);
      await PinRepository().setPin('1234');
      await _giveGoodDeeds(app.db, 4);
      await tester.pumpAndSettle();
      await _tapTab(tester, Icons.card_giftcard_outlined);

      await tester.tap(find.widgetWithText(FilledButton, 'Redeem').first);
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Redeem'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Enter parent PIN'), findsOneWidget);

      await _enterPin(tester, '0000');
      expect(find.text('Wrong PIN'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(await app.db.select(app.db.redemptions).get(), isEmpty);
      expect(find.text('20 points left'), findsOneWidget);
    });

    testWidgets('rewards that cost too much show how many points are missing', (
      tester,
    ) async {
      await pumpTodoApp(tester);
      await _tapTab(tester, Icons.card_giftcard_outlined);
      expect(find.text('Need 20 more'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Redeem'), findsNothing);
    });
  });

  group('PIN dialog', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
    });

    Future<Future<bool?>> openDialog(WidgetTester tester, int seed) async {
      final repo = PinRepository();
      await repo.setPin('1234');
      late Future<bool?> result;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => result = showDialog<bool>(
                context: context,
                builder: (_) => PinDialog(
                  repository: repo,
                  initialStep: PinStep.verify,
                  random: Random(seed),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets(
      'forgot PIN: a wrong answer asks again, a right one sets a new PIN',
      (tester) async {
        final result = await openDialog(tester, 7);
        await tester.tap(find.text('Forgot PIN?'));
        await tester.pumpAndSettle();

        final expected = Random(7);
        var a = 11 + expected.nextInt(9);
        var b = 11 + expected.nextInt(9);
        expect(find.text('What is $a × $b?'), findsOneWidget);
        expect(a, inInclusiveRange(11, 19));

        await tester.enterText(find.byType(TextField), '1');
        await tester.tap(find.text('Check'));
        await tester.pumpAndSettle();
        expect(find.text('Not quite. Here is another one.'), findsOneWidget);
        a = 11 + expected.nextInt(9);
        b = 11 + expected.nextInt(9);
        expect(find.text('What is $a × $b?'), findsOneWidget);

        await tester.enterText(find.byType(TextField), '${a * b}');
        await tester.tap(find.text('Check'));
        await tester.pumpAndSettle();
        expect(find.text('Set a PIN'), findsOneWidget);

        await _enterPin(tester, '5678');
        await _enterPin(tester, '5678');
        expect(await result, isTrue);
        expect(await PinRepository().verify('5678'), isTrue);
      },
    );

    testWidgets('mismatched confirmation starts over', (tester) async {
      await openDialog(tester, 1);
      await tester.tap(find.text('Forgot PIN?'));
      await tester.pumpAndSettle();
      final r = Random(1);
      final answer = (11 + r.nextInt(9)) * (11 + r.nextInt(9));
      await tester.enterText(find.byType(TextField), '$answer');
      await tester.tap(find.text('Check'));
      await tester.pumpAndSettle();

      await _enterPin(tester, '1111');
      await _enterPin(tester, '2222');
      expect(find.text('Set a PIN'), findsOneWidget);
      expect(find.text("The two PINs don't match. Try again."), findsOneWidget);
    });
  });

  group('edit lists', () {
    testWidgets('needs the PIN and locks again when left', (tester) async {
      final app = await pumpTodoApp(tester);
      await PinRepository().setPin('1234');

      await tester.tap(find.byTooltip('Edit lists'));
      await tester.pumpAndSettle();
      await _enterPin(tester, '1234');
      expect(find.byType(ManageScreen), findsOneWidget);
      expect(app.container.read(manageUnlockedProvider), isTrue);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(ManageScreen), findsNothing);
      expect(app.container.read(manageUnlockedProvider), isFalse);

      app.container.read(routerProvider).go('/manage');
      await tester.pumpAndSettle();
      expect(find.byType(ManageScreen), findsNothing);
    });

    testWidgets('cancelling the PIN keeps the screen closed', (tester) async {
      await pumpTodoApp(tester);
      await PinRepository().setPin('1234');
      await tester.tap(find.byTooltip('Edit lists'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(ManageScreen), findsNothing);
    });

    Future<void> openManage(WidgetTester tester) async {
      await PinRepository().setPin('1234');
      await tester.tap(find.byTooltip('Edit lists'));
      await tester.pumpAndSettle();
      await _enterPin(tester, '1234');
    }

    testWidgets('adding a task shows it on the board', (tester) async {
      final app = await pumpTodoApp(tester);
      await openManage(tester);

      await tester.tap(find.text('Add task'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Task name'),
        'Feed the cat',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('🐶'));
      await tester.tap(find.widgetWithText(FilledButton, 'Add'));
      await tester.pumpAndSettle();

      final tasks = await app.db.select(app.db.tasks).get();
      final added = tasks.last;
      expect(added.title, 'Feed the cat');
      expect(added.emoji, '🐶');
      expect(added.points, 2);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Feed the cat'), findsOneWidget);
    });

    testWidgets('the Add button stays off until the name is filled', (
      tester,
    ) async {
      await pumpTodoApp(tester);
      await openManage(tester);
      await tester.ensureVisible(find.text('Kids'));
      await tester.tap(find.text('Kids'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add kid'));
      await tester.pumpAndSettle();

      final add = find.widgetWithText(FilledButton, 'Add');
      expect(tester.widget<FilledButton>(add).onPressed, isNull);
      await tester.enterText(
        find.widgetWithText(TextField, "Kid's name"),
        '   ',
      );
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(add).onPressed, isNull);
      await tester.enterText(
        find.widgetWithText(TextField, "Kid's name"),
        'Na',
      );
      await tester.pumpAndSettle();
      await tester.tap(add);
      await tester.pumpAndSettle();
      expect(find.text('Na'), findsOneWidget);
    });

    testWidgets(
      'deleting a kid asks first and the last kid cannot be deleted',
      (tester) async {
        final app = await pumpTodoApp(tester);
        await openManage(tester);
        await tester.ensureVisible(find.text('Kids'));
        await tester.tap(find.text('Kids'));
        await tester.pumpAndSettle();
        expect(find.byTooltip('Delete'), findsNWidgets(2));

        await tester.tap(find.byTooltip('Delete').first);
        await tester.pumpAndSettle();
        expect(find.text('Delete Kid 1?'), findsOneWidget);
        await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
        await tester.pumpAndSettle();

        expect(await app.db.select(app.db.kids).get(), hasLength(1));
        expect(find.byTooltip('Delete'), findsNothing);
      },
    );

    testWidgets('renaming a seeded task keeps other languages untouched', (
      tester,
    ) async {
      final app = await pumpTodoApp(tester);
      await openManage(tester);
      await tester.tap(find.text(_bed));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Increase'));
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      final bed = await (app.db.select(
        app.db.tasks,
      )..where((t) => t.seedKey.equals('makeBed'))).getSingle();
      expect(bed.points, 3);
      expect(bed.title, isNull, reason: 'unchanged text stays translatable');
    });
  });

  testWidgets('folding and unfolding keeps the kid, week and tab', (
    tester,
  ) async {
    await pumpTodoApp(tester, size: const Size(344, 882));
    await tester.tap(find.text('Kid 2'));
    await tester.tap(find.byTooltip('Next week'));
    await tester.pumpAndSettle();
    await _tapTab(tester, Icons.card_giftcard_outlined);

    setScreenSize(tester, const Size(690, 829));
    await tester.pumpAndSettle();
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Nov 16 – 22, 2026'), findsOneWidget);
    final chip = tester.widget<KidChip>(find.widgetWithText(KidChip, 'Kid 2'));
    expect(chip.selected, isTrue);

    setScreenSize(tester, const Size(344, 882));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      2,
    );
    expect(
      tester.widget<KidChip>(find.widgetWithText(KidChip, 'Kid 2')).selected,
      isTrue,
    );
  });

  testWidgets('notes are saved per kid and week', (tester) async {
    final app = await pumpTodoApp(tester, size: const Size(1024, 768));
    await tester.enterText(
      find.widgetWithText(TextField, 'Parent notes for Kid 1 this week...'),
      'Great week!',
    );
    await tester.pump(const Duration(seconds: 1));
    final notes = await app.db.select(app.db.weekNotes).get();
    expect(notes.single.body, 'Great week!');
    expect(notes.single.weekStart, DateTime(2026, 11, 9));

    await tester.ensureVisible(find.text('Kid 2'));
    await tester.tap(find.text('Kid 2'));
    await tester.pumpAndSettle();
    expect(find.text('Great week!'), findsNothing);
    await tester.ensureVisible(find.text('Kid 1'));
    await tester.tap(find.text('Kid 1'));
    await tester.pumpAndSettle();
    expect(find.text('Great week!'), findsOneWidget);
  });

  testWidgets('7/7 must-do days add the streak bonus', (tester) async {
    final app = await pumpTodoApp(tester, size: const Size(1024, 768));
    final kid = await (app.db.select(app.db.kids)..limit(1)).getSingle();
    final mustDo = await (app.db.select(
      app.db.tasks,
    )..where((t) => t.type.equals('mustDo'))).get();
    final lastWeek = DateTime(2026, 11, 2);
    for (final day in Dates.daysOfWeek(lastWeek)) {
      for (final t in mustDo) {
        await app.db
            .into(app.db.completions)
            .insert(
              CompletionsCompanion.insert(
                kidId: kid.id,
                taskId: t.id,
                date: day,
                points: t.points,
                createdAt: day,
              ),
            );
      }
    }
    await tester.tap(find.byTooltip('Previous week'));
    await tester.pumpAndSettle();
    await scrollThroughPage(tester);
    expect(find.text('7/7! The +10 bonus is added.'), findsOneWidget);
    // 7 days × 17 points + 10 bonus.
    expect(app.container.read(scoringProvider(kid.id))?.totalEarned, 129);
  });

  testWidgets('router opens on the Today tab', (tester) async {
    final app = await pumpTodoApp(tester);
    final router = app.container.read(routerProvider);
    expect(router.routerDelegate.currentConfiguration.uri.path, '/today');
    expect(GoRouter.of(tester.element(find.byType(NavigationBar))), router);
  });
}
