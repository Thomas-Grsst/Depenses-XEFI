import 'package:depenses/layers/technical/Theme/app_mark_icon.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/expense.dart';
import 'expense_imported_tag.dart';

class ExpenseRowMarks extends StatelessWidget {
  const ExpenseRowMarks({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (expense.isRecurring) const AppMarkIcon('repeat'),
        if (expense.isRecurring && expense.isImported) const SizedBox(width: 6),
        if (expense.isImported) const ExpenseImportedTag(),
      ],
    );
  }
}
