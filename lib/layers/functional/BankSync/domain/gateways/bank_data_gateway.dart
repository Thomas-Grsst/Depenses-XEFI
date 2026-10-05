import '../entities/bank_transaction.dart';
import '../entities/linked_bank_account.dart';

abstract class BankDataGateway {
  Future<List<BankTransaction>> transactions(LinkedBankAccount account, DateTime from);

  Future<double?> balance(LinkedBankAccount account);
}
