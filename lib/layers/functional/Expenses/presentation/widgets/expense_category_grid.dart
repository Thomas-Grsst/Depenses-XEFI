import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../cubit/expense_editor_state.dart';
import '../l10n/expenses_locale.dart';
import 'expense_category_tile.dart';
import 'expense_envelope_hint.dart';
import 'expense_new_category_tile.dart';

class ExpenseCategoryGrid extends StatelessWidget {
  const ExpenseCategoryGrid({super.key, required this.state});

  final ExpenseEditorState state;

  @override
  Widget build(BuildContext context) {
    final isGraphite = context.tokens.isGraphite;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionLabel(context.tr(ExpensesLocale.category)),
        SizedBox(height: isGraphite ? 14 : 10),
        GridView.count(
          crossAxisCount: isGraphite ? 5 : 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: isGraphite ? 12 : 8,
          crossAxisSpacing: isGraphite ? 4 : 8,
          childAspectRatio: isGraphite ? 0.85 : 1.45,
          padding: EdgeInsets.zero,
          children: [
            for (final category in state.categories)
              ExpenseCategoryTile(category: category, isSelected: category.key == state.categoryKey),
            const ExpenseNewCategoryTile(),
          ],
        ),
        ExpenseEnvelopeHint(category: state.category, stats: state.categoryStats),
      ],
    );
  }
}
