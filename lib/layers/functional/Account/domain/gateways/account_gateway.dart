import '../entities/account_settings.dart';

abstract class AccountGateway {
  AccountSettings get();

  Future<void> save(AccountSettings settings);
}
