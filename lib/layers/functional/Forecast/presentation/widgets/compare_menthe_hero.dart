import 'package:depenses/layers/technical/Localization/capitalize.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Theme/app_big_amount.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/month_comparison.dart';
import '../l10n/forecast_compare_locale.dart';

const _heroWarmTone = Color(0xFFF5B47A);

class CompareMentheHero extends StatelessWidget {
  const CompareMentheHero({super.key, required this.comparison});

  final MonthComparison comparison;

  String _referenceKey() {
    final isLess = comparison.difference <= 0;
    if (comparison.isToDate) {
      return isLess ? ForecastCompareLocale.referenceToDateLess : ForecastCompareLocale.referenceToDateMore;
    }
    return isLess ? ForecastCompareLocale.referenceWholeMonthLess : ForecastCompareLocale.referenceWholeMonthMore;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    final ratio = comparison.ratio;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(color: tokens.hero, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr(ForecastCompareLocale.thisMonth), style: tokens.ts(14, FontWeight.w600, tokens.heroMuted)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: AppBigAmount(
                  money.decimals(comparison.currentTotal),
                  currency: context.tr(LocalizationLocale.currencySymbol),
                  size: 36,
                  color: tokens.heroInk,
                ),
              ),
              if (ratio != null) ...[
                const SizedBox(width: 10),
                Text(
                  money.signedPercent(ratio),
                  style: tokens.ts(15, FontWeight.w800, ratio <= 0 ? tokens.heroAccent : _heroWarmTone),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            context.trWith(_referenceKey(), [
              capitalize(context.dates.monthName(comparison.referenceMonth)),
              money.euros(comparison.referenceTotal),
              money.euros(comparison.difference.abs()),
            ]),
            style: tokens.ts(13, FontWeight.w600, tokens.heroMuted),
          ),
        ],
      ),
    );
  }
}
