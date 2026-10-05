Map<String, dynamic> forecastExpense(
  String id,
  double amount,
  String date, {
  String category = 'ali',
  String? recurrenceId,
  double roundUp = 0,
}) => {
  'id': id,
  'name': id,
  'amount': amount,
  'date': date,
  'cat': category,
  'labels': <String>[],
  'recId': recurrenceId,
  'roundUp': roundUp,
};

Map<String, dynamic> forecastRecurrence(
  String id,
  String name,
  double amount,
  String start, {
  String frequency = 'month',
  String category = 'log',
}) => {
  'id': id,
  'name': name,
  'amount': amount,
  'cat': category,
  'freq': frequency,
  'start': start,
  'labels': <String>[],
  'lastGen': null,
};
