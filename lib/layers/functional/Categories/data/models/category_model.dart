import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/entities/category.dart';

abstract final class CategoryModel {
  static Category fromJson(Map<String, dynamic> json) => Category.custom(
    key: json.text('key'),
    name: json.text('name'),
    icon: json.text('kind', fallback: 'dots'),
    customColor: json.integer('color'),
  );

  static Map<String, dynamic> toJson(Category category) => {
    'key': category.key,
    'name': category.name,
    'kind': category.icon,
    'color': category.customColor,
  };
}
