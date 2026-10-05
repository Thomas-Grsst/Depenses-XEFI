import 'package:depenses/layers/technical/TextMatching/normalize_for_matching.dart';

import '../entities/category.dart';
import '../entities/merchant_brands.dart';
import '../entities/merchant_keywords.dart';
import '../entities/merchant_look.dart';
import '../gateways/category_gateway.dart';

class LookUpMerchantUseCase {
  LookUpMerchantUseCase(this._categories);

  final CategoryGateway _categories;

  MerchantLook call(String name, String categoryKey) {
    final normalized = normalizeForMatching(name);
    final padded = ' $normalized ';
    for (final brand in merchantBrandLetters.entries) {
      if (normalized.startsWith(brand.key) || normalized.contains(' ${brand.key}')) {
        return MerchantLook.letter(brand.value);
      }
    }
    for (final entry in merchantKeywordsByIcon.entries) {
      if (entry.value.any(padded.contains)) return MerchantLook.icon(entry.key);
    }
    final trimmed = name.trim();
    if (categoryKey == Category.otherKey && trimmed.isNotEmpty) return MerchantLook.letter(trimmed[0].toUpperCase());
    return MerchantLook.icon(_categories.byKey(categoryKey).icon);
  }
}
