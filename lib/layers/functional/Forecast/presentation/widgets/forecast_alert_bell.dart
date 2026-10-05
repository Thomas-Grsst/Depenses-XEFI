import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/budget_alert.dart';
import '../l10n/forecast_locale.dart';
import 'forecast_alert_list.dart';

class ForecastAlertBell extends StatelessWidget {
  const ForecastAlertBell({super.key, required this.alerts, required this.categories, required this.areAlertsEnabled});

  final List<BudgetAlert> alerts;
  final Map<String, Category> categories;
  final bool areAlertsEnabled;

  Future<void> _showAlerts(BuildContext context) => AppSheet.show<void>(
    context,
    title: context.tr(ForecastLocale.alertsTitle),
    closeLabel: context.tr(ForecastLocale.close),
    builder: (_) => ForecastAlertList(alerts: alerts, categories: categories, areAlertsEnabled: areAlertsEnabled),
  );

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final dotSize = graphite ? 6.0 : 8.0;
    return AppPressable(
      onTap: () => _showAlerts(context),
      semanticsLabel: context.tr(ForecastLocale.alertsTitle),
      child: Container(
        width: 44,
        height: 44,
        alignment: graphite ? Alignment.centerRight : Alignment.center,
        decoration: graphite ? null : BoxDecoration(color: tokens.card, shape: BoxShape.circle),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AppIcon('bell', size: 20, color: tokens.ink),
            if (alerts.isNotEmpty)
              Positioned(
                top: -1,
                right: graphite ? -3 : -1,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(color: graphite ? tokens.accent : tokens.warn, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
