import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/entities/bank_link.dart';

abstract final class BankLinkModel {
  static BankLink fromJson(Map<String, dynamic> json) => BankLink(
    transactionId: json.text('tx'),
    expenseId: json.text('expense'),
    accountUid: json.text('account'),
    kind: BankLinkKind.fromStorageKey(json.optionalText('kind')),
    wasPending: json.flag('pending'),
  );

  static Map<String, dynamic> toJson(BankLink link) => {
    'tx': link.transactionId,
    'expense': link.expenseId,
    'account': link.accountUid,
    'kind': link.kind.storageKey,
    'pending': link.wasPending,
  };
}
