import '../gateways/envelope_gateway.dart';

class SetEnvelopesUseCase {
  SetEnvelopesUseCase(this._envelopes);

  final EnvelopeGateway _envelopes;

  Future<void> call(Map<String, double> amountsByCategory) async {
    for (final entry in amountsByCategory.entries) {
      await _envelopes.set(entry.key, entry.value);
    }
  }
}
