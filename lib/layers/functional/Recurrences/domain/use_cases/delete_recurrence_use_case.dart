import '../gateways/recurrence_gateway.dart';

class DeleteRecurrenceUseCase {
  DeleteRecurrenceUseCase(this._recurrences);

  final RecurrenceGateway _recurrences;

  Future<void> call(String id) => _recurrences.delete(id);
}
