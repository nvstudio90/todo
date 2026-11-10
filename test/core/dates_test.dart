import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo/core/utils/dates.dart';

void main() {
  // The app gets this from flutter_localizations.
  setUpAll(() => initializeDateFormatting('en'));

  group('weekStartOf', () {
    test('Monday stays Monday', () {
      expect(Dates.weekStartOf(DateTime(2026, 11, 9)), DateTime(2026, 11, 9));
    });

    test('Sunday belongs to the week that started on Monday', () {
      expect(Dates.weekStartOf(DateTime(2026, 11, 15)), DateTime(2026, 11, 9));
    });

    test('crosses a month boundary', () {
      expect(Dates.weekStartOf(DateTime(2026, 8, 2)), DateTime(2026, 7, 27));
    });

    test('crosses a year boundary', () {
      expect(Dates.weekStartOf(DateTime(2026, 1, 2)), DateTime(2025, 12, 29));
    });

    test('ignores the time of day', () {
      expect(
        Dates.weekStartOf(DateTime(2026, 11, 11, 23, 59)),
        DateTime(2026, 11, 9),
      );
    });
  });

  test('daysOfWeek lists Monday to Sunday', () {
    final days = Dates.daysOfWeek(DateTime(2025, 12, 29));
    expect(days.first, DateTime(2025, 12, 29));
    expect(days.last, DateTime(2026, 1, 4));
    expect(days.map((d) => d.weekday), [1, 2, 3, 4, 5, 6, 7]);
  });

  test('ymd round-trips', () {
    final day = DateTime(2026, 3, 7);
    expect(Dates.toYmd(day), '2026-03-07');
    expect(Dates.fromYmd('2026-03-07'), day);
  });

  group('formatWeekRange', () {
    test('Vietnamese, same month', () {
      expect(
        Dates.formatWeekRange(DateTime(2026, 11, 9), 'vi'),
        '9/11 – 15/11/2026',
      );
    });

    test('Vietnamese, across years', () {
      expect(
        Dates.formatWeekRange(DateTime(2025, 12, 29), 'vi'),
        '29/12/2025 – 4/1/2026',
      );
    });

    test('English, same month', () {
      expect(
        Dates.formatWeekRange(DateTime(2026, 11, 9), 'en'),
        'Nov 9 – 15, 2026',
      );
    });

    test('English, across months', () {
      expect(
        Dates.formatWeekRange(DateTime(2026, 10, 26), 'en'),
        'Oct 26 – Nov 1, 2026',
      );
    });

    test('English, across years', () {
      expect(
        Dates.formatWeekRange(DateTime(2025, 12, 29), 'en'),
        'Dec 29, 2025 – Jan 4, 2026',
      );
    });
  });
}
