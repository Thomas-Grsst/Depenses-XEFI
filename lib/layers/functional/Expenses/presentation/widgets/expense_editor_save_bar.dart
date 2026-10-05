import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expense_editor_cubit.dart';
import '../cubit/expense_editor_state.dart';
import '../l10n/expenses_locale.dart';

class ExpenseEditorSaveBar extends StatelessWidget {
  const ExpenseEditorSaveBar({super.key});

  static String _labelKey(ExpenseEditorState state) {
    if (state.isEditing) return ExpensesLocale.saveChanges;
    return state.isRecurring ? ExpensesLocale.createRecurrence : ExpensesLocale.save;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return BlocBuilder<ExpenseEditorCubit, ExpenseEditorState>(
      builder: (context, state) => Container(
        color: tokens.bg,
        padding: EdgeInsets.fromLTRB(tokens.pad, AppSpacing.md, tokens.pad, AppSpacing.lg),
        child: AppButton.primary(
          context.tr(_labelKey(state)),
          onTap: state.canSave ? context.read<ExpenseEditorCubit>().save : null,
        ),
      ),
    );
  }
}
