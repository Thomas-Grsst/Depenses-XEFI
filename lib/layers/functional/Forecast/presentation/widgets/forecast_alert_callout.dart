import 'package:depenses/layers/technical/Theme/app_callout.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/budget_alert.dart';
import 'forecast_alert_parts.dart';

class ForecastAlertCallout extends StatelessWidget {
  const ForecastAlertCallout({super.key, required this.alert, required this.categoryName});

  final BudgetAlert alert;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return AppCallout.warning(parts: forecastAlertParts(context, alert, categoryName));
  }
}
