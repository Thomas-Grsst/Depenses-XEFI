import '../entities/linked_bank_account.dart';

abstract class LinkedAccountGateway {
  List<LinkedBankAccount> all();

  Future<void> save(LinkedBankAccount account);

  Future<void> remove(String uid);
}
