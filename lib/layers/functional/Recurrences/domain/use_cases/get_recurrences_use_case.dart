import '../entities/recurrence.dart';
import '../gateways/recurrence_gateway.dart';

class GetRecurrencesUseCase {
  GetRecurrencesUseCase(this._recurrences);

  final RecurrenceGateway _recurrences;

  List<Recurrence> call() => _recurrences.all();
}
