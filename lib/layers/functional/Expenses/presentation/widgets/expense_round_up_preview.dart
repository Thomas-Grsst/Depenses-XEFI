import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/expenses_locale.dart';

class ExpenseRoundUpPreview extends StatelessWidget {
  const ExpenseRoundUpPreview({super.key, required this.amount, required this.roundUp});

  final double amount;
  final double roundUp;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final money = context.money;
    final text = context.trWith(ExpensesLocale.roundUpPreview, [
      money.wholeEuros(amount + roundUp),
      money.euros(roundUp),
    ]);
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isGraphite ? Colors.transparent : tokens.mintSoft,
        borderRadius: BorderRadius.circular(999),
        border: isGraphite ? Border.all(color: tokens.lineStrong) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon('piggy', size: 15, color: tokens.mint, stroke: 2),
          const SizedBox(width: 6),
          Text(text, style: tokens.ts(12, isGraphite ? FontWeight.w400 : FontWeight.w700, tokens.mint)),
        ],
      ),
    );
  }
}
