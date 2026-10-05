import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_round_button.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../cubit/expense_editor_state.dart';
import '../l10n/expenses_locale.dart';
import 'expense_delete_button.dart';

class ExpenseEditorHeader extends StatelessWidget {
  const ExpenseEditorHeader({super.key, required this.state});

  final ExpenseEditorState state;

  String get _titleKey {
    if (state.target.expense != null) return ExpensesLocale.editExpenseTitle;
    if (state.target.recurrence != null) return ExpensesLocale.recurrenceTitle;
    return ExpensesLocale.newExpenseTitle;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    return Row(
      children: [
        AppRoundButton('close', semanticsLabel: context.tr(ExpensesLocale.close), onTap: () => Navigator.pop(context)),
        Expanded(
          child: Text(
            context.tr(_titleKey),
            textAlign: TextAlign.center,
            style: tokens.ts(isGraphite ? 15 : 16, isGraphite ? FontWeight.w500 : FontWeight.w800),
          ),
        ),
        if (state.isEditing) ExpenseDeleteButton(target: state.target) else const SizedBox(width: 44),
      ],
    );
  }
}
