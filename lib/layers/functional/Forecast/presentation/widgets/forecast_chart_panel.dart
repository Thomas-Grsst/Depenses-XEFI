import 'package:depenses/layers/technical/Localization/capitalize.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_cumulative_chart.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/month_stats.dart';
import '../l10n/forecast_locale.dart';
import 'forecast_chart_data.dart';
import 'forecast_legend_item.dart';

class ForecastChartPanel extends StatelessWidget {
  const ForecastChartPanel({super.key, required this.stats});

  final MonthStats stats;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final previousMonth = DateTime(stats.today.year, stats.today.month - 1);
    return AppPanel(
      radius: 22,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCumulativeChart(
            data: stats.chartData,
            formatValue: context.money.wholeNumber,
            targetCaption: context.tr(ForecastLocale.chartBudgetCaption),
          ),
          SizedBox(height: graphite ? 14 : 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Wrap(
              spacing: graphite ? 18 : 14,
              runSpacing: 6,
              children: [
                ForecastLegendItem(
                  context.tr(ForecastLocale.legendActual),
                  graphite ? tokens.ink : tokens.mint,
                  isSolid: true,
                ),
                ForecastLegendItem(context.tr(ForecastLocale.legendEstimated), graphite ? tokens.muted : tokens.mint),
                if (stats.previousFull > 0)
                  ForecastLegendItem(capitalize(context.dates.monthName(previousMonth)), tokens.ghost, isSolid: true),
                if (stats.budget > 0 && !graphite)
                  ForecastLegendItem(context.tr(ForecastLocale.legendBudget), tokens.warn),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
