import '../gateways/recurrence_gateway.dart';

class GetFixedMonthlyTotalUseCase {
  GetFixedMonthlyTotalUseCase(this._recurrences);

  final RecurrenceGateway _recurrences;

  double call() => _recurrences.all().fold(0.0, (total, r) => total + r.monthlyAmount);
}
