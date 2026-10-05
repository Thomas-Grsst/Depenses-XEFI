import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_callout.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/month_stats.dart';
import '../l10n/forecast_emphasis.dart';
import '../l10n/forecast_locale.dart';

class ForecastPaceTip extends StatelessWidget {
  const ForecastPaceTip({super.key, required this.stats});

  final MonthStats stats;

  bool get _hasBudget => stats.budget > 0;

  bool get _isOverBudget => _hasBudget && stats.forecast > stats.budget;

  String _key(bool graphite) {
    if (!_hasBudget) return graphite ? ForecastLocale.paceTipShort : ForecastLocale.paceTip;
    if (_isOverBudget) return graphite ? ForecastLocale.paceTipOverBudgetShort : ForecastLocale.paceTipOverBudget;
    return graphite ? ForecastLocale.paceTipUnderBudgetShort : ForecastLocale.paceTipUnderBudget;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final money = context.money;
    final parts = emphasisParts(
      context.trWith(_key(graphite), [
        money.wholeEuros(stats.forecast - stats.spent),
        '${stats.daysInMonth}',
        money.wholeEuros((stats.budget - stats.forecast).abs()),
      ]),
    );
    if (!graphite) {
      return _isOverBudget ? AppCallout.warning(parts: parts) : AppCallout.tip(parts: parts);
    }
    final lastEmphasis = parts.lastIndexWhere((part) => part.$2);
    final budgetTone = _isOverBudget ? tokens.warn : tokens.mint;
    return Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < parts.length; i++)
            TextSpan(
              text: parts[i].$1,
              style: parts[i].$2
                  ? TextStyle(
                      color: _hasBudget && i == lastEmphasis ? budgetTone : tokens.ink,
                      fontWeight: FontWeight.w400,
                    )
                  : null,
            ),
        ],
      ),
      style: tokens.ts(17, FontWeight.w300, tokens.body).copyWith(height: 1.5),
    );
  }
}
