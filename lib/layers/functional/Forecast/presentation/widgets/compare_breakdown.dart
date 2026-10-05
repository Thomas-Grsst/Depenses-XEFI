import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/month_comparison.dart';
import '../l10n/forecast_compare_locale.dart';
import 'compare_move_row.dart';

class CompareBreakdown extends StatelessWidget {
  const CompareBreakdown({super.key, required this.comparison, required this.categories});

  final MonthComparison comparison;
  final Map<String, Category> categories;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final rows = [
      for (final move in comparison.moves)
        if (categories[move.categoryKey] != null)
          CompareMoveRow(
            move: move,
            category: categories[move.categoryKey]!,
            referenceMonth: comparison.referenceMonth,
            largestDelta: comparison.largestDelta,
          ),
    ];
    if (tokens.isGraphite) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(context.tr(ForecastCompareLocale.whyItMoves).toUpperCase(), style: tokens.label()),
                ),
                Text(context.tr(ForecastCompareLocale.deltaInEurosShort), style: tokens.label()),
              ],
            ),
          ),
          for (final row in rows) AppRuled(child: row),
        ],
      );
    }
    return AppPanel(
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(context.tr(ForecastCompareLocale.whyItMoves), style: tokens.ts(15, FontWeight.w800)),
              ),
              Text(context.tr(ForecastCompareLocale.deltaInEuros), style: tokens.ts(12, FontWeight.w600, tokens.muted)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...rows,
        ],
      ),
    );
  }
}
