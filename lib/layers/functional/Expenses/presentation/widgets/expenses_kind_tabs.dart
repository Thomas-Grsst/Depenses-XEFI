import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_segmented.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense_kind_filter.dart';
import '../cubit/expenses_cubit.dart';
import '../l10n/expenses_locale.dart';

class ExpensesKindTabs extends StatelessWidget {
  const ExpensesKindTabs({super.key, required this.kind});

  final ExpenseKindFilter kind;

  @override
  Widget build(BuildContext context) => AppSegmented<ExpenseKindFilter>(
    options: [
      (ExpenseKindFilter.all, context.tr(ExpensesLocale.filterAll)),
      (ExpenseKindFilter.recurring, context.tr(ExpensesLocale.filterRecurring)),
      (ExpenseKindFilter.occasional, context.tr(ExpensesLocale.filterOccasional)),
    ],
    value: kind,
    onChanged: context.read<ExpensesCubit>().selectKind,
  );
}
