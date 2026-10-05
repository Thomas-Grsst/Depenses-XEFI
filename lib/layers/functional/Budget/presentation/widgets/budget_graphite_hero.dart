import 'package:depenses/layers/functional/Forecast/domain/entities/month_stats.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/localization_locale.dart';
import 'package:depenses/layers/technical/Theme/app_big_amount.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/budget_locale.dart';
import 'budget_highlighted_text.dart';

class BudgetGraphiteHero extends StatelessWidget {
  const BudgetGraphiteHero({super.key, required this.stats, required this.margin});

  final MonthStats stats;
  final double margin;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    final currency = context.tr(LocalizationLocale.currencySymbol);
    final hasMargin = margin >= 0;
    final highlight = hasMargin
        ? context.trWith(BudgetLocale.marginOf, [money.wholeEuros(margin)])
        : context.trWith(BudgetLocale.overrunOf, [money.wholeEuros(-margin)]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr(BudgetLocale.envelopesLabel).toUpperCase(), style: tokens.label()),
        const SizedBox(height: 10),
        AppBigAmount(
          money.wholeNumber(stats.spent),
          currency: currency,
          size: 56,
          suffix: context.trWith(BudgetLocale.heroSuffix, [money.wholeNumber(stats.budget), currency]),
        ),
        const SizedBox(height: 10),
        BudgetHighlightedText(
          sentence: context.trWith(BudgetLocale.forecastWithMargin, [
            stats.daysInMonth,
            money.wholeEuros(stats.forecast),
            highlight,
          ]),
          highlight: highlight,
          highlightStyle: TextStyle(color: hasMargin ? tokens.mint : tokens.warn),
          style: tokens.ts(14, FontWeight.w400, tokens.muted),
        ),
      ],
    );
  }
}
