import '../entities/month_spending.dart';
import '../gateways/expense_gateway.dart';
import 'get_months_with_data_use_case.dart';

class GetMonthlySpendingUseCase {
  GetMonthlySpendingUseCase(this._monthsWithData, this._expenses);

  final GetMonthsWithDataUseCase _monthsWithData;
  final ExpenseGateway _expenses;

  List<MonthSpending> call() => [
    for (final month in _monthsWithData())
      MonthSpending(month: month, total: _expenses.inMonth(month).fold(0.0, (total, e) => total + e.amount)),
  ];
}
