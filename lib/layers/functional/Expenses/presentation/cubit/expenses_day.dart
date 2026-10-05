import 'package:equatable/equatable.dart';

import '../../domain/entities/described_expense.dart';

class ExpensesDay extends Equatable {
  const ExpensesDay({required this.day, required this.items});

  final DateTime day;
  final List<DescribedExpense> items;

  @override
  List<Object?> get props => [day, items];
}
