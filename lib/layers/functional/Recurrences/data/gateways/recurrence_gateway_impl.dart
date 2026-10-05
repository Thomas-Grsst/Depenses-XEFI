import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';

import '../../domain/entities/recurrence.dart';
import '../../domain/gateways/recurrence_gateway.dart';
import '../models/recurrence_model.dart';

class RecurrenceGatewayImpl implements RecurrenceGateway {
  RecurrenceGatewayImpl(this._store);

  final DocumentStore _store;
  List<Recurrence>? _cache;

  @override
  List<Recurrence> all() => _cache ??= List.unmodifiable([
    for (final json in jsonRecords(_store.read(LedgerSection.recurrences))) RecurrenceModel.fromJson(json),
  ]);

  @override
  Recurrence? byId(String? id) {
    for (final recurrence in all()) {
      if (recurrence.id == id) return recurrence;
    }
    return null;
  }

  @override
  Future<void> add(Recurrence recurrence) => saveAll([...all(), recurrence]);

  @override
  Future<void> update(Recurrence recurrence) =>
      saveAll([for (final r in all()) r.id == recurrence.id ? recurrence : r]);

  @override
  Future<void> delete(String id) => saveAll(all().where((r) => r.id != id).toList());

  @override
  Future<void> reassignCategory({required String from, required String to}) =>
      saveAll([for (final r in all()) r.categoryKey == from ? r.copyWith(categoryKey: to) : r]);

  @override
  Future<void> clear() => saveAll(const []);

  @override
  Future<void> saveAll(List<Recurrence> recurrences) {
    _cache = List.unmodifiable(recurrences);
    return _store.write(LedgerSection.recurrences, [for (final r in recurrences) RecurrenceModel.toJson(r)]);
  }
}
