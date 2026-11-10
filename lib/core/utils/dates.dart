import 'package:intl/intl.dart';

/// Calendar-day helpers. Dates are local midnights built from y/m/d, never by
/// adding Durations, so DST shifts cannot move a day.
abstract final class Dates {
  static DateTime dateOnly(DateTime t) => DateTime(t.year, t.month, t.day);

  static DateTime addDays(DateTime day, int days) =>
      DateTime(day.year, day.month, day.day + days);

  /// Monday of the week containing [day].
  static DateTime weekStartOf(DateTime day) =>
      addDays(dateOnly(day), -(day.weekday - DateTime.monday));

  static List<DateTime> daysOfWeek(DateTime weekStart) => [
    for (var i = 0; i < DateTime.daysPerWeek; i++) addDays(weekStart, i),
  ];

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String toYmd(DateTime day) => DateFormat('yyyy-MM-dd').format(day);

  static DateTime fromYmd(String ymd) {
    final [y, m, d] = ymd.split('-').map(int.parse).toList();
    return DateTime(y, m, d);
  }

  /// "9/11 – 15/11/2026" in Vietnamese, "Nov 9 – 15, 2026" in English.
  static String formatWeekRange(DateTime weekStart, String locale) {
    final end = addDays(weekStart, DateTime.daysPerWeek - 1);
    final sameYear = weekStart.year == end.year;
    if (locale.startsWith('vi')) {
      final startText = sameYear
          ? '${weekStart.day}/${weekStart.month}'
          : '${weekStart.day}/${weekStart.month}/${weekStart.year}';
      return '$startText – ${end.day}/${end.month}/${end.year}';
    }
    final monthDay = DateFormat.MMMd(locale);
    if (!sameYear) {
      final full = DateFormat.yMMMd(locale);
      return '${full.format(weekStart)} – ${full.format(end)}';
    }
    final endText = weekStart.month == end.month
        ? DateFormat.d(locale).format(end)
        : monthDay.format(end);
    return '${monthDay.format(weekStart)} – $endText, ${end.year}';
  }
}
