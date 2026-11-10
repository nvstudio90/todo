import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/gallery/gallery_screen.dart';
import '../../features/home/home_shell.dart';
import '../../features/home/home_state.dart';
import '../../features/manage/manage_access.dart';
import '../../features/manage/manage_screen.dart';
import '../../features/progress/progress_tab.dart';
import '../../features/rewards/rewards_tab.dart';
import '../../features/today/today_tab.dart';
import '../../features/week/week_tab.dart';

final routerProvider = Provider<GoRouter>((ref) {
  GoRoute tab(String path, GoRouterWidgetBuilder builder) =>
      GoRoute(path: path, builder: builder);

  final router = GoRouter(
    initialLocation: '/today',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [tab('/today', (_, _) => const TodayTab())],
          ),
          StatefulShellBranch(
            routes: [tab('/week', (_, _) => const WeekTab())],
          ),
          StatefulShellBranch(
            routes: [tab('/rewards', (_, _) => const RewardsTab())],
          ),
          StatefulShellBranch(
            routes: [tab('/progress', (_, _) => const ProgressTab())],
          ),
        ],
      ),
      GoRoute(
        path: manageRoute,
        // Only reachable through openManageScreen, which asks for the PIN.
        redirect: (_, _) => ref.read(manageUnlockedProvider) ? null : '/today',
        onExit: (_, _) {
          ref.read(manageUnlockedProvider.notifier).lock();
          return true;
        },
        builder: (_, _) => const ManageScreen(),
      ),
      if (kDebugMode)
        GoRoute(path: '/gallery', builder: (_, _) => const GalleryScreen()),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
