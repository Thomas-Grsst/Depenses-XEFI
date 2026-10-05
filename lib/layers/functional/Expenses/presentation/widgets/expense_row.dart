import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/push_page.dart';
import 'package:depenses/layers/technical/Theme/app_item_row.dart';
import 'package:depenses/layers/technical/Theme/app_mark_icon.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/described_expense.dart';
import '../views/expense_editor_page.dart';
import 'expense_badge.dart';
import 'expense_label_chips.dart';
import 'expense_rounded_amount.dart';

class ExpenseRow extends StatelessWidget {
  const ExpenseRow(this.item, {super.key, this.meta, this.iconSize = 40, this.showsLabelChips = false});

  final DescribedExpense item;
  final String? meta;
  final double iconSize;
  final bool showsLabelChips;

  @override
  Widget build(BuildContext context) {
    final isGraphite = context.tokens.isGraphite;
    final expense = item.expense;
    final hasChips = showsLabelChips && !isGraphite && expense.labels.isNotEmpty;
    final isRoundedUp = expense.roundUp > 0;
    return AppItemRow(
      leading: ExpenseBadge(category: item.category, look: item.look, size: isGraphite ? 38 : iconSize),
      title: expense.name,
      titleSuffix: expense.isRecurring ? const AppMarkIcon('repeat') : null,
      subtitle: meta ?? _subtitle(isGraphite),
      below: hasChips ? ExpenseLabelChips(labels: expense.labels) : null,
      trailing: isRoundedUp ? null : context.money.euros(expense.amount),
      trailingWidget: isRoundedUp ? ExpenseRoundedAmount(amount: expense.amount, roundUp: expense.roundUp) : null,
      onTap: () => pushPage<void>(context, ExpenseEditorPage(expense: expense)),
    );
  }

  String _subtitle(bool isGraphite) {
    final categoryName = item.category.name;
    if (showsLabelChips && !isGraphite) return categoryName;
    final labels = item.expense.labels;
    return [categoryName, if (labels.isNotEmpty) labels.join(', ')].join(' · ');
  }
}
