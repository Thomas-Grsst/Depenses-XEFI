import 'dart:async';
import 'dart:convert';

import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';

class InMemoryDocumentStore implements DocumentStore {
  InMemoryDocumentStore([Map<String, dynamic>? initial])
      : _sections = initial == null ? {} : Map<String, dynamic>.from(jsonDecode(jsonEncode(initial)) as Map);

  final Map<String, dynamic> _sections;
  final StreamController<void> _changes = StreamController<void>.broadcast(sync: true);
  int writes = 0;

  @override
  Stream<void> get changes => _changes.stream;

  @override
  Object? read(LedgerSection section) => _sections[section.key];

  @override
  Future<void> write(LedgerSection section, Object? value) async {
    _sections[section.key] = jsonDecode(jsonEncode(value));
    writes++;
    _changes.add(null);
  }

  @override
  Map<String, dynamic> readSettings() =>
      Map<String, dynamic>.from(read(LedgerSection.settings) as Map? ?? const {});

  @override
  Future<void> mergeSettings(Map<String, dynamic> fields) =>
      write(LedgerSection.settings, {...readSettings(), ...fields});

  Map<String, dynamic> get snapshot => Map<String, dynamic>.unmodifiable(_sections);

  Future<void> dispose() => _changes.close();
}
