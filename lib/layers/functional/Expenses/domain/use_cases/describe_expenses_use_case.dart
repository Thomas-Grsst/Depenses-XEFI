import 'package:depenses/layers/functional/Categories/domain/use_cases/get_category_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/look_up_merchant_use_case.dart';

import '../entities/described_expense.dart';
import '../entities/expense.dart';

class DescribeExpensesUseCase {
  DescribeExpensesUseCase(this._getCategory, this._lookUpMerchant);

  final GetCategoryUseCase _getCategory;
  final LookUpMerchantUseCase _lookUpMerchant;

  List<DescribedExpense> call(Iterable<Expense> expenses) => [
    for (final expense in expenses)
      DescribedExpense(
        expense: expense,
        category: _getCategory(expense.categoryKey),
        look: _lookUpMerchant(expense.name, expense.categoryKey),
      ),
  ];
}
