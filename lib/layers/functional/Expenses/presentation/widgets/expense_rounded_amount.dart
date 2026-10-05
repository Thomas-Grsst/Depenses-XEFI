import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/expenses_locale.dart';

class ExpenseRoundedAmount extends StatelessWidget {
  const ExpenseRoundedAmount({super.key, required this.amount, required this.roundUp});

  final double amount;
  final double roundUp;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(money.euros(amount), style: tokens.ts(15, tokens.isGraphite ? FontWeight.w400 : FontWeight.w700)),
          Text(
            context.trWith(ExpensesLocale.roundedUp, [money.euros(roundUp)]),
            style: tokens.ts(11, tokens.wSemi, tokens.mint),
          ),
        ],
      ),
    );
  }
}
