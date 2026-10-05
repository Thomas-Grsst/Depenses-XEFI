import 'package:depenses/layers/functional/Budget/domain/gateways/envelope_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Recurrences/domain/gateways/recurrence_gateway.dart';

import '../entities/category.dart';
import '../gateways/category_gateway.dart';

class DeleteCategoryUseCase {
  DeleteCategoryUseCase(this._categories, this._expenses, this._recurrences, this._envelopes);

  final CategoryGateway _categories;
  final ExpenseGateway _expenses;
  final RecurrenceGateway _recurrences;
  final EnvelopeGateway _envelopes;

  Future<void> call(Category category) async {
    await _expenses.reassignCategory(from: category.key, to: Category.otherKey);
    await _recurrences.reassignCategory(from: category.key, to: Category.otherKey);
    await _envelopes.mergeInto(from: category.key, to: Category.otherKey);
    await _categories.saveCustom(_categories.custom().where((c) => c.key != category.key).toList());
  }
}
