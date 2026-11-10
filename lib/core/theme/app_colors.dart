import 'package:flutter/material.dart';

/// Colour tokens from docs/design-system.md, section 2.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceInset,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.primary,
    required this.onPrimary,
    required this.primarySoft,
    required this.chipIdle,
    required this.star,
    required this.starEmpty,
    required this.titlePalette,
    required this.sloganDot,
    required this.mustDoBg,
    required this.mustDoBorder,
    required this.mustDoText,
    required this.optionalBg,
    required this.optionalBorder,
    required this.optionalText,
    required this.pointsBg,
    required this.rewardBg,
    required this.rewardText,
    required this.streakBg,
    required this.streakText,
    required this.notesBg,
    required this.dayColors,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color surfaceInset;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color primary;
  final Color onPrimary;
  final Color primarySoft;
  final Color chipIdle;
  final Color star;
  final Color starEmpty;

  /// Colours cycled over the words of the header title.
  final List<Color> titlePalette;
  final Color sloganDot;
  final Color mustDoBg;
  final Color mustDoBorder;
  final Color mustDoText;
  final Color optionalBg;
  final Color optionalBorder;
  final Color optionalText;
  final Color pointsBg;
  final Color rewardBg;
  final Color rewardText;
  final Color streakBg;
  final Color streakText;
  final Color notesBg;

  /// Pastel background per weekday, Monday first.
  final List<Color> dayColors;

  static const light = AppColors(
    background: Color(0xFFF2F6FF),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFFBFAFF),
    surfaceInset: Color(0xFFF6F6FA),
    border: Color(0xFFE6E8F2),
    textPrimary: Color(0xFF2A2438),
    textSecondary: Color(0xFF6B6B7B),
    textMuted: Color(0xFFA8A8B3),
    primary: Color(0xFF7B4FD6),
    onPrimary: Color(0xFFFFFFFF),
    primarySoft: Color(0xFFEEE8FE),
    chipIdle: Color(0xFFF6F4FF),
    star: Color(0xFFF5B800),
    starEmpty: Color(0xFFC0C8D0),
    titlePalette: [
      Color(0xFF7B4FD6),
      Color(0xFFF0901E),
      Color(0xFF3FA36B),
      Color(0xFF3A7BE0),
    ],
    sloganDot: Color(0xFFD04070),
    mustDoBg: Color(0xFFFDE8EF),
    mustDoBorder: Color(0xFFF6C3D3),
    mustDoText: Color(0xFFC8406E),
    optionalBg: Color(0xFFEAF4E3),
    optionalBorder: Color(0xFFC9E3BE),
    optionalText: Color(0xFF4E8A45),
    pointsBg: Color(0xFFFEF5D5),
    rewardBg: Color(0xFFFDE8EF),
    rewardText: Color(0xFFC8406E),
    streakBg: Color(0xFFEEE8FE),
    streakText: Color(0xFF6E4FC4),
    notesBg: Color(0xFFFEF5D5),
    dayColors: [
      Color(0xFFEEF4FF),
      Color(0xFFEAF9F7),
      Color(0xFFFFF6E0),
      Color(0xFFF6EEFF),
      Color(0xFFEEF8EE),
      Color(0xFFFFF2E4),
      Color(0xFFFDEEF4),
    ],
  );

  static const dark = AppColors(
    background: Color(0xFF121421),
    surface: Color(0xFF1D1F2D),
    surfaceAlt: Color(0xFF202230),
    surfaceInset: Color(0xFF181A27),
    border: Color(0xFF2A2C3C),
    textPrimary: Color(0xFFE8E6F2),
    textSecondary: Color(0xFFA9A8BA),
    textMuted: Color(0xFF6E6E80),
    primary: Color(0xFFB29DF5),
    onPrimary: Color(0xFF1D1F2D),
    primarySoft: Color(0xFF2B2447),
    chipIdle: Color(0xFF10131B),
    star: Color(0xFFF5B800),
    starEmpty: Color(0xFF505068),
    titlePalette: [
      Color(0xFFB49CFA),
      Color(0xFFF7931E),
      Color(0xFF4CB87D),
      Color(0xFF4A84E6),
    ],
    sloganDot: Color(0xFFD04070),
    mustDoBg: Color(0xFF36212C),
    mustDoBorder: Color(0xFF4A2A3A),
    mustDoText: Color(0xFFE28AAA),
    optionalBg: Color(0xFF1E3022),
    optionalBorder: Color(0xFF2C4A30),
    optionalText: Color(0xFF9FCB96),
    pointsBg: Color(0xFF3A3120),
    rewardBg: Color(0xFF36212A),
    rewardText: Color(0xFFE088A8),
    streakBg: Color(0xFF2B2448),
    streakText: Color(0xFFA99CE0),
    notesBg: Color(0xFF3A3120),
    dayColors: [
      Color(0xFF22263A),
      Color(0xFF1F2A32),
      Color(0xFF2C2C2A),
      Color(0xFF24253D),
      Color(0xFF202B2A),
      Color(0xFF2E2727),
      Color(0xFF2C2333),
    ],
  );

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    List<Color> l(List<Color> a, List<Color> b) => [
      for (var i = 0; i < a.length; i++) c(a[i], b[i]),
    ];
    return AppColors(
      background: c(background, other.background),
      surface: c(surface, other.surface),
      surfaceAlt: c(surfaceAlt, other.surfaceAlt),
      surfaceInset: c(surfaceInset, other.surfaceInset),
      border: c(border, other.border),
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      textMuted: c(textMuted, other.textMuted),
      primary: c(primary, other.primary),
      onPrimary: c(onPrimary, other.onPrimary),
      primarySoft: c(primarySoft, other.primarySoft),
      chipIdle: c(chipIdle, other.chipIdle),
      star: c(star, other.star),
      starEmpty: c(starEmpty, other.starEmpty),
      titlePalette: l(titlePalette, other.titlePalette),
      sloganDot: c(sloganDot, other.sloganDot),
      mustDoBg: c(mustDoBg, other.mustDoBg),
      mustDoBorder: c(mustDoBorder, other.mustDoBorder),
      mustDoText: c(mustDoText, other.mustDoText),
      optionalBg: c(optionalBg, other.optionalBg),
      optionalBorder: c(optionalBorder, other.optionalBorder),
      optionalText: c(optionalText, other.optionalText),
      pointsBg: c(pointsBg, other.pointsBg),
      rewardBg: c(rewardBg, other.rewardBg),
      rewardText: c(rewardText, other.rewardText),
      streakBg: c(streakBg, other.streakBg),
      streakText: c(streakText, other.streakText),
      notesBg: c(notesBg, other.notesBg),
      dayColors: l(dayColors, other.dayColors),
    );
  }
}
