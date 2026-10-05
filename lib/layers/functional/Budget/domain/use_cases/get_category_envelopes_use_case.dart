import 'package:depenses/layers/functional/Categories/domain/gateways/category_gateway.dart';
import 'package:depenses/layers/functional/Forecast/domain/entities/month_stats.dart';

import '../entities/category_envelope.dart';

class GetCategoryEnvelopesUseCase {
  GetCategoryEnvelopesUseCase(this._categories);

  final CategoryGateway _categories;

  List<CategoryEnvelope> call(MonthStats stats) => [
    for (final category in _categories.all())
      CategoryEnvelope(category: category, stats: stats.categoryOf(category.key)),
  ];
}
