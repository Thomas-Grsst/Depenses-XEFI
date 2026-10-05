import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';

import '../entities/label_envelope_progress.dart';
import '../gateways/label_envelope_gateway.dart';
import 'get_label_spent_use_case.dart';

class GetLabelEnvelopeProgressUseCase {
  GetLabelEnvelopeProgressUseCase(this._envelopes, this._getLabelSpent, this._clock);

  final LabelEnvelopeGateway _envelopes;
  final GetLabelSpentUseCase _getLabelSpent;
  final Clock _clock;

  List<LabelEnvelopeProgress> call() {
    final month = _clock.today().firstOfMonth;
    return [
      for (final envelope in _envelopes.all())
        LabelEnvelopeProgress(envelope: envelope, spent: _getLabelSpent(envelope.label, month)),
    ];
  }
}
