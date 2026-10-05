Map<String, dynamic> savingsExpense(String id, String name, double amount, String date, {double roundUp = 0}) => {
  'id': id,
  'name': name,
  'amount': amount,
  'date': date,
  'cat': 'ali',
  'labels': <String>[],
  'roundUp': roundUp,
};

Map<String, dynamic> savingsGoal(
  String id,
  String name, {
  double target = 1000,
  double saved = 0,
  double monthly = 0,
}) => {'id': id, 'name': name, 'target': target, 'saved': saved, 'monthly': monthly};
