import 'package:depenses/layers/functional/Savings/domain/entities/goal.dart';
import 'package:depenses/layers/functional/Simulations/domain/use_cases/compute_scenario_impact_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../simulations_fixtures.dart';

void main() {
  final computeImpact = ComputeScenarioImpactUseCase();

  test('a rent raise increases fixed charges and lowers what is left to live on', () {
    final impact = computeImpact(simulationBaseline(), [rentHypothesis()]);

    expect(impact.monthlyDelta, 200);
    expect(impact.yearlyDelta, 2400);
    expect(impact.fixedMonthlyAfter, 1200);
    expect(impact.remainingToLiveBefore, 1000);
    expect(impact.remainingToLiveAfter, 800);
    expect(impact.typicalMonthAfter, 1700);
    expect(impact.isUnchanged, isFalse);
  });

  test('the envelope of the hypothesis category shows its margin before and after', () {
    final envelope = computeImpact(simulationBaseline(), [rentHypothesis()]).envelopes.single;

    expect(envelope.categoryName, 'Logement');
    expect(envelope.marginBefore, 100);
    expect(envelope.marginAfter, -100);
    expect(envelope.isOverspentAfter, isTrue);
    expect(envelope.isWorse, isTrue);
  });

  test('envelopes without budget or without change are left out', () {
    final unchanged = computeImpact(simulationBaseline(), [rentHypothesis(newAmount: 700)]);

    expect(unchanged.envelopes, isEmpty);
    expect(unchanged.isUnchanged, isTrue);
  });

  test('cutting a charge frees the goal earlier', () {
    const goal = Goal(id: 'g', name: 'Vacances', target: 1000, saved: 0, monthly: 100);

    final impact = computeImpact(simulationBaseline(goal: goal), [rentHypothesis(isKept: false)]);

    expect(impact.monthlyDelta, -700);
    expect(impact.goal?.monthsBefore, 10);
    expect(impact.goal?.monthsAfter, 2);
    expect(impact.goal?.monthDifference, -8);
    expect(impact.goal?.isReachabilityChanged, isFalse);
  });

  test('a raise larger than the monthly saving blocks the goal', () {
    const goal = Goal(id: 'g', name: 'Vacances', target: 1000, saved: 0, monthly: 100);

    final impact = computeImpact(simulationBaseline(goal: goal), [rentHypothesis()]);

    expect(impact.goal?.monthsAfter, isNull);
    expect(impact.goal?.isReachabilityChanged, isTrue);
    expect(impact.goal?.isBlocked, isTrue);
  });
}
