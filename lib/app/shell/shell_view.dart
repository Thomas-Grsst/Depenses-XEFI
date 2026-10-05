import 'package:depenses/layers/functional/Expenses/presentation/views/expenses_tab.dart';
import 'package:depenses/layers/functional/Profile/presentation/views/profile_view.dart';
import 'package:depenses/layers/functional/Recurrences/presentation/views/recurrences_page.dart';
import 'package:depenses/layers/functional/Savings/presentation/widgets/savings_goals_section.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../home/home_page.dart';
import 'shell_nav_bar.dart';
import 'shell_tab.dart';
import 'shell_tab_cubit.dart';

class ShellView extends StatelessWidget {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => GetIt.I<ShellTabCubit>(),
    child: BlocBuilder<ShellTabCubit, ShellTab>(
      builder: (context, tab) => PopScope(
        canPop: tab == ShellTab.home,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) context.read<ShellTabCubit>().select(ShellTab.home);
        },
        child: Scaffold(
          backgroundColor: context.tokens.bg,
          body: IndexedStack(
            index: tab.index,
            children: const [
              HomePage(),
              ExpensesTab(),
              RecurrencesPage(),
              ProfileView(goalsSection: SavingsGoalsSection()),
            ],
          ),
          bottomNavigationBar: ShellNavBar(selected: tab),
        ),
      ),
    ),
  );
}
