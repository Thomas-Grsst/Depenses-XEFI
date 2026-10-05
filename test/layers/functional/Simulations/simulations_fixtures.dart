import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Savings/domain/entities/goal.dart';
import 'package:depenses/layers/functional/Simulations/domain/entities/envelope_baseline.dart';
import 'package:depenses/layers/functional/Simulations/domain/entities/hypothesis.dart';
import 'package:depenses/layers/functional/Simulations/domain/entities/scenario.dart';
import 'package:depenses/layers/functional/Simulations/domain/entities/simulation_baseline.dart';

final simulationsToday = DateTime(2026, 10, 15);

Hypothesis rentHypothesis({double newAmount = 900, bool isKept = true}) => Hypothesis(
  recurrenceId: 'rent',
  name: 'Loyer',
  categoryKey: 'log',
  frequency: Frequency.month,
  oldAmount: 700,
  newAmount: newAmount,
  isKept: isKept,
);

Scenario scenarioWith(String id, List<Hypothesis> hypotheses) =>
    Scenario(id: id, title: 'Scénario $id', description: '', createdAt: simulationsToday, hypotheses: hypotheses);

SimulationBaseline simulationBaseline({double income = 2000, Goal? goal}) => SimulationBaseline(
  today: simulationsToday,
  fixedMonthly: 1000,
  income: income,
  envelopes: const {
    'log': EnvelopeBaseline(categoryKey: 'log', categoryName: 'Logement', budget: 800, projected: 700),
    'ali': EnvelopeBaseline(categoryKey: 'ali', categoryName: 'Alimentation', budget: 0, projected: 300),
  },
  typicalMonth: 1500,
  goal: goal,
);

Map<String, dynamic> recurrenceJson(String id, String name, double amount, String frequency, {String cat = 'log'}) => {
  'id': id,
  'name': name,
  'amount': amount,
  'cat': cat,
  'freq': frequency,
  'start': '2026-11-01',
  'labels': <String>[],
};
