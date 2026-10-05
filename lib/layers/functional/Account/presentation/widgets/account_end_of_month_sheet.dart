import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';
import '../l10n/account_locale.dart';
import 'account_end_of_month_breakdown.dart';

class AccountEndOfMonthSheet extends StatelessWidget {
  const AccountEndOfMonthSheet({super.key, required this.onCorrect});

  final VoidCallback onCorrect;

  static Future<void> show(BuildContext context, {required DateTime month}) => AppSheet.show<void>(
    context,
    title: context.trWith(AccountLocale.endOfMonthTitle, [context.dates.monthName(month)]),
    closeLabel: context.tr(AccountLocale.close),
    builder: (sheetContext) => BlocProvider(
      create: (_) => GetIt.I<AccountCubit>(),
      child: AccountEndOfMonthSheet(
        onCorrect: () {
          Navigator.of(sheetContext).pop();
          openRoute<void>(context, AppRoute.account);
        },
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        final stats = state.stats;
        if (stats == null) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AccountEndOfMonthBreakdown(
              stats: stats,
              summary: state.summary,
              remainingRecurrences: state.remainingRecurrences,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton.secondary(context.tr(AccountLocale.correct), onTap: onCorrect),
          ],
        );
      },
    );
  }
}
