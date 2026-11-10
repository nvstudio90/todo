import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/layout/layout_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/providers.dart';
import '../../domain/models/models.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/seed_text.dart';
import '../../widgets/section_card.dart';
import '../home/home_state.dart';
import 'redeem_flow.dart';

/// "Rewards" card: points left, reward grid and the redemption history.
class RewardsSection extends ConsumerWidget {
  const RewardsSection({super.key, this.columns, this.historyLimit});

  /// Defaults to the device group's column count.
  final int? columns;

  /// Null shows the whole history.
  final int? historyLimit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final config = LayoutConfig.of(context);
    final rewards = ref.watch(activeRewardsProvider) ?? const [];
    final available = ref.watch(currentScoringProvider)?.available ?? 0;
    final perRow = columns ?? config.rewardColumns;

    return AppCard(
      color: c.rewardBg,
      borderColor: c.mustDoBorder,
      borderWidth: 1.5,
      padding: EdgeInsets.all(config.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(
            emoji: '🎁',
            title: l10n.rewards,
            color: c.rewardText,
            large: true,
            trailing: Text(
              l10n.pointsLeft(available),
              style: AppTypography.labelLarge.copyWith(color: c.textSecondary),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final row in rewards.slices(perRow)) ...[
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < perRow; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: i < row.length
                          ? RewardCard(
                              reward: row[i],
                              available: available,
                              onRedeem: () =>
                                  redeemReward(context, ref, row[i]),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          RedemptionHistory(limit: historyLimit),
        ],
      ),
    );
  }
}

class RewardCard extends StatelessWidget {
  const RewardCard({
    super.key,
    required this.reward,
    required this.available,
    required this.onRedeem,
  });

  final Reward reward;
  final int available;
  final VoidCallback onRedeem;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final missing = reward.cost - available;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  l10n.costValue(reward.cost),
                  style: AppTypography.titleMedium.copyWith(
                    color: c.textPrimary,
                  ),
                ),
              ),
              Text(reward.emoji, style: const TextStyle(fontSize: 32)),
            ],
          ),
          Text(
            reward.displayTitle(l10n),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium.copyWith(color: c.textSecondary),
          ),
          const Spacer(),
          const SizedBox(height: AppSpacing.sm),
          if (missing > 0)
            Container(
              constraints: const BoxConstraints(minHeight: 36),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: c.surfaceInset,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: c.border),
              ),
              child: Text(
                l10n.needMore(missing),
                textAlign: TextAlign.center,
                style: AppTypography.labelLarge.copyWith(color: c.textMuted),
              ),
            )
          else
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: c.rewardText,
                foregroundColor: Colors.white,
              ),
              onPressed: onRedeem,
              child: Text(l10n.redeem, textAlign: TextAlign.center),
            ),
        ],
      ),
    );
  }
}

class RedemptionHistory extends ConsumerWidget {
  const RedemptionHistory({super.key, this.limit});

  final int? limit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final kid = ref.watch(currentKidProvider);
    if (kid == null) return const SizedBox.shrink();
    final all = ref.watch(redemptionsProvider(kid.id)).value ?? const [];
    final rewards = {
      for (final r in ref.watch(allRewardsProvider).value ?? const <Reward>[])
        r.id: r,
    };
    final shown = limit == null ? all : all.take(limit!).toList();
    final dateFormat = DateFormat.yMd(l10n.localeName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.redeemedHistory,
          style: AppTypography.titleMedium.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (shown.isEmpty)
          Text(
            l10n.noRedemptions,
            style: AppTypography.bodyMedium.copyWith(color: c.textSecondary),
          ),
        for (final r in shown)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                Text(
                  rewards[r.rewardId]?.emoji ?? '🎁',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    rewards[r.rewardId]?.displayTitle(l10n) ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '−${l10n.costValue(r.cost)}',
                      style: AppTypography.labelLarge.copyWith(
                        color: c.rewardText,
                      ),
                    ),
                    Text(
                      dateFormat.format(r.redeemedAt),
                      style: AppTypography.labelSmall.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
