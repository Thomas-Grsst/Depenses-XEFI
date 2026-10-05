import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../cubit/expenses_day.dart';
import 'expense_row.dart';
import 'expenses_day_title.dart';

class ExpensesDayGroup extends StatelessWidget {
  const ExpensesDayGroup({super.key, required this.day, required this.today});

  final ExpensesDay day;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final isGraphite = context.tokens.isGraphite;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xxs, bottom: 6),
          child: ExpensesDayTitle(day: day.day, today: today),
        ),
        AppPanel(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
          child: Column(
            children: [
              for (final item in day.items)
                AppRuled(
                  verticalPadding: isGraphite ? 13 : 20,
                  child: ExpenseRow(item, showsLabelChips: true, iconSize: 42),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
