import 'package:depenses/layers/functional/Expenses/domain/entities/described_expense.dart';
import 'package:equatable/equatable.dart';

import 'home_occurrence.dart';

class HomeListsState extends Equatable {
  const HomeListsState({required this.name, required this.today, this.upcoming = const [], this.recent = const []});

  final String name;
  final DateTime today;
  final List<HomeOccurrence> upcoming;
  final List<DescribedExpense> recent;

  @override
  List<Object?> get props => [name, today, upcoming, recent];
}
