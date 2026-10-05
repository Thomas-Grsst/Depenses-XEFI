import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/default_categories.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:equatable/equatable.dart';

class MerchantBadges extends Equatable {
  const MerchantBadges({this.categories = const {}, this.looks = const {}});

  final Map<String, Category> categories;
  final Map<(String, String), MerchantLook> looks;

  Category categoryOf(String key) => categories[key] ?? categories[Category.otherKey] ?? defaultCategories.last;

  MerchantLook lookOf(String name, String categoryKey) =>
      looks[(name, categoryKey)] ?? MerchantLook.icon(categoryOf(categoryKey).icon);

  @override
  List<Object?> get props => [categories, looks];
}
