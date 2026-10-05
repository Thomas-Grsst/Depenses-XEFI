import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_confirm_dialog.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expense_editor_cubit.dart';
import '../cubit/expense_editor_target.dart';
import '../l10n/expenses_locale.dart';

class ExpenseDeleteButton extends StatelessWidget {
  const ExpenseDeleteButton({super.key, required this.target});

  final ExpenseEditorTarget target;

  Future<void> _confirmDelete(BuildContext context) async {
    final cubit = context.read<ExpenseEditorCubit>();
    final expense = target.expense;
    final isConfirmed = await AppConfirmDialog.show(
      context,
      title: context.tr(expense != null ? ExpensesLocale.deleteExpenseTitle : ExpensesLocale.deleteRecurrenceTitle),
      message: expense != null
          ? context.trWith(ExpensesLocale.deleteExpenseMessage, [expense.name])
          : context.tr(ExpensesLocale.deleteRecurrenceMessage),
      confirmLabel: context.tr(ExpensesLocale.delete),
      cancelLabel: context.tr(ExpensesLocale.cancel),
    );
    if (isConfirmed) await cubit.delete();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppPressable(
      onTap: () => _confirmDelete(context),
      semanticsLabel: context.tr(ExpensesLocale.delete),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Align(
          alignment: tokens.isGraphite ? Alignment.centerRight : Alignment.center,
          child: AppIcon('trash', size: 20, color: tokens.warn),
        ),
      ),
    );
  }
}
