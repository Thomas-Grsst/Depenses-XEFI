import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/comparison_metric_kind.dart';
import '../../domain/entities/scenario_comparison.dart';
import 'simulations_labels.dart';
import 'simulations_locale.dart';

const _negligibleAmount = 0.005;

extension SimulationsComparisonLabels on BuildContext {
  String metricLabel(ComparisonMetricKind kind, String? goalName) => switch (kind) {
    ComparisonMetricKind.monthlyImpact => tr(SimulationsLocale.metricMonthlyImpact),
    ComparisonMetricKind.yearlyImpact => tr(SimulationsLocale.metricYearlyImpact),
    ComparisonMetricKind.fixedCharges => tr(SimulationsLocale.metricFixedCharges),
    ComparisonMetricKind.remainingToLive => tr(SimulationsLocale.metricRemainingToLive),
    ComparisonMetricKind.goalReachedIn => trWith(SimulationsLocale.metricGoalReachedIn, [goalName ?? '']),
  };

  String metricValue(ComparisonMetricKind kind, double? value, DateTime today) {
    switch (kind) {
      case ComparisonMetricKind.monthlyImpact:
        return _signedOrNothing(value ?? 0, money.euros);
      case ComparisonMetricKind.yearlyImpact:
        return _signedOrNothing(value ?? 0, money.wholeEuros);
      case ComparisonMetricKind.fixedCharges:
      case ComparisonMetricKind.remainingToLive:
        return money.euros(value ?? 0);
      case ComparisonMetricKind.goalReachedIn:
        if (value == null) return tr(SimulationsLocale.never);
        if (value == 0) return tr(SimulationsLocale.reached);
        return monthAfter(today, value.round());
    }
  }

  String comparisonInsight(ScenarioComparison comparison) {
    final picked = comparison.picked;
    if (picked.isEmpty || picked.length > 2) return tr(SimulationsLocale.insightNone);
    if (picked.length == 1) {
      return trWith(SimulationsLocale.insightOne, [
        scenarioLetter(picked.first.position),
        money.withSign(-picked.first.monthlyDelta, money.wholeEuros),
      ]);
    }
    if (comparison.haveSameImpact) {
      return trWith(SimulationsLocale.insightSame, [
        scenarioLetter(picked.first.position),
        scenarioLetter(picked.last.position),
      ]);
    }
    return trWith(SimulationsLocale.insightCheaper, [
      scenarioLetter(comparison.cheaper.position),
      money.euros(comparison.difference),
      scenarioLetter(comparison.pricier.position),
      money.wholeEuros(comparison.difference * 12),
    ]);
  }

  String _signedOrNothing(double value, String Function(double) format) =>
      value.abs() < _negligibleAmount ? tr(SimulationsLocale.noValue) : money.withSign(value, format);
}
