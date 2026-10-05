import 'dart:math';

import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/TextMatching/normalize_for_matching.dart';

import '../entities/recurring_suggestion.dart';
import '../gateways/detection_setting_gateway.dart';
import '../gateways/recurrence_gateway.dart';

const _lookbackMonths = 4;
const _maxDayDrift = 5;
const _minAmountTolerance = 0.05;
const _relativeAmountTolerance = 0.03;
const _minMonths = 2;

class DetectRecurringExpensesUseCase {
  DetectRecurringExpensesUseCase(this._expenses, this._recurrences, this._settings, this._clock);

  final ExpenseGateway _expenses;
  final RecurrenceGateway _recurrences;
  final DetectionSettingGateway _settings;
  final Clock _clock;

  List<RecurringSuggestion> call() {
    if (!_settings.isEnabled()) return const [];
    final today = _clock.today();
    final since = DateTime(today.year, today.month - _lookbackMonths, today.day);
    final known = {..._recurrences.all().map((r) => normalizeForMatching(r.name)), ..._settings.ignoredKeys()};
    final groups = <String, List<Expense>>{};
    for (final expense in _expenses.all()) {
      if (expense.isRecurring || expense.date.isBefore(since) || expense.date.isAfter(today)) continue;
      groups.putIfAbsent(normalizeForMatching(expense.name), () => []).add(expense);
    }
    final suggestions = [
      for (final entry in groups.entries)
        if (entry.key.isNotEmpty && !known.contains(entry.key)) _suggestionFor(entry.key, entry.value),
    ].whereType<RecurringSuggestion>().toList()..sort((a, b) => b.months.compareTo(a.months));
    return suggestions;
  }

  RecurringSuggestion? _suggestionFor(String key, List<Expense> expenses) {
    final sorted = [...expenses]..sort((a, b) => a.date.compareTo(b.date));
    final perMonth = <int, int>{};
    for (final expense in sorted) {
      perMonth.update(expense.date.monthIndex, (count) => count + 1, ifAbsent: () => 1);
    }
    if (perMonth.values.any((count) => count > 1)) return null;
    final last = sorted.last;
    final tolerance = max(_minAmountTolerance, last.amount * _relativeAmountTolerance);
    final similar = sorted
        .where((e) => (e.amount - last.amount).abs() <= tolerance && (e.date.day - last.date.day).abs() <= _maxDayDrift)
        .toList();
    final months = similar.map((e) => e.date.monthIndex).toSet();
    if (months.length < _minMonths) return null;
    return RecurringSuggestion(
      key: key,
      name: last.name,
      categoryKey: last.categoryKey,
      amount: last.amount,
      months: months.length,
      lastDate: last.date,
      labels: last.labels,
      expenseIds: [for (final e in similar) e.id],
    );
  }
}
