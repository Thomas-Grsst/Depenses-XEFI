import 'package:depenses/layers/functional/Forecast/domain/entities/month_stats.dart';
import 'package:depenses/layers/functional/Forecast/domain/entities/recurrence_tally.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/account_summary.dart';
import '../l10n/account_locale.dart';
import 'account_end_of_month_line.dart';

class AccountEndOfMonthBreakdown extends StatelessWidget {
  const AccountEndOfMonthBreakdown({
    super.key,
    required this.stats,
    required this.summary,
    required this.remainingRecurrences,
  });

  final MonthStats stats;
  final AccountSummary summary;
  final List<RecurrenceTally> remainingRecurrences;

  String _recurrenceNames(BuildContext context) {
    if (remainingRecurrences.isEmpty) return context.tr(AccountLocale.noRecurrenceLeft);
    return remainingRecurrences
        .map((t) => t.isRepeated ? context.trWith(AccountLocale.recurrenceTimes, [t.name, '${t.count}']) : t.name)
        .join(context.tr(AccountLocale.namesSeparator));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AccountEndOfMonthLine(context.tr(AccountLocale.onAccountToday), amount: summary.balance, isTotal: true),
        for (final payDate in summary.payDatesLeftThisMonth)
          AccountEndOfMonthLine(
            context.tr(AccountLocale.salary),
            subtitle: context.dates.longDate(payDate, today: stats.today),
            amount: summary.income,
          ),
        AccountEndOfMonthLine(
          context.tr(AccountLocale.upcomingRecurring),
          subtitle: _recurrenceNames(context),
          amount: -stats.remainingRecurringTotal,
        ),
        if (summary.futureNoted > 0)
          AccountEndOfMonthLine(context.tr(AccountLocale.futureNoted), amount: -summary.futureNoted),
        AccountEndOfMonthLine(
          context.tr(AccountLocale.estimatedDaily),
          subtitle: context.trWith(
            stats.remainingDays > 1 ? AccountLocale.dailyEstimateOther : AccountLocale.dailyEstimateOne,
            [context.money.wholeEuros(stats.rate), '${stats.remainingDays}'],
          ),
          amount: -stats.estimatedOccasional,
        ),
        AccountEndOfMonthLine(
          context.trWith(AccountLocale.estimatedOn, ['${stats.daysInMonth}', context.dates.monthName(stats.month)]),
          amount: summary.endOfMonth,
          isTotal: true,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          context.tr(AccountLocale.recalculatedNote),
          style: tokens.ts(12, tokens.wSemi, tokens.muted).copyWith(height: 1.45),
        ),
      ],
    );
  }
}
