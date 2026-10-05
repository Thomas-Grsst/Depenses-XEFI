import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';

import '../../domain/entities/bank_link.dart';
import '../../domain/gateways/bank_link_gateway.dart';
import '../models/bank_link_model.dart';

class BankLinkGatewayImpl implements BankLinkGateway {
  BankLinkGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  List<BankLink> all() => List.unmodifiable([
    for (final json in jsonRecords(_store.read(LedgerSection.bankLinks))) BankLinkModel.fromJson(json),
  ]);

  @override
  Future<void> saveAll(List<BankLink> links) =>
      _store.write(LedgerSection.bankLinks, [for (final link in links) BankLinkModel.toJson(link)]);

  @override
  Set<String> dismissed() =>
      Set.unmodifiable(List<String>.from(_store.read(LedgerSection.bankDismissed) as List? ?? const []));

  @override
  Future<void> dismiss(String transactionId) async {
    final current = dismissed();
    if (current.contains(transactionId)) return;
    await _store.write(LedgerSection.bankDismissed, [...current, transactionId]);
  }
}
