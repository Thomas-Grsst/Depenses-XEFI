import 'package:depenses/layers/technical/Storage/id_generator.dart';

import '../entities/category.dart';
import '../gateways/category_gateway.dart';

class AddCategoryUseCase {
  AddCategoryUseCase(this._categories, this._ids);

  final CategoryGateway _categories;
  final IdGenerator _ids;

  Future<Category> call({required String name, required String icon, required int customColor}) async {
    final category = Category.custom(key: 'c${_ids.next()}', name: name, icon: icon, customColor: customColor);
    await _categories.saveCustom([..._categories.custom(), category]);
    return category;
  }
}
