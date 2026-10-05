import 'dart:math';

import '../entities/compared_scenario.dart';
import '../entities/comparison_metric.dart';
import '../entities/comparison_metric_kind.dart';
import '../entities/scenario.dart';
import '../entities/scenario_comparison.dart';
import '../entities/simulation_baseline.dart';

class CompareScenariosUseCase {
  ScenarioComparison call(SimulationBaseline baseline, List<Scenario> scenarios, List<String> pickedIds) {
    final picked = [
      for (var position = 0; position < scenarios.length; position++)
        if (pickedIds.contains(scenarios[position].id))
          ComparedScenario(position: position, scenario: scenarios[position]),
    ];
    final deltas = [0.0, for (final p in picked) p.monthlyDelta];
    final fixed = baseline.fixedMonthly;
    final goal = baseline.goal;
    return ScenarioComparison(
      today: baseline.today,
      picked: picked,
      goalName: goal?.name,
      metrics: [
        _metric(ComparisonMetricKind.monthlyImpact, deltas, isLowerBetter: true),
        _metric(ComparisonMetricKind.yearlyImpact, [for (final d in deltas) d * 12], isLowerBetter: true),
        _metric(ComparisonMetricKind.fixedCharges, [for (final d in deltas) fixed + d], isLowerBetter: true),
        if (baseline.hasIncome)
          _metric(ComparisonMetricKind.remainingToLive, [
            for (final d in deltas) baseline.income - fixed - d,
          ], isLowerBetter: false),
        if (goal != null)
          _metric(ComparisonMetricKind.goalReachedIn, [
            for (final d in deltas) goal.monthsWith(max(0, goal.monthly - d))?.toDouble(),
          ], isLowerBetter: true),
      ],
    );
  }

  ComparisonMetric _metric(ComparisonMetricKind kind, List<double?> values, {required bool isLowerBetter}) {
    final comparable = [for (final v in values) v ?? double.infinity];
    final best = isLowerBetter ? comparable.reduce(min) : comparable.reduce(max);
    final isDistinct = comparable.toSet().length > 1;
    return ComparisonMetric(
      kind: kind,
      values: values,
      highlights: [for (final v in comparable) isDistinct && v == best],
    );
  }
}
