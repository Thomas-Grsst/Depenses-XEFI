import '../gateways/category_gateway.dart';

class SuggestCategoryColorUseCase {
  SuggestCategoryColorUseCase(this._categories);

  final CategoryGateway _categories;

  int call(int paletteSize) => paletteSize <= 0 ? 0 : _categories.custom().length % paletteSize;
}
