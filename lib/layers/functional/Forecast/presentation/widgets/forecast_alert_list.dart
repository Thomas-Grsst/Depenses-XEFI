import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_empty_row.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/budget_alert.dart';
import '../l10n/forecast_locale.dart';
import 'forecast_alert_callout.dart';

class ForecastAlertList extends StatelessWidget {
  const ForecastAlertList({super.key, required this.alerts, required this.categories, required this.areAlertsEnabled});

  final List<BudgetAlert> alerts;
  final Map<String, Category> categories;
  final bool areAlertsEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: alerts.isEmpty
          ? [AppEmptyRow(context.tr(areAlertsEnabled ? ForecastLocale.alertsNone : ForecastLocale.alertsDisabled))]
          : spaced([
              for (final alert in alerts)
                ForecastAlertCallout(alert: alert, categoryName: categories[alert.categoryKey]?.name ?? ''),
            ], 10),
    );
  }
}
