import 'package:depenses/layers/functional/Expenses/domain/use_cases/get_months_with_data_use_case.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';

class GetComparableMonthsUseCase {
  GetComparableMonthsUseCase(this._monthsWithData, this._clock);

  final GetMonthsWithDataUseCase _monthsWithData;
  final Clock _clock;

  List<DateTime> call() {
    final current = _clock.today().monthIndex;
    return _monthsWithData().where((month) => month.monthIndex != current).toList();
  }
}
