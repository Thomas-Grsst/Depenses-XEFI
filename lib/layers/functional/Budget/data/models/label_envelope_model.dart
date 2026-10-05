import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/entities/label_envelope.dart';

abstract final class LabelEnvelopeModel {
  static LabelEnvelope fromJson(Map<String, dynamic> json) => LabelEnvelope(
    id: json.text('id'),
    name: json.text('name'),
    label: json.text('label'),
    amount: json.decimal('amount'),
  );

  static Map<String, dynamic> toJson(LabelEnvelope envelope) => {
    'id': envelope.id,
    'name': envelope.name,
    'label': envelope.label,
    'amount': envelope.amount,
  };
}
