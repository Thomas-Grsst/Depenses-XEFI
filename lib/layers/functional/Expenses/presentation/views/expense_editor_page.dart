import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/expense.dart';
import '../cubit/expense_editor_cubit.dart';
import '../cubit/expense_editor_target.dart';
import 'expense_editor_view.dart';

class ExpenseEditorPage extends StatelessWidget {
  const ExpenseEditorPage({super.key, this.expense, this.recurrence, this.startsRecurring = false});

  final Expense? expense;
  final Recurrence? recurrence;
  final bool startsRecurring;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => GetIt.I<ExpenseEditorCubit>(
      param1: ExpenseEditorTarget(expense: expense, recurrence: recurrence, startsRecurring: startsRecurring),
    ),
    child: const ExpenseEditorView(),
  );
}
