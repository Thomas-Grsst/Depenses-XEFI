import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_progress_bar.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/month_stats.dart';
import '../l10n/forecast_locale.dart';
import 'forecast_hero_colors.dart';

class ForecastHeroBudget extends StatelessWidget {
  const ForecastHeroBudget({super.key, required this.stats, required this.isAccountHero});

  final MonthStats stats;
  final bool isAccountHero;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = ForecastHeroColors(tokens, isAccountHero: isAccountHero);
    final money = context.money;
    final style = tokens.ts(13, FontWeight.w600, colors.muted);
    if (stats.budget <= 0) {
      return Text(context.tr(ForecastLocale.noBudgetHint), style: style.copyWith(height: 1.4));
    }
    final isOver = stats.spent > stats.budget;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppProgressBar(stats.spent / stats.budget, fill: isOver ? colors.rising : colors.accent, track: colors.track),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                context.trWith(ForecastLocale.budgetShare, [
                  money.percent(stats.spent / stats.budget),
                  money.wholeEuros(stats.budget),
                ]),
                style: style,
              ),
            ),
            Text(
              isOver
                  ? context.trWith(ForecastLocale.budgetExceeded, [money.euros(stats.spent - stats.budget)])
                  : context.trWith(ForecastLocale.budgetLeft, [money.euros(stats.budget - stats.spent)]),
              style: style,
            ),
          ],
        ),
      ],
    );
  }
}
