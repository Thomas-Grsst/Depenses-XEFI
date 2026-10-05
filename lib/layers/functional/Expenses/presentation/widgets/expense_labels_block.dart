import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_pill_chip.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expense_editor_cubit.dart';
import '../l10n/expenses_locale.dart';
import 'expense_label_sheet.dart';

class ExpenseLabelsBlock extends StatelessWidget {
  const ExpenseLabelsBlock({super.key, required this.allLabels, required this.selectedLabels});

  final List<String> allLabels;
  final List<String> selectedLabels;

  Future<void> _addLabel(BuildContext context) async {
    final cubit = context.read<ExpenseEditorCubit>();
    final label = await AppSheet.show<String>(
      context,
      title: context.tr(ExpensesLocale.newLabel),
      closeLabel: context.tr(ExpensesLocale.close),
      builder: (_) => const ExpenseLabelSheet(),
    );
    if (label != null) await cubit.addLabel(label);
  }

  @override
  Widget build(BuildContext context) {
    final isGraphite = context.tokens.isGraphite;
    final cubit = context.read<ExpenseEditorCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionLabel(context.tr(ExpensesLocale.labels)),
        SizedBox(height: isGraphite ? 14 : 10),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final label in allLabels)
              AppPillChip(label, selected: selectedLabels.contains(label), onTap: () => cubit.toggleLabel(label)),
            AppPillChip.dashed(
              context.tr(isGraphite ? ExpensesLocale.addLabelShort : ExpensesLocale.addLabelLong),
              onTap: () => _addLabel(context),
            ),
          ],
        ),
      ],
    );
  }
}
