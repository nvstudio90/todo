import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout/layout_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/scoring/levels.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/seed_text.dart';
import '../../widgets/section_card.dart';
import '../home/home_state.dart';

class LevelTrack extends ConsumerWidget {
  const LevelTrack({super.key, this.twoRows = false});

  /// Two levels per row, for narrow cards where long names would split.
  final bool twoRows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kid = ref.watch(currentKidProvider);
    final scoring = ref.watch(currentScoringProvider);
    return LevelTrackView(
      kidName: kid?.displayName(l10n) ?? '',
      progress: scoring?.level ?? LevelProgress.forPoints(0),
      twoRows: twoRows,
    );
  }
}

class LevelTrackView extends StatelessWidget {
  const LevelTrackView({
    super.key,
    required this.kidName,
    required this.progress,
    this.twoRows = false,
  });

  final String kidName;
  final LevelProgress progress;
  final bool twoRows;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final config = LayoutConfig.of(context);
    final next = progress.next;
    final description = next == null
        ? l10n.levelTop(kidName, progress.points)
        : l10n.levelProgress(
            kidName,
            progress.points,
            progress.pointsToNext,
            next.number,
            next.displayName(l10n),
          );

    return AppCard(
      padding: EdgeInsets.all(config.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(emoji: '🏆', title: l10n.myLevels),
          const SizedBox(height: AppSpacing.md),
          for (final (r, row) in levels.slices(twoRows ? 2 : 4).indexed) ...[
            if (r > 0) const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, level) in row.indexed) ...[
                  if (i > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xxl),
                      child: Text('→', style: TextStyle(color: c.textMuted)),
                    ),
                  Expanded(
                    child: _LevelBox(
                      level: level,
                      current: level.number == progress.current.number,
                    ),
                  ),
                ],
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: progress.fraction),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                color: c.primary,
                backgroundColor: c.primarySoft,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: AppTypography.bodyMedium.copyWith(color: c.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _LevelBox extends StatelessWidget {
  const _LevelBox({required this.level, required this.current});

  final LevelInfo level;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final fg = current ? c.textPrimary : c.textMuted;
    final max = level.maxPoints;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: current ? c.primarySoft : null,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Opacity(
            opacity: current ? 1 : 0.5,
            child: Text(level.emoji, style: const TextStyle(fontSize: 26)),
          ),
          Text(
            l10n.levelNumber(level.number),
            textAlign: TextAlign.center,
            style: AppTypography.labelLarge.copyWith(color: fg),
          ),
          Text(
            level.displayName(l10n),
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(color: fg),
          ),
          Text(
            max == null
                ? l10n.levelRangeOpen(level.minPoints)
                : l10n.levelRange(level.minPoints, max),
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
