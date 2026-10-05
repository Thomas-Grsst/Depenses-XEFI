import '../entities/linked_bank_account.dart';
import '../gateways/bank_authorization_gateway.dart';
import '../gateways/linked_account_gateway.dart';

class UnlinkBankAccountUseCase {
  UnlinkBankAccountUseCase(this._authorization, this._accounts);

  final BankAuthorizationGateway _authorization;
  final LinkedAccountGateway _accounts;

  Future<void> call(LinkedBankAccount account) async {
    await _authorization.revoke(account);
    await _accounts.remove(account.uid);
  }
}
