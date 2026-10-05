import 'package:depenses/layers/functional/BankSync/domain/entities/bank.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/bank_directory_gateway.dart';

class FakeBankDirectoryGateway implements BankDirectoryGateway {
  FakeBankDirectoryGateway({this.isConfigured = true});

  bool isConfigured;

  @override
  bool isAvailable() => isConfigured;

  @override
  Future<List<Bank>> banks(String country) async => const [];
}
