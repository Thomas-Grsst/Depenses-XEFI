import 'package:depenses/layers/technical/Calendar/clock.dart';

import '../entities/linked_account_overview.dart';
import '../gateways/linked_account_gateway.dart';

class GetLinkedAccountsUseCase {
  GetLinkedAccountsUseCase(this._accounts, this._clock);

  final LinkedAccountGateway _accounts;
  final Clock _clock;

  List<LinkedAccountOverview> call() {
    final today = _clock.today();
    return [
      for (final account in _accounts.all()) LinkedAccountOverview(account: account, status: account.statusAt(today)),
    ];
  }
}
