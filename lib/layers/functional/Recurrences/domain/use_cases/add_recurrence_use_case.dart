import 'package:depenses/layers/functional/Expenses/domain/gateways/label_gateway.dart';
import 'package:depenses/layers/technical/Storage/id_generator.dart';

import '../entities/recurrence.dart';
import '../entities/recurrence_draft.dart';
import '../gateways/recurrence_gateway.dart';
import 'materialize_due_recurrences_use_case.dart';

class AddRecurrenceUseCase {
  AddRecurrenceUseCase(this._recurrences, this._labels, this._ids, this._materialize);

  final RecurrenceGateway _recurrences;
  final LabelGateway _labels;
  final IdGenerator _ids;
  final MaterializeDueRecurrencesUseCase _materialize;

  Future<Recurrence> call(RecurrenceDraft draft) async {
    final recurrence = Recurrence(
      id: _ids.next(),
      name: draft.name,
      amount: draft.amount,
      categoryKey: draft.categoryKey,
      frequency: draft.frequency,
      start: draft.start,
      labels: draft.labels,
    );
    await _labels.learn(recurrence.labels);
    await _recurrences.add(recurrence);
    await _materialize();
    return recurrence;
  }
}
