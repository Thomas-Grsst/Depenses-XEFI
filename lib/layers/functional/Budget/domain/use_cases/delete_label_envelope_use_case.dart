import '../gateways/label_envelope_gateway.dart';

class DeleteLabelEnvelopeUseCase {
  DeleteLabelEnvelopeUseCase(this._envelopes);

  final LabelEnvelopeGateway _envelopes;

  Future<void> call(String id) => _envelopes.saveAll(_envelopes.all().where((e) => e.id != id).toList());
}
