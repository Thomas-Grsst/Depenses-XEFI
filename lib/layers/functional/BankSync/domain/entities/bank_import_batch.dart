import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_origin.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';

import 'bank_link.dart';
import 'bank_transaction.dart';

const _amountTolerance = 0.005;
const _matchingDays = 3;

class BankImportBatch {
  BankImportBatch({
    required Iterable<Expense> expenses,
    required Iterable<BankLink> links,
    required Iterable<String> dismissed,
    Iterable<Recurrence> recurrences = const [],
  }) : _expenses = {for (final expense in expenses) expense.id: expense},
       _links = {for (final link in links) link.transactionId: link},
       _dismissed = dismissed.toSet(),
       _recurrences = {for (final recurrence in recurrences) recurrence.id: recurrence};

  final Map<String, Expense> _expenses;
  final Map<String, BankLink> _links;
  final Set<String> _dismissed;
  final Map<String, Recurrence> _recurrences;
  final Map<String, Recurrence> _changedRecurrences = {};
  final Map<String, Expense> _created = {};
  final Map<String, Expense> _changed = {};
  final Set<String> _removed = {};
  var _hasLinkChanges = false;

  List<Expense> get createdExpenses => List.unmodifiable(_created.values);

  List<Expense> get changedExpenses => List.unmodifiable(_changed.values);

  Set<String> get removedExpenseIds => Set.unmodifiable(_removed);

  List<BankLink> get links => List.unmodifiable(_links.values);

  List<Recurrence> get recurrences => List.unmodifiable(_recurrences.values);

  List<Recurrence> get changedRecurrences => List.unmodifiable(_changedRecurrences.values);

  bool get hasChanges =>
      _hasLinkChanges ||
      _created.isNotEmpty ||
      _changed.isNotEmpty ||
      _removed.isNotEmpty ||
      _changedRecurrences.isNotEmpty;

  Iterable<Expense> get unlinkedExpenses {
    final linkedExpenseIds = {for (final link in _links.values) link.expenseId};
    return _expenses.values.where(
      (expense) => expense.bankTransactionId == null && !linkedExpenseIds.contains(expense.id),
    );
  }

  BankLink? linkOf(String transactionId) => _links[transactionId];

  Expense? expenseOf(String id) => _expenses[id];

  bool isDismissed(String transactionId) => _dismissed.contains(transactionId);

  Expense? manualMatchFor(BankTransaction transaction) {
    Expense? closest;
    var closestGap = _matchingDays + 1;
    for (final expense in unlinkedExpenses) {
      final isManual = expense.origin == ExpenseOrigin.manual;
      if (!isManual || (expense.amount - transaction.amount).abs() > _amountTolerance) continue;
      final gap = _daysBetween(expense.date, transaction.date);
      if (gap < closestGap) {
        closest = expense;
        closestGap = gap;
      }
    }
    return closest;
  }

  void record(Expense expense, BankLink link) {
    relink(link);
    if (_expenses.containsKey(expense.id)) return _change(expense);
    _expenses[expense.id] = expense;
    _created[expense.id] = expense;
  }

  void recordRecurrence(Recurrence recurrence) {
    _recurrences[recurrence.id] = recurrence;
    _changedRecurrences[recurrence.id] = recurrence;
  }

  void relink(BankLink link) {
    if (_links[link.transactionId] == link) return;
    _links[link.transactionId] = link;
    _hasLinkChanges = true;
  }

  int dropVanishedPending({
    required String accountUid,
    required Set<String> seenTransactionIds,
    required DateTime from,
  }) {
    final vanished = _links.values.where(
      (link) => link.accountUid == accountUid && link.wasPending && !seenTransactionIds.contains(link.transactionId),
    );
    var removed = 0;
    for (final link in vanished.toList()) {
      final expense = _expenses[link.expenseId];
      if (expense != null && expense.date.isBefore(from)) continue;
      _links.remove(link.transactionId);
      _hasLinkChanges = true;
      if (expense == null) continue;
      if (link.kind == BankLinkKind.created) {
        _removeExpense(expense.id);
        removed++;
      } else {
        _change(expense.copyWith(bankTransactionId: () => null));
      }
    }
    return removed;
  }

  void _removeExpense(String id) {
    _expenses.remove(id);
    _changed.remove(id);
    if (_created.remove(id) == null) _removed.add(id);
  }

  void _change(Expense expense) {
    _expenses[expense.id] = expense;
    if (_created.containsKey(expense.id)) {
      _created[expense.id] = expense;
    } else {
      _changed[expense.id] = expense;
    }
  }

  static int _daysBetween(DateTime first, DateTime second) => DateTime.utc(
    first.year,
    first.month,
    first.day,
  ).difference(DateTime.utc(second.year, second.month, second.day)).inDays.abs();
}
