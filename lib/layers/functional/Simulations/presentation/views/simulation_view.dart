import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/simulation_cubit.dart';
import '../cubit/simulation_state.dart';
import '../widgets/simulation_bottom_bar.dart';
import '../widgets/simulation_header.dart';
import '../widgets/simulation_hypotheses_section.dart';
import '../widgets/simulation_results_section.dart';

class SimulationView extends StatelessWidget {
  const SimulationView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return Scaffold(
      backgroundColor: tokens.bg,
      body: SafeArea(
        child: BlocBuilder<SimulationCubit, SimulationState>(
          builder: (context, state) {
            final impact = state.impact;
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(tokens.pad, graphite ? 14 : 12, tokens.pad, 24),
                    children: spaced([
                      const SimulationHeader(),
                      SimulationHypothesesSection(state: state),
                      if (impact != null) SimulationResultsSection(impact: impact),
                    ], graphite ? 28 : 14),
                  ),
                ),
                SimulationBottomBar(state: state),
              ],
            );
          },
        ),
      ),
    );
  }
}
