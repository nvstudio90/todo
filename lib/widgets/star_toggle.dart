import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

class StarToggle extends StatefulWidget {
  const StarToggle({
    super.key,
    required this.done,
    required this.locked,
    required this.points,
    required this.semanticLabel,
    required this.onToggle,
    this.size = 24,
  });

  final bool done;

  /// Future days: shown faded and not tappable.
  final bool locked;
  final int points;
  final String semanticLabel;
  final VoidCallback onToggle;
  final double size;

  @override
  State<StarToggle> createState() => _StarToggleState();
}

class _StarToggleState extends State<StarToggle> with TickerProviderStateMixin {
  late final _pop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  late final _float = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  // easeOutBack overshoots past 1, which TweenSequence rejects as its input,
  // so the curve is applied inside the second step instead.
  late final Animation<double> _scale = TweenSequence([
    TweenSequenceItem(
      tween: Tween(
        begin: 1.0,
        end: 1.3,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: 1.3,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOutBack)),
      weight: 1,
    ),
  ]).animate(_pop);

  @override
  void dispose() {
    _pop.dispose();
    _float.dispose();
    super.dispose();
  }

  void _handleTap() {
    unawaited(HapticFeedback.lightImpact());
    if (!widget.done) {
      unawaited(_pop.forward(from: 0));
      unawaited(_float.forward(from: 0));
    }
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final filled = widget.done;
    final iconSize = filled ? widget.size : widget.size - 2;
    final tapSize = widget.size < AppSpacing.minTap - 8
        ? AppSpacing.minTap
        : widget.size + 20;

    Widget star = ScaleTransition(
      scale: _scale,
      child: Icon(
        filled ? Icons.star_rounded : Icons.star_outline_rounded,
        size: iconSize,
        color: filled ? colors.star : colors.starEmpty,
      ),
    );
    if (widget.locked) star = Opacity(opacity: 0.4, child: star);

    return Semantics(
      button: !widget.locked,
      toggled: widget.done,
      enabled: !widget.locked,
      label: widget.semanticLabel,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: tapSize,
        child: InkResponse(
          onTap: widget.locked ? null : _handleTap,
          radius: tapSize / 2,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              star,
              _FloatingPoints(animation: _float, points: widget.points),
            ],
          ),
        ),
      ),
    );
  }
}

/// "+2" that drifts up and fades after a star is given.
class _FloatingPoints extends AnimatedWidget {
  const _FloatingPoints({
    required Animation<double> animation,
    required this.points,
  }) : super(listenable: animation);

  final int points;

  @override
  Widget build(BuildContext context) {
    final t = (listenable as Animation<double>).value;
    if (t == 0 || t == 1) return const SizedBox.shrink();
    return Positioned(
      top: -12 - 18 * t,
      child: IgnorePointer(
        child: Opacity(
          opacity: 1 - t,
          child: Text(
            '+$points',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.of(context).star,
            ),
          ),
        ),
      ),
    );
  }
}
