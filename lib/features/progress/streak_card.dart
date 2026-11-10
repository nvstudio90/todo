import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout/layout_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/dates.dart';
import '../../domain/scoring/scoring.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/seed_text.dart';
import '../../widgets/section_card.dart';
import '../home/home_state.dart';

class StreakCard extends ConsumerWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final week = ref.watch(selectedWeekProvider);
    final days =
        ref.watch(currentScoringProvider)?.streakDays(week) ??
        List.filled(7, false);
    return StreakCardView(weekStart: week, doneDays: days);
  }
}

class StreakCardView extends StatelessWidget {
  const StreakCardView({
    super.key,
    required this.weekStart,
    required this.doneDays,
  });

  final DateTime weekStart;
  final List<bool> doneDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final config = LayoutConfig.of(context);
    final done = doneDays.where((d) => d).length;
    final body = AppTypography.bodyMedium.copyWith(color: c.textPrimary);

    return AppCard(
      color: c.streakBg,
      borderColor: c.streakBg,
      padding: EdgeInsets.all(config.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitle(emoji: '🔥', title: l10n.streakTitle),
          const SizedBox(height: AppSpacing.sm),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '${l10n.streakDescription} '),
                TextSpan(
                  text: l10n.streakReward(streakBonusPoints),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            style: body,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (final (i, day) in Dates.daysOfWeek(weekStart).indexed) ...[
                if (i > 0) const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _DayDot(label: l10n.weekdayOf(day), done: doneDays[i]),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            done == 7
                ? l10n.streakEarned(streakBonusPoints)
                : l10n.streakProgress(done),
            style: AppTypography.labelLarge.copyWith(color: c.streakText),
          ),
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: done ? c.primary : c.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            color: done ? c.onPrimary : c.textPrimary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
