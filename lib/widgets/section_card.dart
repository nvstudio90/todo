import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../domain/models/models.dart';

/// Colours of one area of the board (must-do, optional, rewards).
@immutable
class SectionColors {
  const SectionColors({
    required this.background,
    required this.border,
    required this.text,
  });

  factory SectionColors.forTask(BuildContext context, TaskType type) {
    final c = AppColors.of(context);
    return switch (type) {
      TaskType.mustDo => SectionColors(
        background: c.mustDoBg,
        border: c.mustDoBorder,
        text: c.mustDoText,
      ),
      TaskType.optional => SectionColors(
        background: c.optionalBg,
        border: c.optionalBorder,
        text: c.optionalText,
      ),
    };
  }

  final Color background;
  final Color border;
  final Color text;
}

/// Plain card with the app's border and radius.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.color,
    this.borderColor,
    this.padding,
    this.borderWidth = 1,
  });

  final Widget child;
  final Color? color;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: padding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color ?? c.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: borderColor ?? c.border, width: borderWidth),
        boxShadow: isLight
            ? const [
                BoxShadow(
                  color: Color(0x0F2A2438),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// Card title row: emoji + Baloo title, optional trailing widget.
class CardTitle extends StatelessWidget {
  const CardTitle({
    super.key,
    required this.emoji,
    required this.title,
    this.color,
    this.trailing,
    this.large = false,
  });

  final String emoji;
  final String title;
  final Color? color;
  final Widget? trailing;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final style = (large ? theme.titleLarge : theme.titleMedium)!.copyWith(
      color: color,
    );
    return Semantics(
      header: true,
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$emoji '),
                  TextSpan(text: title),
                ],
              ),
              style: style,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}
