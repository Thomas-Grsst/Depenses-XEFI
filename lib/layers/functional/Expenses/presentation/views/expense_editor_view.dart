import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/show_app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense_entry_outcome.dart';
import '../cubit/expense_editor_cubit.dart';
import '../cubit/expense_editor_state.dart';
import '../cubit/expense_editor_status.dart';
import '../l10n/expenses_locale.dart';
import '../widgets/expense_editor_form.dart';
import '../widgets/expense_editor_save_bar.dart';

class ExpenseEditorView extends StatelessWidget {
  const ExpenseEditorView({super.key});

  static String _messageKey(ExpenseEntryOutcome outcome) => switch (outcome) {
    ExpenseEntryOutcome.expenseCreated => ExpensesLocale.expenseCreated,
    ExpenseEntryOutcome.expenseUpdated => ExpensesLocale.expenseUpdated,
    ExpenseEntryOutcome.recurrenceCreated => ExpensesLocale.recurrenceCreated,
    ExpenseEntryOutcome.recurrenceUpdated => ExpensesLocale.recurrenceUpdated,
  };

  void _onFinished(BuildContext context, ExpenseEditorState state) {
    Navigator.pop(context);
    final outcome = state.outcome;
    if (state.status == ExpenseEditorStatus.saved && outcome != null) {
      showAppToast(context, context.tr(_messageKey(outcome)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseEditorCubit, ExpenseEditorState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == ExpenseEditorStatus.saved || current.status == ExpenseEditorStatus.deleted),
      listener: _onFinished,
      child: Scaffold(
        backgroundColor: context.tokens.bg,
        body: const SafeArea(
          child: Column(
            children: [
              Expanded(child: ExpenseEditorForm()),
              ExpenseEditorSaveBar(),
            ],
          ),
        ),
      ),
    );
  }
}
