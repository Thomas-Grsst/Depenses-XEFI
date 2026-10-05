import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_big_amount.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/month_stats.dart';
import '../l10n/forecast_locale.dart';
import 'forecast_budget_link.dart';
import 'forecast_hero_budget.dart';
import 'forecast_hero_colors.dart';
import 'forecast_versus_badge.dart';

class ForecastSpentHero extends StatelessWidget {
  const ForecastSpentHero({super.key, required this.stats, required this.isAccountHero});

  final MonthStats stats;
  final bool isAccountHero;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = ForecastHeroColors(tokens, isAccountHero: isAccountHero);
    final versusPrevious = stats.versusPrevious;
    final previousMonth = DateTime(stats.today.year, stats.today.month - 1);
    return AppPressable(
      onTap: () => openRoute<void>(context, AppRoute.budget),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.trWith(ForecastLocale.spentInMonth, [context.dates.monthName(stats.month)]),
                    style: tokens.ts(14, FontWeight.w600, colors.muted),
                  ),
                ),
                if (versusPrevious != null)
                  ForecastVersusBadge(
                    versusPrevious: versusPrevious,
                    previousMonthName: context.dates.monthName(previousMonth),
                    isAccountHero: isAccountHero,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            AppBigAmount(
              context.money.decimals(stats.spent),
              currency: context.tr(LocalizationLocale.currencySymbol),
              size: isAccountHero ? 30 : 40,
              color: colors.ink,
            ),
            const SizedBox(height: AppSpacing.md),
            ForecastHeroBudget(stats: stats, isAccountHero: isAccountHero),
            const SizedBox(height: AppSpacing.md),
            ForecastBudgetLink(hasBudget: stats.budget > 0, isAccountHero: isAccountHero),
          ],
        ),
      ),
    );
  }
}
