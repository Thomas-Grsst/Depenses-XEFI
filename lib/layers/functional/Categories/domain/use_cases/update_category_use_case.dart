import '../entities/category.dart';
import '../gateways/category_gateway.dart';

class UpdateCategoryUseCase {
  UpdateCategoryUseCase(this._categories);

  final CategoryGateway _categories;

  Future<void> call(Category category, {required String name, required String icon, required int customColor}) =>
      _categories.saveCustom([
        for (final existing in _categories.custom())
          existing.key == category.key
              ? Category.custom(key: existing.key, name: name, icon: icon, customColor: customColor)
              : existing,
      ]);
}
