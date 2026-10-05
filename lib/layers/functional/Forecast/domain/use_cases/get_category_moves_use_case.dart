import 'package:depenses/layers/functional/Categories/domain/gateways/category_gateway.dart';

import '../entities/category_move.dart';
import '../entities/month_stats.dart';

class GetCategoryMovesUseCase {
  GetCategoryMovesUseCase(this._categories);

  final CategoryGateway _categories;

  List<CategoryMove> call(MonthStats stats) => [
    for (final category in _categories.all())
      if (stats.categoryOf(category.key).spent > 0 || stats.categoryOf(category.key).previousSameDay > 0)
        CategoryMove(
          categoryKey: category.key,
          current: stats.categoryOf(category.key).spent,
          previous: stats.categoryOf(category.key).previousSameDay,
        ),
  ];
}
