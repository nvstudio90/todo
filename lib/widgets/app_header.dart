import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/layout/layout_config.dart';
import '../core/theme/app_spacing.dart';
import '../features/manage/manage_access.dart';
import '../l10n/app_localizations.dart';
import '../language/app_language.dart';
import '../language/language_menu_button.dart';
import 'app_title.dart';
import 'kid_chips.dart';
import 'points_card.dart';
import 'section_card.dart';
import 'week_switcher.dart';

/// Title, kid chips and week switcher, shared by every tab and the dashboard.
class AppHeader extends ConsumerWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = LayoutConfig.of(context);
    final compactLandscape = config.isCompact && config.isLandscape;
    return AppCard(
      padding: EdgeInsets.all(
        compactLandscape ? AppSpacing.md : config.cardPadding,
      ),
      child: compactLandscape
          ? _CompactLandscapeHeader(config: config)
          : _StackedHeader(config: config),
    );
  }
}

class _StackedHeader extends StatelessWidget {
  const _StackedHeader({required this.config});

  final LayoutConfig config;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _Title(size: config.displayLargeSize)),
            const _HeaderActions(),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        const Slogan(),
        const SizedBox(height: AppSpacing.md),
        const _ChipsAndWeek(),
      ],
    );
  }
}

class _CompactLandscapeHeader extends StatelessWidget {
  const _CompactLandscapeHeader({required this.config});

  final LayoutConfig config;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _Title(size: config.displayLargeSize)),
            const SizedBox(width: AppSpacing.sm),
            const PointsChip(),
            const _HeaderActions(),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        const _ChipsAndWeek(),
      ],
    );
  }
}

/// Chips and week switcher share a line when it fits, else stack.
class _ChipsAndWeek extends StatelessWidget {
  const _ChipsAndWeek();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 480) {
          return const Row(
            children: [
              Expanded(child: KidChipBar()),
              SizedBox(width: AppSpacing.sm),
              WeekSwitcher(),
            ],
          );
        }
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KidChipBar(),
            SizedBox(height: AppSpacing.sm),
            WeekSwitcher(),
          ],
        );
      },
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final title = AppTitle(fontSize: size);
    if (!kDebugMode) return title;
    // Debug builds open the component gallery from here.
    return GestureDetector(
      onLongPress: () => context.push('/gallery'),
      child: title,
    );
  }
}

class _HeaderActions extends ConsumerWidget {
  const _HeaderActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          tooltip: l10n.editLists,
          onPressed: () => openManageScreen(context, ref),
        ),
        LanguageMenuButton(
          controller: ref.watch(appLanguageControllerProvider),
        ),
      ],
    );
  }
}
