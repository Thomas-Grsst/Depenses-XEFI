import '../gateways/envelope_gateway.dart';

class GetTotalBudgetUseCase {
  GetTotalBudgetUseCase(this._envelopes);

  final EnvelopeGateway _envelopes;

  double call() => _envelopes.all().values.fold(0.0, (total, amount) => total + amount);
}
