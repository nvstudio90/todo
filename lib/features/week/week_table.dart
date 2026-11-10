import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout/layout_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/dates.dart';
import '../../domain/models/models.dart';
import '../../domain/scoring/scoring.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/seed_text.dart';
import '../../widgets/section_card.dart';
import '../../widgets/star_toggle.dart';
import '../home/home_state.dart';
import '../today/star_actions.dart';

const _pointColumnWidth = 52.0;
const _totalColumnWidth = 52.0;

/// Week grid like the web board: a fixed task-name column, then points, the
/// seven days and the total, scrolling sideways only when they do not fit.
class WeekTable extends ConsumerStatefulWidget {
  const WeekTable({super.key, required this.type});

  final TaskType type;

  @override
  ConsumerState<WeekTable> createState() => _WeekTableState();
}

class _WeekTableState extends ConsumerState<WeekTable> {
  final _scroll = ScrollController();
  DateTime? _scrolledForWeek;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Brings today's column into view when the grid has to scroll.
  void _revealToday(DateTime week, double dayWidth, double viewport) {
    if (_scrolledForWeek == week) return;
    _scrolledForWeek = week;
    final today = ref.read(todayProvider);
    final index = Dates.daysOfWeek(week)
        .indexWhere((d) => Dates.isSameDay(d, today));
    if (index < 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final target =
          _pointColumnWidth + index * dayWidth - (viewport - dayWidth) / 2;
      _scroll.jumpTo(target.clamp(0, _scroll.position.maxScrollExtent));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final colors = SectionColors.forTask(context, widget.type);
    final config = LayoutConfig.of(context);
    final tasks = ref.watch(visibleTasksProvider(widget.type)) ?? const [];
    final scoring = ref.watch(currentScoringProvider);
    final week = ref.watch(selectedWeekProvider);
    final today = ref.watch(todayProvider);
    final days = Dates.daysOfWeek(week);
    final textScaler = MediaQuery.textScalerOf(context);
    // Every row fits two lines of task name so both halves line up.
    final rowHeight = max(
      AppSpacing.taskRowMinHeight + 4,
      textScaler.scale(16) * 22 / 16 * 2 + 16,
    );
    final headerHeight = max(56.0, textScaler.scale(14) * 20 / 14 * 2 + 20);
    final title = widget.type == TaskType.mustDo
        ? l10n.mustDoTasks
        : l10n.optionalTasks;

    return AppCard(
      borderColor: colors.border,
      borderWidth: 1.5,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          // Names shrink first, then days down to the tap-target size;
          // only after that does the grid scroll sideways.
          const fixed = _pointColumnWidth + _totalColumnWidth;
          final nameWidth = (width - fixed - 7 * config.dayColumnMinWidth)
              .clamp(min(140.0, width * 0.45), config.taskNameColumnWidth)
              .toDouble();
          final rest = width - nameWidth - fixed;
          final fits = rest >= 7 * AppSpacing.minTap;
          final dayWidth = fits ? rest / 7 : config.dayColumnMinWidth;
          if (!fits) _revealToday(week, dayWidth, width - nameWidth);

          final names = Column(
            children: [
              _cell(
                height: headerHeight,
                color: colors.background,
                align: AlignmentDirectional.centerStart,
                padding: const EdgeInsetsDirectional.only(start: AppSpacing.md),
                child: CardTitle(emoji: '⭐', title: title, color: colors.text),
              ),
              for (final task in tasks)
                _cell(
                  height: rowHeight,
                  color: c.surfaceAlt,
                  align: AlignmentDirectional.centerStart,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: _TaskName(task: task),
                ),
              _cell(
                height: headerHeight,
                align: AlignmentDirectional.centerStart,
                padding: const EdgeInsetsDirectional.only(start: AppSpacing.md),
                child: Text(
                  l10n.dailyTotal,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelLarge.copyWith(
                    color: c.textPrimary,
                  ),
                ),
              ),
            ],
          );

          final grid = SizedBox(
            width: _pointColumnWidth + 7 * dayWidth + _totalColumnWidth,
            child: Column(
              children: [
                _headerRow(
                  context,
                  days,
                  today,
                  dayWidth,
                  headerHeight,
                  colors,
                ),
                for (final task in tasks)
                  _taskRow(
                    context,
                    task,
                    days,
                    today,
                    dayWidth,
                    rowHeight,
                    colors,
                    scoring,
                  ),
                _totalRow(context, days, dayWidth, headerHeight, scoring),
              ],
            ),
          );

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: nameWidth,
                // Edge between the pinned names and the scrolling days.
                decoration: fits
                    ? null
                    : BoxDecoration(
                        border: Border(
                          right: BorderSide(color: c.border, width: 2),
                        ),
                      ),
                child: names,
              ),
              Expanded(
                child: fits
                    ? grid
                    : Scrollbar(
                        controller: _scroll,
                        child: SingleChildScrollView(
                          controller: _scroll,
                          scrollDirection: Axis.horizontal,
                          child: grid,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _cell({
    required double height,
    double? width,
    Color? color,
    AlignmentGeometry align = Alignment.center,
    EdgeInsetsGeometry? padding,
    bool underline = false,
    required Widget child,
  }) {
    final c = AppColors.of(context);
    return Container(
      width: width,
      height: height,
      alignment: align,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: Border(
          bottom: underline
              ? BorderSide(color: c.primary, width: 2)
              : BorderSide(color: c.border),
        ),
      ),
      child: child,
    );
  }

  Widget _headerRow(
    BuildContext context,
    List<DateTime> days,
    DateTime today,
    double dayWidth,
    double height,
    SectionColors colors,
  ) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    return Row(
      children: [
        _cell(
          width: _pointColumnWidth,
          height: height,
          color: colors.background,
          child: _HeaderText(l10n.columnPoints, color: c.textPrimary),
        ),
        for (final (i, day) in days.indexed)
          _cell(
            width: dayWidth,
            height: height,
            color: c.dayColors[i],
            underline: Dates.isSameDay(day, today),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _HeaderText(
                  l10n.weekdayOf(day),
                  color: Dates.isSameDay(day, today)
                      ? c.primary
                      : c.textPrimary,
                ),
                Text(
                  '${day.day}/${day.month}',
                  maxLines: 1,
                  style: AppTypography.labelSmall.copyWith(
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        _cell(
          width: _totalColumnWidth,
          height: height,
          child: _HeaderText(l10n.columnTotal, color: c.textPrimary),
        ),
      ],
    );
  }

  Widget _taskRow(
    BuildContext context,
    TaskItem task,
    List<DateTime> days,
    DateTime today,
    double dayWidth,
    double height,
    SectionColors colors,
    Scoring? scoring,
  ) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final title = task.displayTitle(l10n);
    final week = days.first;
    final total = scoring?.taskPointsInWeek(task.id, week) ?? 0;
    return Row(
      children: [
        _cell(
          width: _pointColumnWidth,
          height: height,
          color: colors.background,
          child: Text(
            l10n.pointsValue(task.points),
            style: AppTypography.labelLarge.copyWith(color: colors.text),
          ),
        ),
        for (final (i, day) in days.indexed)
          _cell(
            width: dayWidth,
            height: height,
            color: c.dayColors[i],
            child: _star(context, task, day, today, title, scoring),
          ),
        _cell(
          width: _totalColumnWidth,
          height: height,
          child: Text(
            total == 0 ? '' : '$total',
            style: AppTypography.labelLarge.copyWith(color: c.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _star(
    BuildContext context,
    TaskItem task,
    DateTime day,
    DateTime today,
    String title,
    Scoring? scoring,
  ) {
    final l10n = AppLocalizations.of(context);
    final done = scoring?.isDone(task.id, day) ?? false;
    final locked = day.isAfter(today);
    final weekday = l10n.weekdayOf(day);
    return StarToggle(
      done: done,
      locked: locked,
      points: task.points,
      semanticLabel: locked
          ? l10n.starLocked(title, weekday)
          : done
          ? l10n.starDone(title, weekday)
          : l10n.starNotDone(title, weekday),
      onToggle: () => toggleStar(ref, task, day),
    );
  }

  Widget _totalRow(
    BuildContext context,
    List<DateTime> days,
    double dayWidth,
    double height,
    Scoring? scoring,
  ) {
    final c = AppColors.of(context);
    final perDay = [
      for (final day in days) scoring?.pointsOn(day, type: widget.type) ?? 0,
    ];
    final sum = perDay.fold(0, (a, b) => a + b);
    TextStyle style(int v) => AppTypography.labelLarge.copyWith(
      color: v == 0 ? c.textMuted : c.textPrimary,
    );
    return Row(
      children: [
        _cell(
          width: _pointColumnWidth,
          height: height,
          child: const SizedBox(),
        ),
        for (final (i, v) in perDay.indexed)
          _cell(
            width: dayWidth,
            height: height,
            color: c.dayColors[i],
            child: Text(v == 0 ? '–' : '$v', style: style(v)),
          ),
        _cell(
          width: _totalColumnWidth,
          height: height,
          child: Text('$sum', style: style(sum)),
        ),
      ],
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText(this.text, {required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        maxLines: 1,
        style: AppTypography.labelLarge.copyWith(color: color),
      ),
    );
  }
}

class _TaskName extends StatelessWidget {
  const _TaskName({required this.task});

  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Row(
      children: [
        Text(task.emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            task.displayTitle(AppLocalizations.of(context)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium.copyWith(
              color: c.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
