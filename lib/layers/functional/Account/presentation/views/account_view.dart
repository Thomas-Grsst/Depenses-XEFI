import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_back_header.dart';
import 'package:depenses/layers/technical/Theme/app_page_list.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';
import '../l10n/account_locale.dart';
import '../widgets/account_end_of_month_breakdown.dart';
import '../widgets/account_form.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tokens.bg,
      body: BlocConsumer<AccountCubit, AccountState>(
        listenWhen: (previous, current) => current.status == AccountStatus.saved && previous.status != current.status,
        listener: (context, state) => Navigator.of(context).maybePop(),
        builder: (context, state) {
          final stats = state.stats;
          if (!state.isLoaded || stats == null) return const SizedBox.shrink();
          final summary = state.summary;
          final money = context.money;
          return AppPageList(
            children: [
              AppBackHeader(context.tr(AccountLocale.title), backLabel: context.tr(AccountLocale.back)),
              AccountForm(
                incomeText: summary.income > 0 ? money.inputText(summary.income) : '',
                balanceText: summary.hasBalance ? money.inputText(summary.balance) : '',
                payDay: state.payDay,
              ),
              if (summary.hasBalance)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSectionLabel(
                      context.trWith(AccountLocale.endOfMonthTitle, [context.dates.monthName(stats.month)]),
                    ),
                    AccountEndOfMonthBreakdown(
                      stats: stats,
                      summary: summary,
                      remainingRecurrences: state.remainingRecurrences,
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
