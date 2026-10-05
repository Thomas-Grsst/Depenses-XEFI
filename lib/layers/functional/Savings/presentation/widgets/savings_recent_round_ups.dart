import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:flutter/material.dart';

import '../l10n/savings_locale.dart';
import 'savings_rounded_expense_row.dart';

class SavingsRecentRoundUps extends StatelessWidget {
  const SavingsRecentRoundUps({super.key, required this.expenses, required this.looks, required this.categories});

  final List<Expense> expenses;
  final Map<String, MerchantLook> looks;
  final Map<String, Category> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionLabel(context.tr(SavingsLocale.recentTitle)),
        const SizedBox(height: AppSpacing.xs),
        for (final expense in expenses)
          if (looks[expense.id] != null && categories[expense.categoryKey] != null)
            SavingsRoundedExpenseRow(
              expense: expense,
              look: looks[expense.id]!,
              category: categories[expense.categoryKey]!,
            ),
      ],
    );
  }
}
