import 'package:depenses/layers/functional/Savings/domain/entities/goal.dart';
import 'package:equatable/equatable.dart';

import 'envelope_baseline.dart';

class SimulationBaseline extends Equatable {
  const SimulationBaseline({
    required this.today,
    this.fixedMonthly = 0,
    this.income = 0,
    this.envelopes = const {},
    this.typicalMonth = 0,
    this.goal,
  });

  final DateTime today;
  final double fixedMonthly;
  final double income;
  final Map<String, EnvelopeBaseline> envelopes;
  final double typicalMonth;
  final Goal? goal;

  bool get hasIncome => income > 0;

  @override
  List<Object?> get props => [today, fixedMonthly, income, envelopes, typicalMonth, goal];
}
