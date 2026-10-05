import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/scenario_comparison.dart';
import '../l10n/simulations_comparison_labels.dart';
import '../l10n/simulations_labels.dart';
import '../l10n/simulations_locale.dart';
import 'simulations_comparison_columns.dart';
import 'simulations_comparison_insight.dart';
import 'simulations_metric_row.dart';

class SimulationsComparisonTable extends StatelessWidget {
  const SimulationsComparisonTable({super.key, required this.comparison});

  final ScenarioComparison comparison;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!tokens.isGraphite)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(context.tr(SimulationsLocale.comparison), style: tokens.ts(15, FontWeight.w800)),
          ),
        SimulationsComparisonColumns(
          columns: [
            (context.tr(SimulationsLocale.actualLetter), context.tr(SimulationsLocale.actualTitle)),
            for (final p in comparison.picked) (context.scenarioLetter(p.position), p.scenario.title),
          ],
        ),
        for (final metric in comparison.metrics)
          SimulationsMetricRow(
            label: context.metricLabel(metric.kind, comparison.goalName),
            cells: [
              for (var i = 0; i < metric.values.length; i++)
                (context.metricValue(metric.kind, metric.values[i], comparison.today), metric.highlights[i]),
            ],
          ),
        SimulationsComparisonInsight(context.comparisonInsight(comparison)),
      ],
    );
  }
}
