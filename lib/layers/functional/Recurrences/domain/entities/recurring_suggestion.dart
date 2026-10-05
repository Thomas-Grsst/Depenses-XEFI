import 'package:equatable/equatable.dart';

class RecurringSuggestion extends Equatable {
  const RecurringSuggestion({
    required this.key,
    required this.name,
    required this.categoryKey,
    required this.amount,
    required this.months,
    required this.lastDate,
    required this.labels,
    required this.expenseIds,
  });

  final String key;
  final String name;
  final String categoryKey;
  final double amount;
  final int months;
  final DateTime lastDate;
  final List<String> labels;
  final List<String> expenseIds;

  @override
  List<Object?> get props => [key, name, categoryKey, amount, months, lastDate, labels, expenseIds];
}
