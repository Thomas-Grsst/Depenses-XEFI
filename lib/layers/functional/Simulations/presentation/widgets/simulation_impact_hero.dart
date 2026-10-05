import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/scenario_impact.dart';
import '../l10n/simulations_locale.dart';
import 'simulation_trend.dart';

const _mentheWorseOnDark = Color(0xFFF2A65A);
const _mentheWorseOnLight = Color(0xFFF5B47A);

class SimulationImpactHero extends StatelessWidget {
  const SimulationImpactHero({super.key, required this.impact});

  final ScenarioImpact impact;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final isWorse = SimulationTrend.of(impact.monthlyDelta) == SimulationTrend.worse;
    final color = isWorse
        ? (graphite ? tokens.warn : (tokens.isDark ? _mentheWorseOnDark : _mentheWorseOnLight))
        : (graphite ? (impact.isUnchanged ? tokens.ink : tokens.mint) : tokens.heroAccent);
    final amount = impact.isUnchanged
        ? context.money.wholeEuros(0)
        : context.money.withSign(impact.monthlyDelta, context.money.euros);
    final caption = impact.isUnchanged
        ? context.tr(SimulationsLocale.noChange)
        : context.trWith(SimulationsLocale.overOneYear, [
            context.money.withSign(impact.yearlyDelta, context.money.wholeEuros),
          ]);
    if (graphite) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr(SimulationsLocale.impactPerMonth).toUpperCase(), style: tokens.label()),
          const SizedBox(height: 10),
          Text(amount, style: tokens.ts(52, FontWeight.w300, color).copyWith(letterSpacing: -2, height: 1)),
          const SizedBox(height: 10),
          Text(caption, style: tokens.ts(14, FontWeight.w400, tokens.muted)),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: tokens.hero, borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr(SimulationsLocale.impactPerMonth), style: tokens.ts(13, FontWeight.w600, tokens.heroMuted)),
          const SizedBox(height: 4),
          Text(amount, style: tokens.ts(34, FontWeight.w800, color).copyWith(letterSpacing: -0.7)),
          Text(caption, style: tokens.ts(13, FontWeight.w600, tokens.heroMuted)),
        ],
      ),
    );
  }
}
