import '../gateways/account_gateway.dart';

class ClearBalanceUseCase {
  ClearBalanceUseCase(this._account);

  final AccountGateway _account;

  Future<void> call() => _account.save(_account.get().withBalance(null, null, const []));
}
