import 'package:depenses/layers/technical/Storage/id_generator.dart';

import '../entities/label_envelope.dart';
import '../gateways/label_envelope_gateway.dart';

class AddLabelEnvelopeUseCase {
  AddLabelEnvelopeUseCase(this._envelopes, this._ids);

  final LabelEnvelopeGateway _envelopes;
  final IdGenerator _ids;

  Future<LabelEnvelope> call({required String name, required String label, required double amount}) async {
    final envelope = LabelEnvelope(id: _ids.next(), name: name, label: label, amount: amount);
    await _envelopes.saveAll([..._envelopes.all(), envelope]);
    return envelope;
  }
}
