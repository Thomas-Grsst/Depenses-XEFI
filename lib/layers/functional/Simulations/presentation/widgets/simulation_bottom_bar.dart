import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/simulation_cubit.dart';
import '../cubit/simulation_state.dart';
import '../l10n/simulations_labels.dart';
import '../l10n/simulations_locale.dart';
import '../views/simulations_page.dart';
import 'simulation_save_sheet.dart';

const _titleSeparator = ', ';

class SimulationBottomBar extends StatelessWidget {
  const SimulationBottomBar({super.key, required this.state});

  final SimulationState state;

  Future<void> _save(BuildContext context) async {
    final cubit = context.read<SimulationCubit>();
    final source = state.source;
    final summaries = [for (final h in state.hypotheses) context.hypothesisSummary(h)];
    final entry = await AppSheet.show<(String, String)>(
      context,
      title: context.tr(SimulationsLocale.saveTitle),
      closeLabel: context.tr(SimulationsLocale.close),
      builder: (_) => SimulationSaveSheet(
        initialTitle: source?.title ?? summaries.join(_titleSeparator),
        initialDescription: source?.description ?? '',
        tags: [
          ...summaries,
          context.trWith(SimulationsLocale.impactTag, [
            context.money.withSign(state.impact?.monthlyDelta ?? 0, context.money.euros),
          ]),
        ],
      ),
    );
    if (entry == null || !context.mounted) return;
    await cubit.save(
      title: entry.$1,
      description: entry.$2,
      fallbackTitle: context.trWith(SimulationsLocale.defaultTitle, [state.scenarioCount + 1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return Padding(
      padding: EdgeInsets.fromLTRB(tokens.pad, 12, tokens.pad, 16),
      child: Row(
        children: [
          Expanded(
            flex: graphite ? 1 : 5,
            child: AppButton.secondary(
              context.tr(SimulationsLocale.mySimulations),
              onTap: () =>
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute<void>(builder: (_) => const SimulationsPage())),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: graphite ? 1 : 7,
            child: AppButton.primary(
              context.tr(SimulationsLocale.save),
              icon: graphite ? null : 'save',
              onTap: state.hasHypotheses ? () => _save(context) : null,
            ),
          ),
        ],
      ),
    );
  }
}
