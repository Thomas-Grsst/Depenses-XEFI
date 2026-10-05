import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/get_recurrences_use_case.dart';

class GetSimulableRecurrencesUseCase {
  GetSimulableRecurrencesUseCase(this._recurrences);

  final GetRecurrencesUseCase _recurrences;

  List<Recurrence> call(Set<String> alreadyUsedIds) =>
      _recurrences().where((r) => !alreadyUsedIds.contains(r.id)).toList()
        ..sort((a, b) => b.monthlyAmount.compareTo(a.monthlyAmount));
}
