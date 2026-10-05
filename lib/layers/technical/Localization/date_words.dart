class DateWords {
  const DateWords({
    required this.today,
    required this.yesterday,
    required this.tomorrow,
    required this.firstDayOfMonth,
    required this.yesterdayWith,
  });

  final String today;
  final String yesterday;
  final String tomorrow;
  final String firstDayOfMonth;
  final String Function(String date) yesterdayWith;
}
