import 'package:equatable/equatable.dart';

class CategoryStats extends Equatable {
  const CategoryStats({
    required this.categoryKey,
    this.spent = 0,
    this.occasionalSpent = 0,
    this.previousSameDay = 0,
    this.budget = 0,
    this.remainingRecurring = 0,
    this.projected = 0,
  });

  final String categoryKey;
  final double spent;
  final double occasionalSpent;
  final double previousSameDay;
  final double budget;
  final double remainingRecurring;
  final double projected;

  double get recurringSpent => spent - occasionalSpent;

  @override
  List<Object?> get props => [
    categoryKey,
    spent,
    occasionalSpent,
    previousSameDay,
    budget,
    remainingRecurring,
    projected,
  ];
}
