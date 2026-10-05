import '../gateways/bank_directory_gateway.dart';

class IsBankSyncAvailableUseCase {
  IsBankSyncAvailableUseCase(this._directory);

  final BankDirectoryGateway _directory;

  bool call() => _directory.isAvailable();
}
