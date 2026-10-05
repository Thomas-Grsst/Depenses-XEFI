import 'package:depenses/layers/technical/Localization/capitalize.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Theme/app_big_amount.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/month_comparison.dart';
import '../l10n/forecast_compare_locale.dart';

class CompareGraphiteHero extends StatelessWidget {
  const CompareGraphiteHero({super.key, required this.comparison});

  final MonthComparison comparison;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    final ratio = comparison.ratio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.dates.monthName(comparison.today).toUpperCase(), style: tokens.label()),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              child: AppBigAmount(
                money.decimals(comparison.currentTotal),
                currency: context.tr(LocalizationLocale.currencySymbol),
                size: 60,
              ),
            ),
            if (ratio != null) ...[
              const SizedBox(width: 14),
              Text(
                context.trWith(ratio <= 0 ? ForecastCompareLocale.ratioDown : ForecastCompareLocale.ratioUp, [
                  money.percent(ratio.abs()),
                ]),
                style: tokens.ts(18, FontWeight.w400, ratio <= 0 ? tokens.mint : tokens.warn),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Text(
          context.trWith(
            comparison.isToDate ? ForecastCompareLocale.referenceToDate : ForecastCompareLocale.referenceWholeMonth,
            [
              capitalize(context.dates.monthName(comparison.referenceMonth)),
              money.euros(comparison.referenceTotal),
              money.withSign(comparison.difference, money.euros),
            ],
          ),
          style: tokens.ts(14, FontWeight.w400, tokens.muted),
        ),
      ],
    );
  }
}
