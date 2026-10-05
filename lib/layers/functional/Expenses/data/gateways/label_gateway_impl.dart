import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';

import '../../domain/entities/default_labels.dart';
import '../../domain/gateways/label_gateway.dart';

class LabelGatewayImpl implements LabelGateway {
  LabelGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  List<String> all() {
    final stored = List<String>.from(_store.read(LedgerSection.labels) as List? ?? const []);
    return stored.isEmpty ? defaultLabels : stored;
  }

  @override
  Future<void> learn(Iterable<String> labels) async {
    final known = all();
    final unknown = labels.where((label) => !known.contains(label)).toSet();
    if (unknown.isEmpty) return;
    await _store.write(LedgerSection.labels, [...known, ...unknown]);
  }

  @override
  Future<void> forget(String label) => _store.write(LedgerSection.labels, all().where((l) => l != label).toList());
}
