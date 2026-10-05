import 'package:depenses/layers/functional/Forecast/domain/entities/month_stats.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/budget_locale.dart';

class BudgetMentheHeroFooter extends StatelessWidget {
  const BudgetMentheHeroFooter({super.key, required this.stats, required this.margin});

  final MonthStats stats;
  final double margin;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    final style = tokens.ts(13, FontWeight.w600, tokens.heroMuted);
    final marginLabel = margin >= 0
        ? context.trWith(BudgetLocale.marginShort, [money.wholeEuros(margin)])
        : context.trWith(BudgetLocale.overrunShort, [money.wholeEuros(-margin)]);
    return Row(
      children: [
        Text(context.trWith(BudgetLocale.usedPercent, [money.percent(stats.spent / stats.budget)]), style: style),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            context.trWith(BudgetLocale.forecastWithMarginShort, [
              stats.daysInMonth,
              money.wholeEuros(stats.forecast),
              marginLabel,
            ]),
            textAlign: TextAlign.right,
            style: style,
          ),
        ),
      ],
    );
  }
}
