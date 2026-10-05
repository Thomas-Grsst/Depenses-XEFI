import 'ledger_changes.dart';
import 'ledger_section.dart';

abstract class DocumentStore implements LedgerChanges {
  Object? read(LedgerSection section);

  Future<void> write(LedgerSection section, Object? value);

  Map<String, dynamic> readSettings();

  Future<void> mergeSettings(Map<String, dynamic> fields);
}
