import 'dart:math';

import '../entities/envelope_impact.dart';
import '../entities/goal_impact.dart';
import '../entities/hypothesis.dart';
import '../entities/scenario_impact.dart';
import '../entities/simulation_baseline.dart';

const _negligibleAmount = 0.005;

class ComputeScenarioImpactUseCase {
  ScenarioImpact call(SimulationBaseline baseline, List<Hypothesis> hypotheses) {
    final delta = hypotheses.fold(0.0, (total, h) => total + h.monthlyDelta);
    final goal = baseline.goal;
    return ScenarioImpact(
      today: baseline.today,
      monthlyDelta: delta,
      fixedMonthly: baseline.fixedMonthly,
      income: baseline.income,
      envelopes: _envelopes(baseline, hypotheses),
      typicalMonth: baseline.typicalMonth,
      goal: goal == null
          ? null
          : GoalImpact(
              goalName: goal.name,
              remaining: goal.remaining,
              monthsBefore: goal.monthsWith(goal.monthly),
              monthsAfter: goal.monthsWith(max(0, goal.monthly - delta)),
            ),
    );
  }

  List<EnvelopeImpact> _envelopes(SimulationBaseline baseline, List<Hypothesis> hypotheses) {
    final deltaPerCategory = <String, double>{};
    for (final hypothesis in hypotheses) {
      deltaPerCategory[hypothesis.categoryKey] =
          (deltaPerCategory[hypothesis.categoryKey] ?? 0) + hypothesis.monthlyDelta;
    }
    return [
      for (final entry in deltaPerCategory.entries)
        if (baseline.envelopes[entry.key] case final envelope?)
          if (envelope.budget > 0 && entry.value.abs() >= _negligibleAmount)
            EnvelopeImpact(
              categoryName: envelope.categoryName,
              budget: envelope.budget,
              marginBefore: envelope.margin,
              marginAfter: envelope.margin - entry.value,
            ),
    ];
  }
}
