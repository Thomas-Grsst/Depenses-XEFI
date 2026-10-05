import '../entities/account_settings.dart';
import '../gateways/account_gateway.dart';

class GetAccountSettingsUseCase {
  GetAccountSettingsUseCase(this._account);

  final AccountGateway _account;

  AccountSettings call() => _account.get();
}
