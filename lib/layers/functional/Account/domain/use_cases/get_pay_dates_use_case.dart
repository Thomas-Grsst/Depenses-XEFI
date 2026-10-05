import 'get_balance_projection_use_case.dart';

class GetPayDatesUseCase {
  GetPayDatesUseCase(this._projection);

  final GetBalanceProjectionUseCase _projection;

  List<DateTime> call(DateTime from, DateTime to) => _projection().payDates(from, to);
}
