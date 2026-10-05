import '../entities/bank.dart';

abstract class BankDirectoryGateway {
  bool isAvailable();

  Future<List<Bank>> banks(String country);
}
