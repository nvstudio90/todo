import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout/layout_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/dates.dart';
import '../../domain/models/models.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/seed_text.dart';
import '../../widgets/app_header.dart';
import '../../widgets/points_card.dart';
import '../../widgets/section_card.dart';
import '../../widgets/star_toggle.dart';
import '../../widgets/tab_page.dart';
import '../home/home_state.dart';
import 'star_actions.dart';

class TodayTab extends StatelessWidget {
  const TodayTab({super.key});

  @override
  Widget build(BuildContext context) {
    final config = LayoutConfig.of(context);
    final twoColumns = config.isLandscape;
    return TabPage(
      children: [
        const AppHeader(),
        if (!config.isLandscape) const PointsCard(),
        const DayBar(),
        const _FutureDayHint(),
        if (twoColumns)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: TaskDayList(type: TaskType.mustDo)),
              SizedBox(width: config.cardGap),
              const Expanded(child: TaskDayList(type: TaskType.optional)),
            ],
          )
        else ...const [
          TaskDayList(type: TaskType.mustDo),
          TaskDayList(type: TaskType.optional),
        ],
        const DayTotalCard(),
      ],
    );
  }
}

/// T2…CN chips in each day's pastel colour; picks the day shown below.
class DayBar extends ConsumerWidget {
  const DayBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final week = ref.watch(selectedWeekProvider);
    final selected = ref.watch(selectedDayIndexProvider);
    final today = ref.watch(todayProvider);

    return Row(
      children: [
        for (final (i, day) in Dates.daysOfWeek(week).indexed) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: _DayChip(
              weekday: l10n.weekdayOf(day),
              date: '${day.day}',
              color: c.dayColors[i],
              selected: i == selected,
              isToday: Dates.isSameDay(day, today),
              onTap: () =>
                  ref.read(selectedDayIndexProvider.notifier).select(i),
            ),
          ),
        ],
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.weekday,
    required this.date,
    required this.color,
    required this.selected,
    required this.isToday,
    required this.onTap,
  });

  final String weekday;
  final String date;
  final Color color;
  final bool selected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final accent = isToday || selected ? c.primary : c.textPrimary;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: selected ? c.primary : c.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  children: [
                    Text(
                      weekday,
                      style: AppTypography.labelLarge.copyWith(color: accent),
                    ),
                    Text(
                      date,
                      style: AppTypography.labelSmall.copyWith(
                        color: isToday ? c.primary : c.textSecondary,
                        fontWeight: isToday ? FontWeight.w700 : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FutureDayHint extends ConsumerWidget {
  const _FutureDayHint();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(selectedDayProvider);
    if (!day.isAfter(ref.watch(todayProvider))) return const SizedBox.shrink();
    final c = AppColors.of(context);
    return Row(
      children: [
        Icon(Icons.lock_clock_outlined, size: 18, color: c.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            AppLocalizations.of(context).futureDayHint,
            style: AppTypography.bodyMedium.copyWith(color: c.textSecondary),
          ),
        ),
      ],
    );
  }
}

/// The selected day's tasks of one type, each with one big star.
class TaskDayList extends ConsumerWidget {
  const TaskDayList({super.key, required this.type});

  final TaskType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = SectionColors.forTask(context, type);
    final config = LayoutConfig.of(context);
    final tasks = ref.watch(visibleTasksProvider(type)) ?? const [];
    final scoring = ref.watch(currentScoringProvider);
    final day = ref.watch(selectedDayProvider);
    final locked = day.isAfter(ref.watch(todayProvider));
    final weekday = l10n.weekdayOf(day);

    return AppCard(
      borderColor: colors.border,
      borderWidth: 1.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: colors.background,
            padding: EdgeInsets.symmetric(
              horizontal: config.cardPadding,
              vertical: AppSpacing.md,
            ),
            child: CardTitle(
              emoji: '⭐',
              title: type == TaskType.mustDo
                  ? l10n.mustDoTasks
                  : l10n.optionalTasks,
              color: colors.text,
              large: true,
            ),
          ),
          if (tasks.isEmpty)
            Padding(
              padding: EdgeInsets.all(config.cardPadding),
              child: Text(l10n.noTasks),
            ),
          for (final (i, task) in tasks.indexed) ...[
            if (i > 0) const Divider(),
            _TaskRow(
              task: task,
              colors: colors,
              done: scoring?.isDone(task.id, day) ?? false,
              locked: locked,
              weekday: weekday,
              onToggle: () => toggleStar(ref, task, day),
            ),
          ],
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.task,
    required this.colors,
    required this.done,
    required this.locked,
    required this.weekday,
    required this.onToggle,
  });

  final TaskItem task;
  final SectionColors colors;
  final bool done;
  final bool locked;
  final String weekday;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final title = task.displayTitle(l10n);
    final label = locked
        ? l10n.starLocked(title, weekday)
        : done
        ? l10n.starDone(title, weekday)
        : l10n.starNotDone(title, weekday);

    return Container(
      color: c.surfaceAlt,
      constraints: const BoxConstraints(minHeight: AppSpacing.taskRowMinHeight),
      padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.xs),
      child: Row(
        children: [
          Text(task.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyLarge.copyWith(color: c.textPrimary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          PointsBadge(points: task.points, colors: colors),
          StarToggle(
            done: done,
            locked: locked,
            points: task.points,
            size: 36,
            semanticLabel: label,
            onToggle: onToggle,
          ),
        ],
      ),
    );
  }
}

class PointsBadge extends StatelessWidget {
  const PointsBadge({super.key, required this.points, required this.colors});

  final int points;
  final SectionColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        AppLocalizations.of(context).pointsValue(points),
        style: AppTypography.labelLarge.copyWith(color: colors.text),
      ),
    );
  }
}

class DayTotalCard extends ConsumerWidget {
  const DayTotalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final day = ref.watch(selectedDayProvider);
    final points = ref.watch(currentScoringProvider)?.pointsOn(day) ?? 0;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppLocalizations.of(context).dayTotal,
              style: AppTypography.labelLarge.copyWith(color: c.textPrimary),
            ),
          ),
          Icon(Icons.star_rounded, color: c.star),
          const SizedBox(width: AppSpacing.xs),
          AnimatedCount(
            value: points,
            style: AppTypography.titleMedium.copyWith(color: c.textPrimary),
          ),
        ],
      ),
    );
  }
}
