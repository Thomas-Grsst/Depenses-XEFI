import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_segmented.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expense_editor_cubit.dart';
import '../l10n/expenses_locale.dart';

class ExpenseModeSwitch extends StatelessWidget {
  const ExpenseModeSwitch({super.key, required this.isRecurring});

  final bool isRecurring;

  @override
  Widget build(BuildContext context) => AppSegmented<bool>(
    options: [(false, context.tr(ExpensesLocale.modeOccasional)), (true, context.tr(ExpensesLocale.modeRecurring))],
    value: isRecurring,
    center: true,
    onChanged: context.read<ExpenseEditorCubit>().selectRecurring,
  );
}
