import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';

import '../../domain/entities/label_envelope.dart';
import '../../domain/gateways/label_envelope_gateway.dart';
import '../models/label_envelope_model.dart';

class LabelEnvelopeGatewayImpl implements LabelEnvelopeGateway {
  LabelEnvelopeGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  List<LabelEnvelope> all() => [
    for (final json in jsonRecords(_store.read(LedgerSection.labelEnvelopes))) LabelEnvelopeModel.fromJson(json),
  ];

  @override
  Future<void> saveAll(List<LabelEnvelope> envelopes) =>
      _store.write(LedgerSection.labelEnvelopes, [for (final e in envelopes) LabelEnvelopeModel.toJson(e)]);
}
