import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout/layout_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/models/models.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_header.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/points_card.dart';
import '../manage/manage_access.dart';
import '../progress/level_track.dart';
import '../progress/notes_card.dart';
import '../progress/streak_card.dart';
import '../rewards/rewards_section.dart';
import '../week/week_table.dart';

/// One scrolling board for tablets and open folds, like the web design.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = LayoutConfig.of(context);
    final gap = SizedBox(width: config.cardGap, height: config.cardGap);
    final l10n = AppLocalizations.of(context);
    final banner = InfoBanner(text: l10n.dataBanner);
    const tables = [
      WeekTable(type: TaskType.mustDo),
      WeekTable(type: TaskType.optional),
    ];

    final List<Widget> children;
    if (config.isLandscape) {
      children = [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppHeader(),
                  gap,
                  banner,
                  gap,
                  tables[0],
                  gap,
                  tables[1],
                ],
              ),
            ),
            gap,
            SizedBox(
              width: config.sideColumnWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const PointsCard(),
                  gap,
                  const RewardsSection(columns: 1, historyLimit: 5),
                ],
              ),
            ),
          ],
        ),
        _equalRow(config, const [
          LevelTrack(twoRows: true),
          StreakCard(),
          NotesCard(),
        ]),
      ];
    } else {
      children = [
        LayoutBuilder(
          builder: (context, constraints) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: AppHeader()),
              gap,
              SizedBox(
                width: (constraints.maxWidth * 0.34).clamp(200, 280),
                child: const PointsCard(),
              ),
            ],
          ),
        ),
        banner,
        ...tables,
        const RewardsSection(historyLimit: 5),
        const LevelTrack(),
        _equalRow(config, const [StreakCard(), NotesCard()]),
      ];
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(config.screenMargin),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: config.maxContentWidth ?? double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, child) in children.indexed) ...[
                      if (i > 0) gap,
                      child,
                    ],
                    gap,
                    const _Footer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Cards side by side, stretched to the tallest one.
  Widget _equalRow(LayoutConfig config, List<Widget> cards) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, card) in cards.indexed) ...[
          if (i > 0) SizedBox(width: config.cardGap),
          Expanded(child: card),
        ],
      ],
    ),
  );
}

class _Footer extends ConsumerWidget {
  const _Footer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () => openManageScreen(context, ref),
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: Text(l10n.editLists),
        ),
        Text(
          l10n.footerHint,
          style: AppTypography.bodyMedium.copyWith(color: c.textSecondary),
        ),
      ],
    );
  }
}
