import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/expenses_locale.dart';
import 'expenses_month_button.dart';

class ExpensesHeader extends StatelessWidget {
  const ExpensesHeader({super.key, required this.month, required this.isCurrentYear});

  final DateTime month;
  final bool isCurrentYear;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final style = tokens.isGraphite
        ? tokens.ts(15, FontWeight.w500)
        : tokens.ts(28, FontWeight.w800).copyWith(letterSpacing: -0.5);
    return Row(
      children: [
        Expanded(child: Text(context.tr(ExpensesLocale.title), style: style)),
        ExpensesMonthButton(month: month, isCurrentYear: isCurrentYear),
      ],
    );
  }
}
