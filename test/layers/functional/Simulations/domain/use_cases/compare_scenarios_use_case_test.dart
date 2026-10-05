import 'package:depenses/layers/functional/Savings/domain/entities/goal.dart';
import 'package:depenses/layers/functional/Simulations/domain/entities/comparison_metric_kind.dart';
import 'package:depenses/layers/functional/Simulations/domain/use_cases/compare_scenarios_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../simulations_fixtures.dart';

void main() {
  final compare = CompareScenariosUseCase();
  final raise = scenarioWith('a', [rentHypothesis(newAmount: 750)]);
  final cut = scenarioWith('b', [rentHypothesis(newAmount: 680)]);
  final ignored = scenarioWith('c', [rentHypothesis(newAmount: 1000)]);

  test('picked scenarios keep their position in the full list', () {
    final comparison = compare(simulationBaseline(), [raise, ignored, cut], ['b', 'a']);

    expect([for (final p in comparison.picked) p.position], [0, 2]);
  });

  test('the best value of each metric is highlighted', () {
    final comparison = compare(simulationBaseline(), [raise, cut], ['a', 'b']);
    final monthly = comparison.metrics.firstWhere((m) => m.kind == ComparisonMetricKind.monthlyImpact);
    final remaining = comparison.metrics.firstWhere((m) => m.kind == ComparisonMetricKind.remainingToLive);

    expect(monthly.values, [0, 50, -20]);
    expect(monthly.highlights, [false, false, true]);
    expect(remaining.values, [1000, 950, 1020]);
    expect(remaining.highlights, [false, false, true]);
  });

  test('without income or goal those metrics are not compared', () {
    final comparison = compare(simulationBaseline(income: 0), [raise], ['a']);

    expect(comparison.metrics.map((m) => m.kind), [
      ComparisonMetricKind.monthlyImpact,
      ComparisonMetricKind.yearlyImpact,
      ComparisonMetricKind.fixedCharges,
    ]);
  });

  test('identical values are never highlighted', () {
    final comparison = compare(simulationBaseline(), [], const []);

    expect(comparison.metrics.every((m) => m.highlights.every((isBest) => !isBest)), isTrue);
  });

  test('goal months treat an unreachable goal as the worst value', () {
    const goal = Goal(id: 'g', name: 'Vacances', target: 1000, saved: 0, monthly: 100);
    final blocking = scenarioWith('d', [rentHypothesis(newAmount: 900)]);

    final comparison = compare(simulationBaseline(goal: goal), [blocking], ['d']);
    final months = comparison.metrics.firstWhere((m) => m.kind == ComparisonMetricKind.goalReachedIn);

    expect(comparison.goalName, 'Vacances');
    expect(months.values, [10, null]);
    expect(months.highlights, [true, false]);
  });

  test('two picked scenarios tell which one is cheaper and by how much', () {
    final comparison = compare(simulationBaseline(), [raise, cut], ['a', 'b']);

    expect(comparison.cheaper.scenario.id, 'b');
    expect(comparison.pricier.scenario.id, 'a');
    expect(comparison.difference, 70);
    expect(comparison.haveSameImpact, isFalse);
  });
}
