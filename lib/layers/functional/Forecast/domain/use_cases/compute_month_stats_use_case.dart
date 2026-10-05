import 'dart:math';

import 'package:depenses/layers/functional/Budget/domain/gateways/envelope_gateway.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/gateways/category_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/occurrence.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/get_upcoming_occurrences_use_case.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';

import '../entities/category_stats.dart';
import '../entities/cumulative_curve.dart';
import '../entities/month_stats.dart';
import '../entities/occasional_history.dart';
import '../entities/spending_pace.dart';
import '../entities/month_totals.dart';

class ComputeMonthStatsUseCase {
  ComputeMonthStatsUseCase(this._expenses, this._categories, this._envelopes, this._upcoming, this._clock);

  final ExpenseGateway _expenses;
  final CategoryGateway _categories;
  final EnvelopeGateway _envelopes;
  final GetUpcomingOccurrencesUseCase _upcoming;
  final Clock _clock;

  MonthStats call() {
    final today = _clock.today();
    final month = today.firstOfMonth;
    final keys = [for (final c in _categories.all()) c.key];
    String keyOf(String key) => keys.contains(key) ? key : Category.otherKey;

    final current = MonthTotals.current(_expenses.inMonth(month), today, keyOf);
    final previousMonth = DateTime(month.year, month.month - 1);
    final previous = MonthTotals.previous(
      _expenses.inMonth(previousMonth),
      sameDay: min(today.day, previousMonth.daysInItsMonth),
      daysInMonth: previousMonth.daysInItsMonth,
      keyOf: keyOf,
    );
    final history = OccasionalHistory(_expenses.inMonth, month);
    final pace = SpendingPace(elapsedDays: today.day, historyDays: history.days);
    final envelopes = _envelopes.all();
    final remainingDays = month.daysInItsMonth - today.day;
    final rate = pace.dailyRate(current.occasional, history.total);
    final remaining = _upcoming(today.nextDay, month.lastOfMonth);
    final remainingTotal = remaining.fold(0.0, (total, o) => total + o.recurrence.amount);

    final perCategory = {
      for (final key in keys)
        key: _categoryStats(key, current, previous, envelopes[key] ?? 0, remaining, pace, history, remainingDays),
    };
    final forecastCurve = [current.total];
    for (var day = today.day + 1; day <= month.daysInItsMonth; day++) {
      final due = remaining.where((o) => o.date.day == day).fold(0.0, (total, o) => total + o.recurrence.amount);
      forecastCurve.add(forecastCurve.last + rate + due);
    }

    return MonthStats(
      today: today,
      daysInMonth: month.daysInItsMonth,
      spent: current.total,
      spentRecurring: current.recurring,
      spentOccasional: current.occasional,
      previousSameDay: previous.sameDayTotal,
      previousFull: previous.total,
      hasPrevious: previous.hasExpenses,
      budget: envelopes.values.fold(0.0, (total, amount) => total + amount),
      rate: rate,
      estimatedOccasional: rate * remainingDays,
      remainingOccurrences: remaining,
      remainingRecurringTotal: remainingTotal,
      forecast: current.total + remainingTotal + rate * remainingDays,
      perCategory: perCategory,
      realCurve: cumulativeCurve(current.daily, length: today.day),
      previousCurve: cumulativeCurve(previous.daily),
      forecastCurve: forecastCurve,
      previousDaysInMonth: previousMonth.daysInItsMonth,
    );
  }

  CategoryStats _categoryStats(
    String key,
    MonthTotals current,
    MonthTotals previous,
    double budget,
    List<Occurrence> remaining,
    SpendingPace pace,
    OccasionalHistory history,
    int remainingDays,
  ) {
    final spent = current.perCategory[key] ?? 0;
    final occasional = current.occasionalPerCategory[key] ?? 0;
    final remainingRecurring = _upcomingTotalFor(key, remaining);
    final dailyRate = pace.dailyRate(occasional, history.perCategory[key] ?? 0);
    return CategoryStats(
      categoryKey: key,
      spent: spent,
      occasionalSpent: occasional,
      previousSameDay: previous.sameDayPerCategory[key] ?? 0,
      budget: budget,
      remainingRecurring: remainingRecurring,
      projected: spent + remainingRecurring + dailyRate * remainingDays,
    );
  }

  double _upcomingTotalFor(String key, List<Occurrence> remaining) =>
      remaining.where((o) => o.recurrence.categoryKey == key).fold(0.0, (total, o) => total + o.recurrence.amount);
}
