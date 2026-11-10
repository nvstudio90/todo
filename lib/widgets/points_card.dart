import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../features/home/home_state.dart';
import '../l10n/app_localizations.dart';
import 'section_card.dart';

@immutable
class PointsSummary {
  const PointsSummary({
    required this.today,
    required this.week,
    required this.total,
    required this.available,
  });

  final int today;
  final int week;
  final int total;
  final int available;
}

/// Points of the current kid for today and the selected week.
final pointsSummaryProvider = Provider<PointsSummary?>((ref) {
  final scoring = ref.watch(currentScoringProvider);
  if (scoring == null) return null;
  final today = ref.watch(todayProvider);
  return PointsSummary(
    today: scoring.pointsOn(today),
    week: scoring.weekPoints(ref.watch(selectedWeekProvider)),
    total: scoring.totalEarned,
    available: scoring.available,
  );
});

class PointsCard extends ConsumerWidget {
  const PointsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(pointsSummaryProvider);
    return PointsCardView(
      summary:
          summary ??
          const PointsSummary(today: 0, week: 0, total: 0, available: 0),
    );
  }
}

class PointsCardView extends StatelessWidget {
  const PointsCardView({super.key, required this.summary});

  final PointsSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      color: c.pointsBg,
      borderColor: c.pointsBg,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.pointsToday, style: textTheme.titleMedium),
          Row(
            children: [
              Icon(Icons.star_rounded, color: c.star, size: 36),
              const SizedBox(width: AppSpacing.sm),
              AnimatedCount(
                value: summary.today,
                style: AppTypography.displayNumber,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _row(context, l10n.pointsThisWeek, summary.week),
          _row(context, l10n.pointsTotalEarned, summary.total),
          _row(context, l10n.pointsLeftToSpend, summary.available),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, int value) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.labelSmall.copyWith(color: c.textSecondary),
            ),
          ),
          AnimatedCount(
            value: value,
            style: AppTypography.labelLarge.copyWith(color: c.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// "⭐ 7" chip that stands in for the points card on landscape phones.
class PointsChip extends ConsumerWidget {
  const PointsChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(pointsSummaryProvider);
    return Tooltip(
      message: summary == null
          ? l10n.pointsToday
          : '${l10n.pointsToday}: ${summary.today}\n'
                '${l10n.pointsLeftToSpend}: ${summary.available}',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: c.pointsBg,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, color: c.star, size: 22),
            const SizedBox(width: AppSpacing.xs),
            AnimatedCount(
              value: summary?.today ?? 0,
              style: AppTypography.titleMedium.copyWith(color: c.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Number that counts up or down to its new value.
class AnimatedCount extends StatelessWidget {
  const AnimatedCount({super.key, required this.value, this.style});

  final int value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: value.toDouble()),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, v, _) => Text(
        v.round().toString(),
        style: style,
        semanticsLabel: value.toString(),
      ),
    );
  }
}
