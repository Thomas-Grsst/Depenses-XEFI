import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';

import '../../domain/entities/expense.dart';
import '../../domain/gateways/expense_gateway.dart';
import '../models/expense_model.dart';

class ExpenseGatewayImpl implements ExpenseGateway {
  ExpenseGatewayImpl(this._store);

  final DocumentStore _store;
  List<Expense>? _cache;

  @override
  List<Expense> all() => _cache ??= List.unmodifiable([
    for (final json in jsonRecords(_store.read(LedgerSection.expenses))) ExpenseModel.fromJson(json),
  ]);

  @override
  List<Expense> inMonth(DateTime month) =>
      all().where((e) => e.date.year == month.year && e.date.month == month.month).toList();

  @override
  Future<void> add(Expense expense) => _save([...all(), expense]);

  @override
  Future<void> addAll(List<Expense> expenses) => _save([...all(), ...expenses]);

  @override
  Future<void> update(Expense expense) => _save([for (final e in all()) e.id == expense.id ? expense : e]);

  @override
  Future<void> delete(String id) => _save(all().where((e) => e.id != id).toList());

  @override
  Future<void> reassignCategory({required String from, required String to}) =>
      _save([for (final e in all()) e.categoryKey == from ? e.copyWith(categoryKey: to) : e]);

  @override
  Future<void> removeLabel(String label) => _save([
    for (final e in all())
      e.labels.contains(label) ? e.copyWith(labels: e.labels.where((l) => l != label).toList()) : e,
  ]);

  @override
  Future<void> linkToRecurrence(Iterable<String> expenseIds, String recurrenceId) {
    final ids = expenseIds.toSet();
    return _save([for (final e in all()) ids.contains(e.id) ? e.copyWith(recurrenceId: () => recurrenceId) : e]);
  }

  @override
  Future<void> clear() => _save(const []);

  Future<void> _save(List<Expense> expenses) {
    _cache = List.unmodifiable(expenses);
    return _store.write(LedgerSection.expenses, [for (final e in expenses) ExpenseModel.toJson(e)]);
  }
}
