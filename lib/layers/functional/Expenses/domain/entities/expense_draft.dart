import 'package:equatable/equatable.dart';

class ExpenseDraft extends Equatable {
  const ExpenseDraft({
    required this.name,
    required this.amount,
    required this.date,
    required this.categoryKey,
    this.labels = const [],
  });

  final String name;
  final double amount;
  final DateTime date;
  final String categoryKey;
  final List<String> labels;

  @override
  List<Object?> get props => [name, amount, date, categoryKey, labels];
}
