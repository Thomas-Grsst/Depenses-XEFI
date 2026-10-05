import '../entities/category.dart';
import '../gateways/category_gateway.dart';

class GetCategoriesUseCase {
  GetCategoriesUseCase(this._categories);

  final CategoryGateway _categories;

  List<Category> call() => _categories.all();
}
