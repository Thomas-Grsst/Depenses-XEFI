import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';

import '../entities/balance_projection.dart';
import '../gateways/account_gateway.dart';

class GetBalanceProjectionUseCase {
  GetBalanceProjectionUseCase(this._account, this._expenses);

  final AccountGateway _account;
  final ExpenseGateway _expenses;

  BalanceProjection call() => BalanceProjection(_account.get(), _expenses.all());
}
