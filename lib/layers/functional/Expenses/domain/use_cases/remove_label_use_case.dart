import 'package:depenses/layers/functional/Recurrences/domain/gateways/recurrence_gateway.dart';

import '../gateways/expense_gateway.dart';
import '../gateways/label_gateway.dart';

class RemoveLabelUseCase {
  RemoveLabelUseCase(this._labels, this._expenses, this._recurrences);

  final LabelGateway _labels;
  final ExpenseGateway _expenses;
  final RecurrenceGateway _recurrences;

  Future<void> call(String label) async {
    await _labels.forget(label);
    await _expenses.removeLabel(label);
    await _recurrences.saveAll([
      for (final recurrence in _recurrences.all())
        recurrence.labels.contains(label)
            ? recurrence.copyWith(labels: recurrence.labels.where((l) => l != label).toList())
            : recurrence,
    ]);
  }
}
