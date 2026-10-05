import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expense_editor_cubit.dart';
import '../cubit/expense_editor_state.dart';
import 'expense_amount_field.dart';
import 'expense_category_grid.dart';
import 'expense_editor_fields.dart';
import 'expense_editor_header.dart';
import 'expense_frequency_block.dart';
import 'expense_labels_block.dart';
import 'expense_look_preview.dart';
import 'expense_mode_switch.dart';

class ExpenseEditorForm extends StatelessWidget {
  const ExpenseEditorForm({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    return BlocBuilder<ExpenseEditorCubit, ExpenseEditorState>(
      builder: (context, state) {
        final look = state.look;
        return ListView(
          padding: EdgeInsets.fromLTRB(tokens.pad, 8, tokens.pad, 24),
          children: spaced([
            ExpenseEditorHeader(state: state),
            if (!state.isEditing) ExpenseModeSwitch(isRecurring: state.isRecurring),
            ExpenseAmountField(state: state),
            Column(
              children: [
                ExpenseEditorFields(state: state),
                if (state.isRecurring) ...[SizedBox(height: isGraphite ? 0 : 16), ExpenseFrequencyBlock(state: state)],
              ],
            ),
            if (look != null) ExpenseLookPreview(category: state.category, look: look),
            ExpenseCategoryGrid(state: state),
            ExpenseLabelsBlock(allLabels: state.allLabels, selectedLabels: state.labels),
          ], isGraphite ? 26 : 16),
        );
      },
    );
  }
}
