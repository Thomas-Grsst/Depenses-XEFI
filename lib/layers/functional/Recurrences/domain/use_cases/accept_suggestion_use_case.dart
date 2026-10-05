import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/Storage/id_generator.dart';

import '../entities/frequency.dart';
import '../entities/recurrence.dart';
import '../entities/recurring_suggestion.dart';
import '../gateways/recurrence_gateway.dart';

class AcceptSuggestionUseCase {
  AcceptSuggestionUseCase(this._recurrences, this._expenses, this._ids, this._clock);

  final RecurrenceGateway _recurrences;
  final ExpenseGateway _expenses;
  final IdGenerator _ids;
  final Clock _clock;

  Future<Recurrence> call(RecurringSuggestion suggestion) async {
    final recurrence = Recurrence(
      id: _ids.next(),
      name: suggestion.name,
      amount: suggestion.amount,
      categoryKey: suggestion.categoryKey,
      frequency: Frequency.month,
      start: suggestion.lastDate,
      labels: [...suggestion.labels],
      lastGeneratedOn: _clock.today(),
    );
    await _recurrences.add(recurrence);
    await _expenses.linkToRecurrence(suggestion.expenseIds, recurrence.id);
    return recurrence;
  }
}
