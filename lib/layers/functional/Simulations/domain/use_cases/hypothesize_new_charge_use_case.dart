import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/guess_category_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';

import '../entities/hypothesis.dart';

class HypothesizeNewChargeUseCase {
  HypothesizeNewChargeUseCase(this._guessCategory);

  final GuessCategoryUseCase _guessCategory;

  Hypothesis? call({required String name, required double? monthlyAmount, required String fallbackName}) {
    if (monthlyAmount == null || monthlyAmount <= 0) return null;
    final trimmed = name.trim();
    final chargeName = trimmed.isEmpty ? fallbackName : trimmed;
    return Hypothesis(
      name: chargeName,
      categoryKey: _guessCategory(chargeName) ?? Category.otherKey,
      frequency: Frequency.month,
      oldAmount: 0,
      newAmount: monthlyAmount,
    );
  }
}
