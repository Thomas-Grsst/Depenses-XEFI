import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';

import '../gateways/expense_gateway.dart';

class GetMonthsWithDataUseCase {
  GetMonthsWithDataUseCase(this._expenses, this._clock);

  final ExpenseGateway _expenses;
  final Clock _clock;

  List<DateTime> call() {
    final indexes = <int>{_clock.today().monthIndex, for (final e in _expenses.all()) e.date.monthIndex};
    final sorted = indexes.toList()..sort((a, b) => b.compareTo(a));
    return [for (final index in sorted) monthFromIndex(index)];
  }
}
