import 'package:equatable/equatable.dart';

import 'label_envelope.dart';

class LabelEnvelopeProgress extends Equatable {
  const LabelEnvelopeProgress({required this.envelope, required this.spent});

  final LabelEnvelope envelope;
  final double spent;

  bool get isOver => spent > envelope.amount;

  double get usedRatio => envelope.amount > 0 ? spent / envelope.amount : 0;

  @override
  List<Object?> get props => [envelope, spent];
}
