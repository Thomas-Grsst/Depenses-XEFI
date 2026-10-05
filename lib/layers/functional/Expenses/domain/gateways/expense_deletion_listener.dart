import '../entities/expense.dart';

abstract class ExpenseDeletionListener {
  Future<void> call(Expense deleted);
}
