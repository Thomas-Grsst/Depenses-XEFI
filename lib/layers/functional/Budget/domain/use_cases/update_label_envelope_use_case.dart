import '../entities/label_envelope.dart';
import '../gateways/label_envelope_gateway.dart';

class UpdateLabelEnvelopeUseCase {
  UpdateLabelEnvelopeUseCase(this._envelopes);

  final LabelEnvelopeGateway _envelopes;

  Future<void> call(LabelEnvelope envelope) =>
      _envelopes.saveAll([for (final e in _envelopes.all()) e.id == envelope.id ? envelope : e]);
}
