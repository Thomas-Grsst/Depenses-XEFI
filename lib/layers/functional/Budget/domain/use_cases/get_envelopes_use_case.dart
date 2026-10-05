import '../gateways/envelope_gateway.dart';

class GetEnvelopesUseCase {
  GetEnvelopesUseCase(this._envelopes);

  final EnvelopeGateway _envelopes;

  Map<String, double> call() => _envelopes.all();
}
