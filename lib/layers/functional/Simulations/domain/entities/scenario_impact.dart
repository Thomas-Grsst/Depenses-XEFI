import 'package:equatable/equatable.dart';

import 'envelope_impact.dart';
import 'goal_impact.dart';

const _negligibleAmount = 0.005;

class ScenarioImpact extends Equatable {
  const ScenarioImpact({
    required this.today,
    this.monthlyDelta = 0,
    this.fixedMonthly = 0,
    this.income = 0,
    this.envelopes = const [],
    this.typicalMonth = 0,
    this.goal,
  });

  final DateTime today;
  final double monthlyDelta;
  final double fixedMonthly;
  final double income;
  final List<EnvelopeImpact> envelopes;
  final double typicalMonth;
  final GoalImpact? goal;

  bool get isUnchanged => monthlyDelta.abs() < _negligibleAmount;

  bool get hasIncome => income > 0;

  double get yearlyDelta => monthlyDelta * 12;

  double get fixedMonthlyAfter => fixedMonthly + monthlyDelta;

  double get remainingToLiveBefore => income - fixedMonthly;

  double get remainingToLiveAfter => income - fixedMonthly - monthlyDelta;

  double get typicalMonthAfter => typicalMonth + monthlyDelta;

  @override
  List<Object?> get props => [today, monthlyDelta, fixedMonthly, income, envelopes, typicalMonth, goal];
}
