import 'package:depenses/layers/technical/Calendar/clock.dart';

import 'get_balance_projection_use_case.dart';

class GetBalanceUseCase {
  GetBalanceUseCase(this._projection, this._clock);

  final GetBalanceProjectionUseCase _projection;
  final Clock _clock;

  double call({DateTime? at}) => _projection().balanceAt(at ?? _clock.today());
}
