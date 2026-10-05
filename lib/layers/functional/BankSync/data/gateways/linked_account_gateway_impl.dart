import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';
import 'package:depenses/layers/technical/Storage/secret_store.dart';

import '../../domain/entities/linked_bank_account.dart';
import '../../domain/gateways/linked_account_gateway.dart';
import '../models/linked_bank_account_model.dart';
import 'bank_session_key.dart';

class LinkedAccountGatewayImpl implements LinkedAccountGateway {
  LinkedAccountGatewayImpl(this._store, this._secrets);

  final DocumentStore _store;
  final SecretStore _secrets;

  @override
  List<LinkedBankAccount> all() => List.unmodifiable([
    for (final json in jsonRecords(_store.read(LedgerSection.bankAccounts))) LinkedBankAccountModel.fromJson(json),
  ]);

  @override
  Future<void> save(LinkedBankAccount account) {
    final accounts = all();
    final isKnown = accounts.any((known) => known.uid == account.uid);
    return _write([for (final known in accounts) known.uid == account.uid ? account : known, if (!isKnown) account]);
  }

  @override
  Future<void> remove(String uid) async {
    await _write([
      for (final known in all())
        if (known.uid != uid) known,
    ]);
    await _secrets.delete(bankSessionKey(uid));
  }

  Future<void> _write(List<LinkedBankAccount> accounts) => _store.write(LedgerSection.bankAccounts, [
    for (final account in accounts) LinkedBankAccountModel.toJson(account),
  ]);
}
