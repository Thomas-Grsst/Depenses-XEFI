import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/envelope_impact.dart';
import '../../domain/entities/goal_impact.dart';
import '../../domain/entities/scenario_impact.dart';
import '../widgets/simulation_result_line.dart';
import '../widgets/simulation_trend.dart';
import 'simulations_labels.dart';
import 'simulations_locale.dart';

extension SimulationsImpactLabels on BuildContext {
  List<SimulationResultLine> resultLines(ScenarioImpact impact) {
    final delta = impact.monthlyDelta;
    final signedDelta = money.withSign(delta, money.wholeEuros);
    final trend = SimulationTrend.of(delta);
    final goal = impact.goal;
    return [
      SimulationResultLine(
        label: tr(SimulationsLocale.resultFixedCharges),
        before: money.euros(impact.fixedMonthly),
        after: money.euros(impact.fixedMonthlyAfter),
        change: signedDelta,
        trend: trend,
      ),
      if (impact.hasIncome)
        SimulationResultLine(
          label: trWith(SimulationsLocale.resultRemainingToLive, [money.wholeEuros(impact.income)]),
          before: money.euros(impact.remainingToLiveBefore),
          after: money.euros(impact.remainingToLiveAfter),
          change: money.withSign(-delta, money.wholeEuros),
          trend: trend,
        ),
      for (final envelope in impact.envelopes) _envelopeLine(envelope),
      SimulationResultLine(
        label: tr(SimulationsLocale.resultTypicalMonth),
        before: money.wholeEuros(impact.typicalMonth),
        after: money.wholeEuros(impact.typicalMonthAfter),
        change: signedDelta,
        trend: trend,
      ),
      if (goal != null) _goalLine(goal, impact.today),
    ];
  }

  SimulationResultLine _envelopeLine(EnvelopeImpact envelope) {
    String marginText(double margin) => margin >= 0
        ? trWith(SimulationsLocale.margin, [money.wholeEuros(margin)])
        : trWith(SimulationsLocale.overBy, [money.wholeEuros(-margin)]);
    return SimulationResultLine(
      label: trWith(SimulationsLocale.resultEnvelope, [envelope.categoryName, money.wholeEuros(envelope.budget)]),
      before: marginText(envelope.marginBefore),
      after: marginText(envelope.marginAfter),
      change: tr(envelope.isOverspentAfter ? SimulationsLocale.toReview : SimulationsLocale.fine),
      trend: envelope.isWorse ? SimulationTrend.worse : SimulationTrend.better,
    );
  }

  SimulationResultLine _goalLine(GoalImpact goal, DateTime today) {
    final String change;
    if (goal.isUnchanged) {
      change = tr(SimulationsLocale.unchanged);
    } else if (goal.isReachabilityChanged) {
      change = tr(goal.isBlocked ? SimulationsLocale.blocked : SimulationsLocale.unblocked);
    } else {
      change = money.withSign(
        goal.monthDifference.toDouble(),
        (months) => trWith(SimulationsLocale.monthsCount, [months.round()]),
      );
    }
    return SimulationResultLine(
      label: trWith(SimulationsLocale.resultGoal, [goal.goalName, money.wholeEuros(goal.remaining)]),
      before: goalWhen(today, goal.monthsBefore),
      after: goalWhen(today, goal.monthsAfter),
      change: change,
      trend: SimulationTrend.of(goal.monthDifference.toDouble()),
    );
  }
}
