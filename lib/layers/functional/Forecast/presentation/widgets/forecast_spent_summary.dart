import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_big_amount.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/month_stats.dart';
import '../l10n/forecast_locale.dart';

class ForecastSpentSummary extends StatelessWidget {
  const ForecastSpentSummary({super.key, required this.stats, required this.isAccountHero});

  final MonthStats stats;
  final bool isAccountHero;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final versusPrevious = stats.versusPrevious;
    final previousMonth = DateTime(stats.today.year, stats.today.month - 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.trWith(ForecastLocale.spentInMonth, [context.dates.monthName(stats.month)]).toUpperCase(),
          style: tokens.label(),
        ),
        const SizedBox(height: 10),
        AppBigAmount(
          context.money.decimals(stats.spent),
          currency: context.tr(LocalizationLocale.currencySymbol),
          size: isAccountHero ? 40 : 68,
        ),
        if (versusPrevious != null) ...[
          const SizedBox(height: 10),
          AppPressable(
            onTap: () => openRoute<void>(context, AppRoute.compare),
            child: Text(
              context.trWith(
                versusPrevious <= 0 ? ForecastLocale.versusPreviousDown : ForecastLocale.versusPreviousUp,
                [context.money.percent(versusPrevious.abs()), context.dates.monthName(previousMonth)],
              ),
              style: tokens.ts(14, FontWeight.w400, versusPrevious <= 0 ? tokens.mint : tokens.warn),
            ),
          ),
        ],
      ],
    );
  }
}
