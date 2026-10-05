import '../entities/label_envelope.dart';

abstract class LabelEnvelopeGateway {
  List<LabelEnvelope> all();

  Future<void> saveAll(List<LabelEnvelope> envelopes);
}
