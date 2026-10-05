import '../entities/recurrence.dart';
import '../gateways/recurrence_gateway.dart';

class GetRecurrencesByMonthlyAmountUseCase {
  GetRecurrencesByMonthlyAmountUseCase(this._recurrences);

  final RecurrenceGateway _recurrences;

  List<Recurrence> call() => [..._recurrences.all()]..sort((a, b) => b.monthlyAmount.compareTo(a.monthlyAmount));
}
