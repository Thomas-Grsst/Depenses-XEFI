import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'document_store.dart';
import 'ledger_section.dart';
import 'storage_key.dart';

class PreferencesDocumentStore implements DocumentStore {
  PreferencesDocumentStore(this._preferences) : _sections = _decode(_preferences.getString(StorageKey.ledger.value));

  final SharedPreferencesWithCache _preferences;
  final Map<String, dynamic> _sections;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  @override
  Stream<void> get changes => _changes.stream;

  @override
  Object? read(LedgerSection section) => _sections[section.key];

  @override
  Future<void> write(LedgerSection section, Object? value) async {
    _sections[section.key] = value;
    _changes.add(null);
    await _preferences.setString(StorageKey.ledger.value, jsonEncode(_sections));
  }

  @override
  Map<String, dynamic> readSettings() => Map<String, dynamic>.from(read(LedgerSection.settings) as Map? ?? const {});

  @override
  Future<void> mergeSettings(Map<String, dynamic> fields) =>
      write(LedgerSection.settings, {...readSettings(), ...fields});

  Future<void> close() => _changes.close();

  static Map<String, dynamic> _decode(String? raw) {
    if (raw == null) return {};
    try {
      return Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } on FormatException {
      return {};
    } on TypeError {
      return {};
    }
  }
}
