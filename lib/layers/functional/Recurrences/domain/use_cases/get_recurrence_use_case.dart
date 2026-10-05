import '../entities/recurrence.dart';
import '../gateways/recurrence_gateway.dart';

class GetRecurrenceUseCase {
  GetRecurrenceUseCase(this._recurrences);

  final RecurrenceGateway _recurrences;

  Recurrence? call(String? id) => _recurrences.byId(id);
}
