import '../gateways/envelope_gateway.dart';

class SetEnvelopeUseCase {
  SetEnvelopeUseCase(this._envelopes);

  final EnvelopeGateway _envelopes;

  Future<void> call(String categoryKey, double amount) => _envelopes.set(categoryKey, amount);
}
