import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../l10n/app_localizations.dart';

/// Header title with each word (and the hyphen in "To-Do") in its own colour.
class AppTitle extends StatelessWidget {
  const AppTitle({super.key, required this.fontSize});

  final double fontSize;

  static final _token = RegExp(r'[^\s-]+|-');

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final text = AppLocalizations.of(context).appTitle;
    final style = AppTypography.displayLarge.copyWith(
      fontSize: fontSize,
      height: 1.15,
    );
    final spans = <TextSpan>[];
    var last = 0;
    var index = 0;
    for (final match in _token.allMatches(text)) {
      if (match.start > last) {
        spans.add(TextSpan(text: text.substring(last, match.start)));
      }
      final palette = colors.titlePalette;
      spans.add(
        TextSpan(
          text: match.group(0),
          style: TextStyle(color: palette[index++ % palette.length]),
        ),
      );
      last = match.end;
    }
    return Semantics(
      header: true,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: AlignmentDirectional.centerStart,
        child: Text.rich(TextSpan(style: style, children: spans), maxLines: 1),
      ),
    );
  }
}

class Slogan extends StatelessWidget {
  const Slogan({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final parts = AppLocalizations.of(context).slogan.split('•');
    return Text.rich(
      TextSpan(
        style: AppTypography.bodyMedium.copyWith(
          color: colors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        children: [
          for (final (i, part) in parts.indexed) ...[
            if (i > 0)
              TextSpan(
                text: '•',
                style: TextStyle(color: colors.sloganDot),
              ),
            TextSpan(text: part),
          ],
        ],
      ),
    );
  }
}
