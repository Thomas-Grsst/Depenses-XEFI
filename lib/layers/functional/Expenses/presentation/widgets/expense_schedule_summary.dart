import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../cubit/expense_editor_state.dart';
import '../l10n/expenses_locale.dart';

class ExpenseScheduleSummary extends StatelessWidget {
  const ExpenseScheduleSummary({super.key, required this.state});

  final ExpenseEditorState state;

  String _rule(BuildContext context) {
    final date = state.date;
    final dates = context.dates;
    return switch (state.frequency) {
      Frequency.week => context.trWith(ExpensesLocale.ruleWeekly, [dates.weekday(date)]),
      Frequency.year => context.trWith(ExpensesLocale.ruleYearly, [dates.dayAndMonth(date)]),
      Frequency.month => context.trWith(ExpensesLocale.ruleMonthly, ['${date.day}']),
    };
  }

  String _next(BuildContext context) {
    final next = state.nextOccurrence;
    if (next == null) return context.tr(ExpensesLocale.noNextOccurrence);
    final short = context.dates.shortDate(next);
    return next.year != state.today.year ? '$short ${next.year}' : short;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final size = isGraphite ? 13.0 : 14.0;
    return Row(
      children: [
        Expanded(
          child: Text(_rule(context), style: tokens.ts(size, tokens.wSemi, isGraphite ? tokens.muted : tokens.ink)),
        ),
        Text(
          context.trWith(ExpensesLocale.nextOccurrence, [_next(context)]),
          style: tokens.ts(size, tokens.wSemi, isGraphite ? tokens.muted : tokens.mint),
        ),
      ],
    );
  }
}
