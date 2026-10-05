import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/entities/linked_bank_account.dart';

abstract final class LinkedBankAccountModel {
  static LinkedBankAccount fromJson(Map<String, dynamic> json) => LinkedBankAccount(
    uid: json.text('uid'),
    bankName: json.text('bank'),
    country: json.text('country', fallback: 'FR'),
    label: json.text('label'),
    accessValidUntil: json.day('validUntil'),
    lastSyncedAt: json.optionalDay('lastSync'),
    lastBankBalance: json.optionalDecimal('balance'),
    isRevoked: json.flag('revoked'),
  );

  static Map<String, dynamic> toJson(LinkedBankAccount account) => {
    'uid': account.uid,
    'bank': account.bankName,
    'country': account.country,
    'label': account.label,
    'validUntil': account.accessValidUntil.toIso8601String(),
    'lastSync': account.lastSyncedAt?.toIso8601String(),
    'balance': account.lastBankBalance,
    if (account.isRevoked) 'revoked': true,
  };
}
