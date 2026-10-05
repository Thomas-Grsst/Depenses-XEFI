import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/simulation_cubit.dart';
import '../cubit/simulation_state.dart';
import '../l10n/simulations_locale.dart';
import 'simulation_add_hypothesis_sheet.dart';
import 'simulation_hypothesis_card.dart';
import 'simulation_hypothesis_choice.dart';
import 'simulation_new_charge_sheet.dart';

class SimulationHypothesesSection extends StatelessWidget {
  const SimulationHypothesesSection({super.key, required this.state});

  final SimulationState state;

  Future<void> _addHypothesis(BuildContext context) async {
    final cubit = context.read<SimulationCubit>();
    final closeLabel = context.tr(SimulationsLocale.close);
    final choice = await AppSheet.show<SimulationHypothesisChoice>(
      context,
      title: context.tr(SimulationsLocale.addHypothesisTitle),
      closeLabel: closeLabel,
      builder: (_) => SimulationAddHypothesisSheet(
        recurrences: state.availableRecurrences,
        hasRecurrences: state.hasRecurrences,
        badges: state.badges,
      ),
    );
    if (choice == null || !context.mounted) return;
    final recurrence = choice.recurrence;
    if (recurrence != null) return cubit.addRecurrence(recurrence);
    final entry = await AppSheet.show<(String, String)>(
      context,
      title: context.tr(SimulationsLocale.newChargeTitle),
      closeLabel: closeLabel,
      builder: (_) => const SimulationNewChargeSheet(),
    );
    if (entry == null || !context.mounted) return;
    cubit.addNewCharge(
      name: entry.$1,
      monthlyAmount: context.money.parse(entry.$2),
      fallbackName: context.tr(SimulationsLocale.defaultChargeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionLabel(context.tr(graphite ? SimulationsLocale.hypothesesShort : SimulationsLocale.hypothesesLong)),
        const SizedBox(height: 6),
        if (!state.hasHypotheses)
          AppPanel(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppRuled(
              child: Text(
                context.tr(SimulationsLocale.emptyHypotheses),
                style: tokens.ts(14, tokens.wBody, tokens.muted).copyWith(height: 1.45),
              ),
            ),
          ),
        ...spaced([
          for (var i = 0; i < state.hypotheses.length; i++)
            SimulationHypothesisCard(
              index: i,
              hypothesis: state.hypotheses[i],
              badge: state.badges.of(state.hypotheses[i].name, state.hypotheses[i].categoryKey),
            ),
        ], graphite ? 0 : AppSpacing.sm),
        SizedBox(height: graphite ? 0 : AppSpacing.sm),
        if (graphite && state.hasHypotheses) Container(height: 1, color: tokens.line),
        AppButton.dashed(context.tr(SimulationsLocale.addHypothesis), onTap: () => _addHypothesis(context)),
      ],
    );
  }
}
