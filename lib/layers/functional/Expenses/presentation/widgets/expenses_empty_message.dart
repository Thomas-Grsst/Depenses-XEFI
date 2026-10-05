import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/expenses_locale.dart';

class ExpensesEmptyMessage extends StatelessWidget {
  const ExpensesEmptyMessage({super.key, required this.month, required this.hasMonthExpenses});

  final DateTime month;
  final bool hasMonthExpenses;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = hasMonthExpenses
        ? context.tr(ExpensesLocale.emptyFilters)
        : context.trWith(ExpensesLocale.emptyMonth, [context.dates.monthName(month)]);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxl),
      child: Text(text, textAlign: TextAlign.center, style: tokens.ts(14, tokens.wBody, tokens.muted)),
    );
  }
}
