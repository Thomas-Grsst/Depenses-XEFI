import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/budget_alert.dart';
import '../l10n/forecast_emphasis.dart';
import '../l10n/forecast_locale.dart';

List<(String, bool)> forecastAlertParts(BuildContext context, BudgetAlert alert, String categoryName) {
  final money = context.money;
  final sentence = switch (alert.kind) {
    BudgetAlertKind.overspent => context.trWith(ForecastLocale.alertOverspent, [
      categoryName,
      money.autoEuros(alert.spent),
      money.autoEuros(alert.budget),
    ]),
    BudgetAlertKind.fastPace => context.trWith(ForecastLocale.alertFastPace, [
      money.percent(alert.ratio),
      categoryName,
      '${alert.day}',
    ]),
    BudgetAlertKind.projectedOverrun => context.trWith(ForecastLocale.alertProjectedOverrun, [
      categoryName,
      money.wholeEuros(alert.overrun),
    ]),
    BudgetAlertKind.totalOverrun => context.trWith(ForecastLocale.alertTotalOverrun, [money.wholeEuros(alert.overrun)]),
  };
  return emphasisParts(sentence);
}
