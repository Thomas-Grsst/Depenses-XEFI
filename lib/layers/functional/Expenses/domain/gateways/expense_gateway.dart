import '../entities/expense.dart';

abstract class ExpenseGateway {
  List<Expense> all();

  List<Expense> inMonth(DateTime month);

  Future<void> add(Expense expense);

  Future<void> addAll(List<Expense> expenses);

  Future<void> update(Expense expense);

  Future<void> delete(String id);

  Future<void> reassignCategory({required String from, required String to});

  Future<void> removeLabel(String label);

  Future<void> linkToRecurrence(Iterable<String> expenseIds, String recurrenceId);

  Future<void> clear();
}
