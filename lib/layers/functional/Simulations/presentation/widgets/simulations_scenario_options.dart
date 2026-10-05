import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/simulations_locale.dart';
import 'simulations_scenario_action.dart';

class SimulationsScenarioOptions extends StatelessWidget {
  const SimulationsScenarioOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(
          context.tr(SimulationsLocale.openInSandbox),
          onTap: () => Navigator.pop(context, SimulationsScenarioAction.open),
        ),
        const SizedBox(height: 10),
        AppButton.secondary(
          context.tr(SimulationsLocale.delete),
          color: context.tokens.warn,
          onTap: () => Navigator.pop(context, SimulationsScenarioAction.delete),
        ),
      ],
    );
  }
}
