import 'package:flutter/material.dart';

abstract final class AppFonts {
  static const display = 'Baloo2';
  static const body = 'BeVietnamPro';
}

/// Type scale from docs/design-system.md, section 3.
abstract final class AppTypography {
  static TextStyle _display(double size, double height, FontWeight weight) =>
      TextStyle(
        fontFamily: AppFonts.display,
        fontSize: size,
        height: height / size,
        fontWeight: weight,
      );

  static TextStyle _body(double size, double height, FontWeight weight) =>
      TextStyle(
        fontFamily: AppFonts.body,
        fontSize: size,
        height: height / size,
        fontWeight: weight,
      );

  static final displayLarge = _display(36, 40, FontWeight.w800);
  static final displayNumber = _display(40, 44, FontWeight.w800);
  static final titleLarge = _display(22, 28, FontWeight.w800);
  static final titleMedium = _display(18, 24, FontWeight.w700);
  static final bodyLarge = _body(16, 22, FontWeight.w500);
  static final bodyMedium = _body(14, 20, FontWeight.w400);
  static final labelLarge = _body(14, 20, FontWeight.w700);
  static final labelSmall = _body(12, 16, FontWeight.w500);

  static TextTheme textTheme(Color primary, Color secondary) => TextTheme(
    displayLarge: displayLarge.copyWith(color: primary),
    displayMedium: displayNumber.copyWith(color: primary),
    headlineSmall: titleLarge.copyWith(color: primary),
    titleLarge: titleLarge.copyWith(color: primary),
    titleMedium: titleMedium.copyWith(color: primary),
    titleSmall: labelLarge.copyWith(color: primary),
    bodyLarge: bodyLarge.copyWith(color: primary),
    bodyMedium: bodyMedium.copyWith(color: primary),
    bodySmall: labelSmall.copyWith(color: secondary),
    labelLarge: labelLarge.copyWith(color: primary),
    labelMedium: labelSmall.copyWith(color: primary),
    labelSmall: labelSmall.copyWith(color: secondary),
  );
}
