import 'package:depenses/layers/functional/Account/domain/entities/account_summary.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_item_row.dart';
import 'package:depenses/layers/technical/Theme/app_list_section.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/month_stats.dart';
import '../../domain/entities/recurrence_tally.dart';
import '../l10n/forecast_locale.dart';

class ForecastRemainingSection extends StatelessWidget {
  const ForecastRemainingSection({
    super.key,
    required this.stats,
    required this.account,
    required this.remainingRecurrences,
  });

  final MonthStats stats;
  final AccountSummary account;
  final List<RecurrenceTally> remainingRecurrences;

  String _recurrenceSummary(BuildContext context) {
    if (remainingRecurrences.isEmpty) return context.tr(ForecastLocale.noRecurrenceLeft);
    return remainingRecurrences
        .map((t) => t.isRepeated ? context.trWith(ForecastLocale.recurrenceTimes, [t.name, '${t.count}']) : t.name)
        .join(context.tr(ForecastLocale.listSeparator));
  }

  String _dailyEstimateKey(bool graphite) {
    final isOne = stats.remainingDays <= 1;
    if (graphite) return isOne ? ForecastLocale.dailyEstimateOneShort : ForecastLocale.dailyEstimateOtherShort;
    return isOne ? ForecastLocale.dailyEstimateOne : ForecastLocale.dailyEstimateOther;
  }

  @override
  Widget build(BuildContext context) {
    final money = context.money;
    return AppListSection(
      title: context.tr(ForecastLocale.remainingTitle),
      closed: true,
      children: [
        AppItemRow(
          title: context.tr(ForecastLocale.plannedRecurrences),
          subtitle: _recurrenceSummary(context),
          trailing: money.euros(stats.remainingRecurringTotal),
        ),
        AppItemRow(
          title: context.tr(ForecastLocale.estimatedDaily),
          subtitle: context.trWith(_dailyEstimateKey(context.tokens.isGraphite), [
            money.wholeEuros(stats.rate),
            '${stats.remainingDays}',
          ]),
          trailing: money.euros(stats.estimatedOccasional),
        ),
        for (final payDate in account.payDatesLeftThisMonth)
          AppItemRow(
            title: context.tr(ForecastLocale.salary),
            subtitle: context.dates.longDate(payDate, today: stats.today),
            trailing: money.withSign(account.income, money.euros),
          ),
        if (account.hasBalance)
          AppItemRow(
            title: context.trWith(ForecastLocale.estimatedBalanceOn, ['${stats.daysInMonth}']),
            subtitle: context.trWith(ForecastLocale.balanceToday, [money.euros(account.balance)]),
            trailing: money.euros(account.endOfMonth),
          ),
      ],
    );
  }
}
