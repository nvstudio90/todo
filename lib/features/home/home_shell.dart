import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout/layout_config.dart';
import '../../l10n/app_localizations.dart';
import 'dashboard_screen.dart';
import 'home_state.dart';

/// Tabs on phones, one dashboard from 600dp up. Selection lives in providers
/// and the router, so folding or unfolding keeps the kid, week, day and tab.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Timers stall while the app sleeps, so re-check the date on resume.
    _lifecycle = AppLifecycleListener(
      onResume: () => ref.read(todayProvider.notifier).refresh(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = LayoutConfig.of(context);
    if (!config.usesTabs) return const DashboardScreen();
    return _TabScaffold(shell: widget.navigationShell, config: config);
  }
}

class _TabScaffold extends StatelessWidget {
  const _TabScaffold({required this.shell, required this.config});

  final StatefulNavigationShell shell;
  final LayoutConfig config;

  void _go(int index) =>
      shell.goBranch(index, initialLocation: index == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final destinations = [
      (Icons.today_outlined, Icons.today, l10n.tabToday),
      (
        Icons.calendar_view_week_outlined,
        Icons.calendar_view_week,
        l10n.tabWeek,
      ),
      (Icons.card_giftcard_outlined, Icons.card_giftcard, l10n.tabRewards),
      (Icons.emoji_events_outlined, Icons.emoji_events, l10n.tabProgress),
    ];

    if (config.isLandscape) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: NavigationRail(
                        selectedIndex: shell.currentIndex,
                        onDestinationSelected: _go,
                        labelType: NavigationRailLabelType.all,
                        groupAlignment: 0,
                        destinations: [
                          for (final (icon, selected, label) in destinations)
                            NavigationRailDestination(
                              icon: Icon(icon),
                              selectedIcon: Icon(selected),
                              label: Text(label, textAlign: TextAlign.center),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(child: shell),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(bottom: false, child: shell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _go,
        destinations: [
          for (final (icon, selected, label) in destinations)
            NavigationDestination(
              icon: Icon(icon),
              selectedIcon: Icon(selected),
              label: label,
            ),
        ],
      ),
    );
  }
}
