import 'package:depenses/layers/technical/Calendar/clock.dart';

import 'get_balance_projection_use_case.dart';

class GetFutureNotedUseCase {
  GetFutureNotedUseCase(this._projection, this._clock);

  final GetBalanceProjectionUseCase _projection;
  final Clock _clock;

  double call() => _projection().futureNoted(_clock.today());
}
