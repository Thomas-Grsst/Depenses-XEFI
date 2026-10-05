import 'package:depenses/layers/functional/Forecast/domain/entities/month_stats.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';

import 'get_balance_projection_use_case.dart';

class GetBalanceEndOfMonthUseCase {
  GetBalanceEndOfMonthUseCase(this._projection);

  final GetBalanceProjectionUseCase _projection;

  double call(MonthStats stats) {
    final projection = _projection();
    final today = stats.today;
    final salary = projection.payDates(today.nextDay, today.lastOfMonth).length * projection.settings.income;
    return projection.balanceAt(today) + salary - (stats.forecast - stats.spent) - projection.futureNoted(today);
  }
}
