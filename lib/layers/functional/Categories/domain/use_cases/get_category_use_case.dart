import '../entities/category.dart';
import '../gateways/category_gateway.dart';

class GetCategoryUseCase {
  GetCategoryUseCase(this._categories);

  final CategoryGateway _categories;

  Category call(String key) => _categories.byKey(key);
}
