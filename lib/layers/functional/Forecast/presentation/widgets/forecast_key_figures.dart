import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_key_figure.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/app_two_up.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/month_stats.dart';
import '../l10n/forecast_locale.dart';

class ForecastKeyFigures extends StatelessWidget {
  const ForecastKeyFigures({super.key, required this.stats});

  final MonthStats stats;

  @override
  Widget build(BuildContext context) {
    final graphite = context.tokens.isGraphite;
    final money = context.money;
    return AppTwoUp(
      AppKeyFigure(
        context.trWith(graphite ? ForecastLocale.spentOnDayShort : ForecastLocale.spentOnDay, ['${stats.day}']),
        amount: money.wholeNumber(stats.spent),
        amountWithCurrency: money.wholeEuros(stats.spent),
      ),
      AppKeyFigure.hero(
        context.trWith(graphite ? ForecastLocale.forecastOnDayShort : ForecastLocale.forecastOnDay, [
          '${stats.daysInMonth}',
        ]),
        amount: money.wholeNumber(stats.forecast),
        amountWithCurrency: money.wholeEuros(stats.forecast),
      ),
    );
  }
}
