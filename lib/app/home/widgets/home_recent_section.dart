import 'package:depenses/layers/functional/Expenses/domain/entities/described_expense.dart';
import 'package:depenses/layers/functional/Expenses/presentation/widgets/expense_row.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_list_section.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shell/shell_tab.dart';
import '../../shell/shell_tab_cubit.dart';
import '../cubit/home_lists_cubit.dart';
import '../l10n/home_locale.dart';

const _metaSeparator = ' · ';

class HomeRecentSection extends StatelessWidget {
  const HomeRecentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeListsCubit>().state;
    final isGraphite = context.tokens.isGraphite;
    String metaOf(DescribedExpense item) => [
      context.dates.relativeDay(item.expense.date, today: state.today),
      item.category.name,
      if (!isGraphite && item.expense.labels.isNotEmpty) item.expense.labels.first,
    ].join(_metaSeparator);
    return AppListSection(
      title: context.tr(isGraphite ? HomeLocale.recentTitleShort : HomeLocale.recentTitle),
      action: context.tr(HomeLocale.seeAll),
      onAction: () => context.read<ShellTabCubit>().select(ShellTab.expenses),
      empty: context.tr(HomeLocale.recentEmpty),
      children: [for (final item in state.recent) ExpenseRow(item, meta: metaOf(item))],
    );
  }
}
