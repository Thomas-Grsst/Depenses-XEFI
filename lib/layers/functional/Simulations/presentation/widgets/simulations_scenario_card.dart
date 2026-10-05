import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/scenario.dart';
import '../cubit/simulations_cubit.dart';
import '../l10n/simulations_labels.dart';
import '../l10n/simulations_locale.dart';
import 'simulations_badge.dart';
import 'simulations_pick_check.dart';
import 'simulations_tag.dart';

const _worseThreshold = 0.004;
const _separator = ' · ';

class SimulationsScenarioCard extends StatelessWidget {
  const SimulationsScenarioCard({
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
    final isWorse = delta > _worseThreshold;
    final badge = context.select((SimulationsCubit cubit) => cubit.state.badges.leadOf(scenario));
    final impact = context.trWith(SimulationsLocale.amountPerMonth, [
      context.money.withSign(delta, context.money.euros),
    ]);
    return AppPressable(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 14, AppSpacing.lg, 14),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isPicked ? tokens.ink : Colors.transparent, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SimulationsBadge(badge: badge),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${context.scenarioLetter(position)}$_separator${scenario.title}',
                        style: tokens.ts(15, FontWeight.w800),
                      ),
                      Text(
                        context.trWith(SimulationsLocale.savedOn, [context.dates.shortDate(scenario.createdAt)]),
                        style: tokens.ts(12, FontWeight.w600, tokens.muted),
                      ),
                    ],
                  ),
                ),
                SimulationsPickCheck(isPicked: isPicked),
              ],
            ),
            if (scenario.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(scenario.description, style: tokens.ts(13, FontWeight.w500, tokens.muted).copyWith(height: 1.45)),
            ],
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final h in scenario.hypotheses) SimulationsTag(context.hypothesisSummary(h)),
                SimulationsTag(
                  impact,
                  weight: FontWeight.w800,
                  color: isWorse ? tokens.warn : tokens.mint,
                  background: isWorse ? tokens.warnSoft : tokens.mintSoft,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
