import '../entities/bank.dart';
import '../gateways/bank_directory_gateway.dart';

const defaultBankCountry = 'FR';

class GetBanksUseCase {
  GetBanksUseCase(this._directory);

  final BankDirectoryGateway _directory;

  Future<List<Bank>> call({String country = defaultBankCountry}) async {
    final banks = [...await _directory.banks(country)];
    banks.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return List.unmodifiable(banks);
  }
}
