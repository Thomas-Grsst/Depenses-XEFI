import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_progress_bar.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/month_stats.dart';
import '../l10n/forecast_locale.dart';
import 'forecast_budget_link.dart';

class ForecastBudgetMeter extends StatelessWidget {
  const ForecastBudgetMeter({super.key, required this.stats, required this.isAccountHero});

  final MonthStats stats;
  final bool isAccountHero;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    final style = tokens.mono(11, tokens.muted);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (stats.budget > 0)
          AppPressable(
            onTap: () => openRoute<void>(context, AppRoute.budget),
            child: Column(
              children: [
                AppProgressBar(stats.spent / stats.budget, marker: stats.forecast / stats.budget, dot: true),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.trWith(ForecastLocale.budgetMeterSpent, [
                          money.percent(stats.spent / stats.budget),
                          money.wholeNumber(stats.budget),
                        ]),
                        style: style,
                      ),
                    ),
                    Text(
                      context.trWith(ForecastLocale.budgetMeterForecast, [money.wholeNumber(stats.forecast)]),
                      style: style,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ForecastBudgetLink(hasBudget: stats.budget > 0, isAccountHero: isAccountHero),
      ],
    );
  }
}
