import '../entities/bank_link.dart';

abstract class BankLinkGateway {
  List<BankLink> all();

  Future<void> saveAll(List<BankLink> links);

  Set<String> dismissed();

  Future<void> dismiss(String transactionId);
}
