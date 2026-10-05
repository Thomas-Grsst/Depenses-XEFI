import 'package:depenses/layers/functional/Forecast/domain/entities/month_stats.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';

import '../entities/account_summary.dart';
import 'get_account_settings_use_case.dart';
import 'get_balance_end_of_month_use_case.dart';
import 'get_balance_use_case.dart';
import 'get_future_noted_use_case.dart';
import 'get_next_payday_use_case.dart';
import 'get_pay_dates_use_case.dart';

class GetAccountSummaryUseCase {
  GetAccountSummaryUseCase(
    this._settings,
    this._balance,
    this._endOfMonth,
    this._futureNoted,
    this._nextPayday,
    this._payDates,
  );

  final GetAccountSettingsUseCase _settings;
  final GetBalanceUseCase _balance;
  final GetBalanceEndOfMonthUseCase _endOfMonth;
  final GetFutureNotedUseCase _futureNoted;
  final GetNextPaydayUseCase _nextPayday;
  final GetPayDatesUseCase _payDates;

  AccountSummary call(MonthStats stats) {
    final settings = _settings();
    return AccountSummary(
      hasBalance: settings.hasBalance,
      balance: _balance(),
      income: settings.income,
      payDay: settings.payDay,
      endOfMonth: _endOfMonth(stats),
      futureNoted: _futureNoted(),
      nextPayday: _nextPayday(),
      payDatesLeftThisMonth: _payDates(stats.today.nextDay, stats.today.lastOfMonth),
    );
  }
}
