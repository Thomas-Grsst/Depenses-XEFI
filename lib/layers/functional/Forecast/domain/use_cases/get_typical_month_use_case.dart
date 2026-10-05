import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';

import '../entities/occasional_history.dart';
import 'compute_month_stats_use_case.dart';

class GetTypicalMonthUseCase {
  GetTypicalMonthUseCase(this._expenses, this._stats, this._clock);

  final ExpenseGateway _expenses;
  final ComputeMonthStatsUseCase _stats;
  final Clock _clock;

  double call() {
    final today = _clock.today();
    var total = 0.0;
    var monthsWithData = 0;
    for (var offset = 1; offset <= historyMonths; offset++) {
      final expenses = _expenses.inMonth(DateTime(today.year, today.month - offset));
      if (expenses.isEmpty) continue;
      total += expenses.fold(0.0, (sum, e) => sum + e.amount);
      monthsWithData++;
    }
    return monthsWithData == 0 ? _stats().forecast : total / monthsWithData;
  }
}
