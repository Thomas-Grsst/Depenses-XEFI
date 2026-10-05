import 'package:depenses/layers/functional/Forecast/domain/entities/month_stats.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_progress_bar.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/budget_locale.dart';
import 'budget_menthe_hero_footer.dart';

const _overBudgetHeroFill = Color(0xFFF5B47A);

class BudgetMentheHero extends StatelessWidget {
  const BudgetMentheHero({super.key, required this.stats, required this.margin});

  final MonthStats stats;
  final double margin;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(color: tokens.hero, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr(BudgetLocale.monthEnvelopes), style: tokens.ts(14, FontWeight.w600, tokens.heroMuted)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                money.wholeEuros(stats.spent),
                style: tokens.ts(34, FontWeight.w800, tokens.heroInk).copyWith(letterSpacing: -0.7),
              ),
              const SizedBox(width: 6),
              Text(
                context.trWith(BudgetLocale.outOf, [money.wholeEuros(stats.budget)]),
                style: tokens.ts(17, FontWeight.w700, tokens.heroMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppProgressBar(
            stats.spent / stats.budget,
            marker: stats.forecast / stats.budget,
            height: 10,
            fill: stats.spent > stats.budget ? _overBudgetHeroFill : tokens.heroAccent,
            track: tokens.heroInk.withValues(alpha: 0.14),
            markerColor: tokens.heroInk,
          ),
          const SizedBox(height: AppSpacing.sm),
          BudgetMentheHeroFooter(stats: stats, margin: margin),
        ],
      ),
    );
  }
}
