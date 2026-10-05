import 'package:depenses/layers/functional/Expenses/domain/gateways/label_gateway.dart';

import '../entities/recurrence.dart';
import '../gateways/recurrence_gateway.dart';

class UpdateRecurrenceUseCase {
  UpdateRecurrenceUseCase(this._recurrences, this._labels);

  final RecurrenceGateway _recurrences;
  final LabelGateway _labels;

  Future<void> call(Recurrence recurrence) async {
    await _labels.learn(recurrence.labels);
    await _recurrences.update(recurrence);
  }
}
