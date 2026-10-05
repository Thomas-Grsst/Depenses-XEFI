import 'dart:math';

import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';

import 'account_settings.dart';

class BalanceProjection {
  const BalanceProjection(this.settings, this.expenses);

  final AccountSettings settings;
  final List<Expense> expenses;

  List<DateTime> payDates(DateTime from, DateTime to) {
    if (settings.income <= 0) return const [];
    final dates = <DateTime>[];
    for (var month = from.firstOfMonth; !month.isAfter(to); month = DateTime(month.year, month.month + 1)) {
      final date = DateTime(month.year, month.month, min(settings.payDay, month.daysInItsMonth));
      if (!date.isBefore(from) && !date.isAfter(to)) dates.add(date);
    }
    return dates;
  }

  double balanceAt(DateTime day) {
    final since = settings.balanceDate;
    final balance = settings.balance;
    if (since == null || balance == null) return 0;
    final salaries = payDates(since.nextDay, day).length * settings.income;
    final debited = expenses
        .where((e) => _countsSince(e, since) && !e.date.isAfter(day))
        .fold(0.0, (total, e) => total + e.debited);
    return balance + salaries - debited;
  }

  double futureNoted(DateTime today) => expenses
      .where(
        (e) =>
            e.date.year == today.year &&
            e.date.month == today.month &&
            e.date.isAfter(today) &&
            _countsSince(e, settings.balanceDate ?? today),
      )
      .fold(0.0, (total, e) => total + e.debited);

  bool _countsSince(Expense expense, DateTime since) =>
      expense.date.isAfter(since) || (expense.date.isSameDay(since) && !settings.balanceSkip.contains(expense.id));
}
