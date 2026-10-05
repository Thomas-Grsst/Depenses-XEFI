import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/entities/account_settings.dart';
import '../../domain/gateways/account_gateway.dart';

class AccountGatewayImpl implements AccountGateway {
  AccountGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  AccountSettings get() {
    final json = _store.readSettings();
    return AccountSettings(
      income: json.decimal('income'),
      payDay: json.integer('payDay', fallback: 1),
      balance: json.optionalDecimal('balance'),
      balanceDate: json.optionalDay('balanceDate'),
      balanceSkip: json.strings('balanceSkip'),
    );
  }

  @override
  Future<void> save(AccountSettings settings) {
    final balanceDate = settings.balanceDate;
    return _store.mergeSettings({
      'income': settings.income,
      'payDay': settings.payDay,
      'balance': settings.balance,
      'balanceDate': balanceDate == null ? null : encodeDay(balanceDate),
      'balanceSkip': settings.balanceSkip,
    });
  }
}
