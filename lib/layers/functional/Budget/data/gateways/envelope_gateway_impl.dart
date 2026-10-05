import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';

import '../../domain/gateways/envelope_gateway.dart';

class EnvelopeGatewayImpl implements EnvelopeGateway {
  EnvelopeGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  Map<String, double> all() => {
    for (final entry in (_store.read(LedgerSection.envelopes) as Map? ?? const {}).entries)
      entry.key as String: (entry.value as num).toDouble(),
  };

  @override
  Future<void> set(String categoryKey, double amount) {
    final envelopes = all();
    if (amount <= 0) {
      envelopes.remove(categoryKey);
    } else {
      envelopes[categoryKey] = amount;
    }
    return _store.write(LedgerSection.envelopes, envelopes);
  }

  @override
  Future<void> mergeInto({required String from, required String to}) async {
    final envelopes = all();
    final moved = envelopes.remove(from);
    if (moved == null) return;
    envelopes[to] = (envelopes[to] ?? 0) + moved;
    await _store.write(LedgerSection.envelopes, envelopes);
  }

  @override
  Future<void> clear() => _store.write(LedgerSection.envelopes, <String, double>{});
}
