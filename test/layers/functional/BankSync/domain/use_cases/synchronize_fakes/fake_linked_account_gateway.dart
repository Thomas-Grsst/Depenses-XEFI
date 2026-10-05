import 'package:depenses/layers/functional/BankSync/domain/entities/linked_bank_account.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/linked_account_gateway.dart';

class FakeLinkedAccountGateway implements LinkedAccountGateway {
  FakeLinkedAccountGateway([List<LinkedBankAccount> accounts = const []]) : accounts = [...accounts];

  final List<LinkedBankAccount> accounts;

  LinkedBankAccount byUid(String uid) => accounts.firstWhere((account) => account.uid == uid);

  @override
  List<LinkedBankAccount> all() => List.unmodifiable(accounts);

  @override
  Future<void> save(LinkedBankAccount account) async {
    final index = accounts.indexWhere((candidate) => candidate.uid == account.uid);
    if (index < 0) {
      accounts.add(account);
    } else {
      accounts[index] = account;
    }
  }

  @override
  Future<void> remove(String uid) async => accounts.removeWhere((account) => account.uid == uid);
}
