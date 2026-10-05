import 'package:depenses/layers/functional/Categories/domain/use_cases/get_category_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/look_up_merchant_use_case.dart';

import '../entities/hypothesis_badges.dart';
import '../entities/merchant_badge.dart';

class DescribeHypothesisBadgesUseCase {
  DescribeHypothesisBadgesUseCase(this._category, this._lookUp);

  final GetCategoryUseCase _category;
  final LookUpMerchantUseCase _lookUp;

  HypothesisBadges call(Iterable<(String, String)> namesAndCategories) => HypothesisBadges({
    for (final (name, categoryKey) in namesAndCategories)
      (name, categoryKey): MerchantBadge(
        colorIndex: _category(categoryKey).colorIndex,
        look: _lookUp(name, categoryKey),
      ),
  });
}
