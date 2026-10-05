import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';

import '../cubit/expense_editor_state.dart';
import '../l10n/expenses_locale.dart';
import 'expense_frequency_button.dart';
import 'expense_schedule_summary.dart';

class ExpenseFrequencyBlock extends StatelessWidget {
  const ExpenseFrequencyBlock({super.key, required this.state});

  final ExpenseEditorState state;

  static const _options = [
    (Frequency.week, ExpensesLocale.week),
    (Frequency.month, ExpensesLocale.month),
    (Frequency.year, ExpensesLocale.year),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final title = context.tr(ExpensesLocale.repetition);
    return AppPanel(
      child: Container(
        padding: isGraphite ? const EdgeInsets.symmetric(vertical: AppSpacing.lg) : EdgeInsets.zero,
        decoration: isGraphite
            ? BoxDecoration(
                border: Border(bottom: BorderSide(color: tokens.line)),
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(isGraphite ? title.toUpperCase() : title, style: tokens.label()),
            const SizedBox(height: 10),
            Row(
              children: spaced([
                for (final (frequency, labelKey) in _options)
                  Expanded(
                    child: ExpenseFrequencyButton(
                      frequency: frequency,
                      label: context.tr(labelKey),
                      isSelected: state.frequency == frequency,
                    ),
                  ),
              ], AppSpacing.sm),
            ),
            const SizedBox(height: 10),
            ExpenseScheduleSummary(state: state),
          ],
        ),
      ),
    );
  }
}
