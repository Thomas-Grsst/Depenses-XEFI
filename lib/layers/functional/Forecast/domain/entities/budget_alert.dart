import 'package:equatable/equatable.dart';

enum BudgetAlertKind { overspent, fastPace, projectedOverrun, totalOverrun }

class BudgetAlert extends Equatable {
  const BudgetAlert({
    required this.kind,
    required this.categoryKey,
    this.spent = 0,
    this.budget = 0,
    this.ratio = 0,
    this.day = 0,
    this.overrun = 0,
  });

  final BudgetAlertKind kind;
  final String categoryKey;
  final double spent;
  final double budget;
  final double ratio;
  final int day;
  final double overrun;

  @override
  List<Object?> get props => [kind, categoryKey, spent, budget, ratio, day, overrun];
}
