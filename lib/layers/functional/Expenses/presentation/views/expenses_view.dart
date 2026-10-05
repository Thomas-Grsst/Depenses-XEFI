import 'package:depenses/layers/technical/Theme/app_page_list.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expenses_cubit.dart';
import '../cubit/expenses_state.dart';
import '../widgets/expenses_category_chips.dart';
import '../widgets/expenses_day_group.dart';
import '../widgets/expenses_empty_message.dart';
import '../widgets/expenses_header.dart';
import '../widgets/expenses_kind_tabs.dart';
import '../widgets/expenses_search_field.dart';
import '../widgets/expenses_total.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isGraphite = context.tokens.isGraphite;
    return BlocBuilder<ExpensesCubit, ExpensesState>(
      builder: (context, state) {
        final total = ExpensesTotal(
          total: state.visibleTotal,
          count: state.visibleExpenses.length,
          kind: state.query.kind,
        );
        final days = state.days;
        return AppPageList(
          gap: isGraphite ? 26 : null,
          children: [
            ExpensesHeader(month: state.month, isCurrentYear: state.isCurrentYear),
            if (isGraphite) total,
            const ExpensesSearchField(),
            ExpensesKindTabs(kind: state.query.kind),
            ExpensesCategoryChips(categories: state.categories, selectedKey: state.query.categoryKey),
            if (!isGraphite) total,
            if (days.isEmpty) ExpensesEmptyMessage(month: state.month, hasMonthExpenses: state.hasMonthExpenses),
            for (final day in days) ExpensesDayGroup(day: day, today: state.today),
          ],
        );
      },
    );
  }
}
