import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_sparkline.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/month_stats.dart';
import '../l10n/forecast_locale.dart';
import 'forecast_chart_data.dart';

class ForecastSparklineCard extends StatelessWidget {
  const ForecastSparklineCard({super.key, required this.stats});

  final MonthStats stats;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    void openForecast() => openRoute<void>(context, AppRoute.forecast);
    if (tokens.isGraphite) {
      return AppPressable(
        onTap: openForecast,
        child: AppSparkline(data: stats.chartData, height: 90),
      );
    }
    final money = context.money;
    final mutedStyle = tokens.ts(13, FontWeight.w600, tokens.muted);
    return AppPressable(
      onTap: openForecast,
      child: AppPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tr(ForecastLocale.plannedThisMonth), style: mutedStyle),
            const SizedBox(height: 6),
            Text(money.wholeEuros(stats.forecast), style: tokens.ts(22, FontWeight.w800)),
            const SizedBox(height: 6),
            AppSparkline(data: stats.chartData),
            const SizedBox(height: 6),
            Text(
              context.trWith(ForecastLocale.stillToCome, [money.wholeEuros(stats.forecast - stats.spent)]),
              style: tokens.ts(12, FontWeight.w600, tokens.muted),
            ),
          ],
        ),
      ),
    );
  }
}
