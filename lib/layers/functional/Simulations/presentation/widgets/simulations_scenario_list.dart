import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/push_page.dart';
import 'package:depenses/layers/technical/Theme/app_confirm_dialog.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/scenario.dart';
import '../cubit/simulations_cubit.dart';
import '../l10n/simulations_locale.dart';
import '../views/simulation_page.dart';
import 'simulations_scenario_action.dart';
import 'simulations_scenario_card.dart';
import 'simulations_scenario_line.dart';
import 'simulations_scenario_options.dart';

const _cardGap = 14.0;

class SimulationsScenarioList extends StatelessWidget {
  const SimulationsScenarioList({super.key, required this.scenarios, required this.pickedIds});

  final List<Scenario> scenarios;
  final List<String> pickedIds;

  Future<void> _openOptions(BuildContext context, Scenario scenario) async {
    final cubit = context.read<SimulationsCubit>();
    final action = await AppSheet.show<SimulationsScenarioAction>(
      context,
      title: scenario.title,
      closeLabel: context.tr(SimulationsLocale.close),
      builder: (_) => const SimulationsScenarioOptions(),
    );
    if (!context.mounted) return;
    if (action == SimulationsScenarioAction.open) {
      await pushPage<void>(context, SimulationPage(scenario: scenario));
    } else if (action == SimulationsScenarioAction.delete) {
      final isConfirmed = await AppConfirmDialog.show(
        context,
        title: context.trWith(SimulationsLocale.deleteTitle, [scenario.title]),
        message: context.tr(SimulationsLocale.deleteMessage),
        confirmLabel: context.tr(SimulationsLocale.delete),
        cancelLabel: context.tr(SimulationsLocale.cancel),
      );
      if (isConfirmed) await cubit.delete(scenario.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final cubit = context.read<SimulationsCubit>();
    final items = [
      for (var position = 0; position < scenarios.length; position++)
        if (tokens.isGraphite)
          SimulationsScenarioLine(
            position: position,
            scenario: scenarios[position],
            isPicked: pickedIds.contains(scenarios[position].id),
            onTap: () => cubit.toggle(scenarios[position].id),
            onLongPress: () => _openOptions(context, scenarios[position]),
          )
        else
          SimulationsScenarioCard(
            position: position,
            scenario: scenarios[position],
            isPicked: pickedIds.contains(scenarios[position].id),
            onTap: () => cubit.toggle(scenarios[position].id),
            onLongPress: () => _openOptions(context, scenarios[position]),
          ),
    ];
    if (!tokens.isGraphite) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: spaced(items, _cardGap));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(context.tr(SimulationsLocale.pickTwo).toUpperCase(), style: tokens.label()),
        ),
        ...items,
      ],
    );
  }
}
