import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../cubit/expense_editor_state.dart';
import '../l10n/expenses_locale.dart';
import 'expense_amount_input.dart';
import 'expense_round_up_preview.dart';

class ExpenseAmountField extends StatelessWidget {
  const ExpenseAmountField({super.key, required this.state});

  final ExpenseEditorState state;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final amount = state.amount;
    return Column(
      children: [
        if (!tokens.isGraphite)
          Text(context.tr(ExpensesLocale.amount), style: tokens.ts(13, FontWeight.w600, tokens.muted)),
        ExpenseAmountInput(
          initialText: amount == null ? '' : context.money.inputText(amount),
          autofocus: !state.isEditing,
        ),
        if (amount != null && state.roundUpPreview > 0)
          ExpenseRoundUpPreview(amount: amount, roundUp: state.roundUpPreview),
      ],
    );
  }
}
