import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_callout.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/category_move.dart';
import '../../domain/entities/month_comparison.dart';
import '../l10n/forecast_compare_locale.dart';
import '../l10n/forecast_emphasis.dart';

class CompareInsight extends StatelessWidget {
  const CompareInsight({super.key, required this.comparison, required this.categories});

  final MonthComparison comparison;
  final Map<String, Category> categories;

  String _key(bool graphite, CategoryMove? drop, CategoryMove? rise) {
    if (drop != null && rise != null) {
      return graphite ? ForecastCompareLocale.insightDropAndRiseShort : ForecastCompareLocale.insightDropAndRise;
    }
    if (drop != null) return graphite ? ForecastCompareLocale.insightDropShort : ForecastCompareLocale.insightDrop;
    return graphite ? ForecastCompareLocale.insightRiseShort : ForecastCompareLocale.insightRise;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final money = context.money;
    final drop = comparison.biggestDrop;
    final rise = comparison.biggestRise;
    final parts = emphasisParts(
      context.trWith(_key(graphite, drop, rise), [
        for (final move in [?drop, ?rise]) ...[
          categories[move.categoryKey]?.name ?? '',
          money.withSign(move.delta, money.wholeEuros),
        ],
      ]),
    );
    if (!graphite) return AppCallout.tip(parts: parts);
    final firstEmphasis = parts.indexWhere((part) => part.$2);
    return Container(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: tokens.line)),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            for (var i = 0; i < parts.length; i++)
              TextSpan(
                text: parts[i].$1,
                style: parts[i].$2
                    ? TextStyle(color: drop != null && i == firstEmphasis ? tokens.mint : tokens.warn)
                    : null,
              ),
          ],
        ),
        style: tokens.ts(16, FontWeight.w300, tokens.body).copyWith(height: 1.5),
      ),
    );
  }
}
