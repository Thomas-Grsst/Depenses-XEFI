import 'package:intl/intl.dart';

import '../Calendar/calendar_day.dart';
import 'capitalize.dart';
import 'date_words.dart';

class DateLabels {
  const DateLabels(this.locale, this.words);

  final String locale;
  final DateWords words;

  String dayNumber(DateTime date) => date.day == 1 ? words.firstDayOfMonth : '${date.day}';

  String dayAndMonth(DateTime date) => '${dayNumber(date)} ${DateFormat.MMMM(locale).format(date)}';

  String longDate(DateTime date, {required DateTime today}) {
    final weekday = DateFormat.EEEE(locale).format(date);
    final year = date.year == today.year ? '' : ' ${date.year}';
    return capitalize('$weekday ${dayAndMonth(date)}$year');
  }

  String shortDate(DateTime date) => DateFormat('d MMM', locale).format(date);

  String dayHeader(DateTime date, {required DateTime today}) {
    if (date.isSameDay(today)) return words.today;
    if (date.isSameDay(today.previousDay)) return words.yesterdayWith(dayAndMonth(date));
    return longDate(date, today: today);
  }

  String relativeDay(DateTime date, {required DateTime today}) {
    if (date.isSameDay(today)) return words.today;
    if (date.isSameDay(today.previousDay)) return words.yesterday;
    if (date.isSameDay(today.nextDay)) return words.tomorrow;
    return shortDate(date);
  }

  String monthYear(DateTime month) => capitalize(DateFormat.yMMMM(locale).format(month));

  String monthName(DateTime month) => DateFormat.MMMM(locale).format(month);

  String shortMonthName(DateTime month) => DateFormat.MMM(locale).format(month);

  String weekday(DateTime date) => DateFormat.EEEE(locale).format(date);

  String shortWeekday(DateTime date) => DateFormat.E(locale).format(date);
}
