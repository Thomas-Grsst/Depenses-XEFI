import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/Storage/id_generator.dart';

import '../entities/recurrence.dart';
import '../gateways/recurrence_gateway.dart';

class MaterializeDueRecurrencesUseCase {
  MaterializeDueRecurrencesUseCase(this._recurrences, this._expenses, this._ids, this._clock);

  final RecurrenceGateway _recurrences;
  final ExpenseGateway _expenses;
  final IdGenerator _ids;
  final Clock _clock;

  Future<void> call() async {
    final today = _clock.today();
    final created = <Expense>[];
    var hasChanged = false;
    final updated = <Recurrence>[];
    for (final recurrence in _recurrences.all()) {
      final lastGenerated = recurrence.lastGeneratedOn;
      final from = lastGenerated == null ? recurrence.start : lastGenerated.nextDay;
      created.addAll([for (final date in recurrence.occurrences(from, today)) _expenseFor(recurrence, date)]);
      final isStale = lastGenerated == null || lastGenerated.isBefore(today);
      hasChanged = hasChanged || isStale;
      updated.add(isStale ? recurrence.copyWith(lastGeneratedOn: today) : recurrence);
    }
    if (created.isNotEmpty) await _expenses.addAll(created);
    if (hasChanged) await _recurrences.saveAll(updated);
  }

  Expense _expenseFor(Recurrence recurrence, DateTime date) => Expense(
    id: _ids.next(),
    name: recurrence.name,
    amount: recurrence.amount,
    date: date,
    categoryKey: recurrence.categoryKey,
    labels: [...recurrence.labels],
    recurrenceId: recurrence.id,
  );
}
