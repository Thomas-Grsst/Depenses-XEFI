int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

extension CalendarDay on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  bool isSameDay(DateTime other) => year == other.year && month == other.month && day == other.day;

  int get monthIndex => year * 12 + month - 1;

  int get daysInItsMonth => daysInMonth(year, month);

  DateTime get firstOfMonth => DateTime(year, month);

  DateTime get lastOfMonth => DateTime(year, month, daysInItsMonth);

  DateTime get nextDay => DateTime(year, month, day + 1);

  DateTime get previousDay => DateTime(year, month, day - 1);
}

DateTime monthFromIndex(int index) => DateTime(index ~/ 12, index % 12 + 1);
