import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/scenario.dart';
import '../l10n/simulations_labels.dart';
import '../l10n/simulations_locale.dart';
import 'simulations_pick_check.dart';

const _worseThreshold = 0.004;
const _separator = ' · ';

class SimulationsScenarioLine extends StatelessWidget {
  const SimulationsScenarioLine({
    super.key,
    required this.position,
    required this.scenario,
    required this.isPicked,
    required this.onTap,
    required this.onLongPress,
  });

  final int position;
  final Scenario scenario;
  final bool isPicked;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final delta = scenario.monthlyDelta;
    final meta = context.trWith(SimulationsLocale.savedOn, [context.dates.shortDate(scenario.createdAt)]);
    final summaries = [for (final h in scenario.hypotheses) context.hypothesisSummary(h), meta].join(_separator);
    return AppRuled(
      verticalPadding: 16,
      child: AppPressable(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: SimulationsPickCheck(isPicked: isPicked),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          '${context.scenarioLetter(position)}$_separator${scenario.title}',
                          style: tokens.ts(15, FontWeight.w400),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        context.money.withSign(delta, context.money.euros),
                        style: tokens.ts(14, FontWeight.w400, delta > _worseThreshold ? tokens.warn : tokens.mint),
                      ),
                    ],
                  ),
                  if (scenario.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      scenario.description,
                      style: tokens.ts(13, FontWeight.w400, tokens.muted).copyWith(height: 1.45),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(summaries.toUpperCase(), style: tokens.mono(10, tokens.faint)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
