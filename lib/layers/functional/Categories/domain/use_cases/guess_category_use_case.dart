import 'package:depenses/layers/technical/TextMatching/normalize_for_matching.dart';

import '../entities/category.dart';
import '../entities/merchant_brands.dart';
import '../entities/merchant_keywords.dart';
import 'look_up_merchant_use_case.dart';

const _minimumGuessableLength = 3;

class GuessCategoryUseCase {
  GuessCategoryUseCase(this._lookUp);

  final LookUpMerchantUseCase _lookUp;

  String? call(String name) {
    final normalized = normalizeForMatching(name);
    if (normalized.length < _minimumGuessableLength) return null;
    for (final brand in merchantBrandCategories.entries) {
      if (normalized.startsWith(brand.key)) return brand.value;
    }
    final look = _lookUp(name, Category.otherKey);
    if (look.isLetter) {
      final isKnownBrand = merchantBrandLetters.keys.any(normalized.startsWith);
      return isKnownBrand ? brandFallbackCategoryKey : null;
    }
    return categoryKeyByMerchantIcon[look.icon];
  }
}
