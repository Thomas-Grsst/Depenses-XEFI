import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';

import 'get_balance_projection_use_case.dart';

class GetNextPaydayUseCase {
  GetNextPaydayUseCase(this._projection, this._clock);

  final GetBalanceProjectionUseCase _projection;
  final Clock _clock;

  DateTime? call() {
    final today = _clock.today();
    final dates = _projection().payDates(today.nextDay, DateTime(today.year, today.month + 2));
    return dates.isEmpty ? null : dates.first;
  }
}
