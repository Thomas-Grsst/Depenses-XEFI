import '../entities/bank_authorization_cancelled_exception.dart';
import '../entities/bank_authorization_rejected_exception.dart';
import '../entities/linked_bank_account.dart';
import '../gateways/authorization_state_gateway.dart';
import '../gateways/bank_authorization_gateway.dart';
import '../gateways/linked_account_gateway.dart';

class CompleteBankAuthorizationUseCase {
  CompleteBankAuthorizationUseCase(this._authorization, this._pendingState, this._accounts);

  final BankAuthorizationGateway _authorization;
  final AuthorizationStateGateway _pendingState;
  final LinkedAccountGateway _accounts;

  Future<List<LinkedBankAccount>> call({String? code, String? state, String? error}) async {
    final expectedState = _pendingState.pending();
    await _pendingState.clear();
    if (code == null || code.isEmpty) throw BankAuthorizationCancelledException(error);
    if (expectedState == null || state != expectedState) {
      throw const BankAuthorizationRejectedException('state does not match the pending authorization');
    }
    final linked = await _authorization.complete(code);
    for (final account in linked) {
      await _accounts.save(_renewed(account));
    }
    return linked;
  }

  LinkedBankAccount _renewed(LinkedBankAccount account) {
    for (final known in _accounts.all()) {
      if (known.uid == account.uid) {
        return account.copyWith(lastSyncedAt: known.lastSyncedAt, lastBankBalance: known.lastBankBalance);
      }
    }
    return account;
  }
}
