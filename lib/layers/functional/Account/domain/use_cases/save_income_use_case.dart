import '../gateways/account_gateway.dart';

class SaveIncomeUseCase {
  SaveIncomeUseCase(this._account);

  final AccountGateway _account;

  Future<void> call({required double income, required int payDay}) =>
      _account.save(_account.get().copyWith(income: income, payDay: payDay));
}
