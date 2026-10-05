import '../entities/bank.dart';
import '../entities/linked_bank_account.dart';

abstract class BankAuthorizationGateway {
  Future<Uri> start(Bank bank, {required String state, required String redirectUrl, required DateTime validUntil});

  Future<List<LinkedBankAccount>> complete(String code);

  Future<void> revoke(LinkedBankAccount account);
}
