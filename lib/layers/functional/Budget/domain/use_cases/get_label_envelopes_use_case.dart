import '../entities/label_envelope.dart';
import '../gateways/label_envelope_gateway.dart';

class GetLabelEnvelopesUseCase {
  GetLabelEnvelopesUseCase(this._envelopes);

  final LabelEnvelopeGateway _envelopes;

  List<LabelEnvelope> call() => _envelopes.all();
}
