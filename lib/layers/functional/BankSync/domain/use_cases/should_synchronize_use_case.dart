import '../entities/linked_bank_account.dart';
import '../gateways/bank_directory_gateway.dart';
import '../gateways/linked_account_gateway.dart';

const _minimumInterval = Duration(hours: 1);

class ShouldSynchronizeUseCase {
  ShouldSynchronizeUseCase(this._directory, this._accounts, {this._now = DateTime.now});

  final BankDirectoryGateway _directory;
  final LinkedAccountGateway _accounts;
  final DateTime Function() _now;

  bool call() {
    if (!_directory.isAvailable()) return false;
    final now = _now();
    final active = _accounts.all().where((account) => account.statusAt(now) == LinkedAccountStatus.linked).toList();
    if (active.isEmpty) return false;
    final threshold = now.subtract(_minimumInterval);
    return active.any((account) => account.lastSyncedAt?.isAfter(threshold) != true);
  }
}
