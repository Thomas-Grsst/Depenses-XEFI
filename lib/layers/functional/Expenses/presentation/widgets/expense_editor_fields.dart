import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expense_editor_cubit.dart';
import '../cubit/expense_editor_state.dart';
import '../l10n/expenses_locale.dart';
import 'expense_field_row.dart';
import 'expense_name_input.dart';

class ExpenseEditorFields extends StatelessWidget {
  const ExpenseEditorFields({super.key, required this.state});

  final ExpenseEditorState state;

  Future<void> _pickDate(BuildContext context) async {
    final cubit = context.read<ExpenseEditorCubit>();
    final picked = await showDatePicker(
      context: context,
      initialDate: state.date,
      firstDate: DateTime(2000),
      lastDate: DateTime(state.today.year + 5),
      helpText: context.tr(state.isRecurring ? ExpensesLocale.firstDueDate : ExpensesLocale.expenseDate),
    );
    if (picked != null) cubit.changeDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final valueStyle = tokens.ts(16, isGraphite ? FontWeight.w400 : FontWeight.w700);
    return AppPanel(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: Column(
        children: [
          ExpenseFieldRow(
            label: context.tr(ExpensesLocale.name),
            child: ExpenseNameInput(initialText: state.name),
          ),
          ExpenseFieldRow(
            label: context.tr(state.isRecurring ? ExpensesLocale.start : ExpensesLocale.date),
            onTap: () => _pickDate(context),
            isLast: !isGraphite || !state.isRecurring,
            child: Row(
              children: [
                Expanded(
                  child: Text(context.dates.longDate(state.date, today: state.today), style: valueStyle),
                ),
                AppIcon('calendar', size: 18, color: tokens.muted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
