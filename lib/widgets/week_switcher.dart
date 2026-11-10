import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/dates.dart';
import '../features/home/home_state.dart';
import '../l10n/app_localizations.dart';

class WeekSwitcher extends ConsumerWidget {
  const WeekSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final week = ref.watch(selectedWeekProvider);
    final isCurrent = week == Dates.weekStartOf(ref.watch(todayProvider));
    final notifier = ref.read(selectedWeekProvider.notifier);
    final label = Dates.formatWeekRange(week, l10n.localeName);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SquareButton(
          icon: Icons.chevron_left_rounded,
          tooltip: l10n.previousWeek,
          onPressed: notifier.previous,
        ),
        Flexible(
          child: Semantics(
            hint: isCurrent ? null : l10n.backToThisWeek,
            child: InkWell(
              onTap: isCurrent ? null : notifier.goToCurrent,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelLarge.copyWith(
                    color: isCurrent ? c.textPrimary : c.primary,
                    decoration: isCurrent ? null : TextDecoration.underline,
                    decorationColor: c.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        _SquareButton(
          icon: Icons.chevron_right_rounded,
          tooltip: l10n.nextWeek,
          onPressed: notifier.next,
        ),
      ],
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    // 32px box per the design, inside a 44px tap target.
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: SizedBox.square(
          dimension: AppSpacing.minTap,
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: c.border),
              ),
              child: Icon(icon, size: 20, color: c.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
