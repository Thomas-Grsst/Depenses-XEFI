import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_page_list.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/simulations_cubit.dart';
import '../cubit/simulations_state.dart';
import '../l10n/simulations_locale.dart';
import '../widgets/simulations_comparison_table.dart';
import '../widgets/simulations_empty_panel.dart';
import '../widgets/simulations_header.dart';
import '../widgets/simulations_scenario_list.dart';

class SimulationsView extends StatelessWidget {
  const SimulationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: tokens.bg,
      body: BlocBuilder<SimulationsCubit, SimulationsState>(
        builder: (context, state) {
          final comparison = state.comparison;
          return AppPageList(
            children: [
              const SimulationsHeader(),
              if (!state.hasScenarios)
                const SimulationsEmptyPanel()
              else ...[
                SimulationsScenarioList(scenarios: state.scenarios, pickedIds: state.pickedIds),
                if (comparison != null) AppPanel(radius: 22, child: SimulationsComparisonTable(comparison: comparison)),
                Text(
                  context.tr(SimulationsLocale.listFooter),
                  textAlign: TextAlign.center,
                  style: tokens
                      .ts(12, tokens.wSemi, tokens.isGraphite ? tokens.faint : tokens.muted)
                      .copyWith(height: 1.5),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
