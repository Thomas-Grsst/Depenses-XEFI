import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/scenario_impact.dart';
import '../l10n/simulations_impact_labels.dart';
import '../l10n/simulations_locale.dart';
import 'simulation_impact_hero.dart';
import 'simulation_result_row.dart';

class SimulationResultsSection extends StatelessWidget {
  const SimulationResultsSection({super.key, required this.impact});

  final ScenarioImpact impact;

  @override
  Widget build(BuildContext context) {
    final graphite = context.tokens.isGraphite;
    final lines = context.resultLines(impact);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!graphite) ...[AppSectionLabel(context.tr(SimulationsLocale.whatChanges)), const SizedBox(height: 6)],
        SimulationImpactHero(impact: impact),
        SizedBox(height: graphite ? 18 : AppSpacing.sm),
        if (graphite)
          Column(
            children: [for (final line in lines) AppRuled(child: SimulationResultRow(line: line))],
          )
        else
          AppPanel(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 6),
            child: Column(
              children: [
                for (final line in lines) AppRuled(verticalPadding: 20, child: SimulationResultRow(line: line)),
              ],
            ),
          ),
      ],
    );
  }
}
