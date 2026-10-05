import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_back_header.dart';
import 'package:depenses/layers/technical/Theme/app_page_list.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/show_app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/savings_cubit.dart';
import '../cubit/savings_state.dart';
import '../l10n/savings_locale.dart';
import '../widgets/savings_goals_section.dart';
import '../widgets/savings_recent_round_ups.dart';
import '../widgets/savings_round_up_totals.dart';

class SavingsView extends StatelessWidget {
  const SavingsView({super.key});

  void _announceFunding(BuildContext context, SavingsState state) {
    final goal = state.fundedGoal;
    if (goal == null) return;
    final money = context.money;
    showAppToast(
      context,
      context.trWith(SavingsLocale.movedToast, [
        goal.name,
        money.wholeEuros(goal.saved),
        money.wholeEuros(goal.target),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tokens.bg,
      body: BlocConsumer<SavingsCubit, SavingsState>(
        listenWhen: (previous, current) => current.fundedGoal != previous.fundedGoal,
        listener: _announceFunding,
        builder: (context, state) {
          if (state.status == SavingsStatus.loading) return const SizedBox.shrink();
          return AppPageList(
            children: [
              AppBackHeader(context.tr(SavingsLocale.title), backLabel: context.tr(SavingsLocale.back)),
              SavingsRoundUpTotals(
                isRoundUpEnabled: state.isRoundUpEnabled,
                summary: state.summary,
                goals: state.goals,
              ),
              if (state.recentRounded.isNotEmpty)
                SavingsRecentRoundUps(expenses: state.recentRounded, looks: state.looks, categories: state.categories),
              const SavingsGoalsSection(),
            ],
          );
        },
      ),
    );
  }
}
