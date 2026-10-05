import '../entities/category.dart';

abstract class CategoryGateway {
  List<Category> all();

  List<Category> custom();

  Category byKey(String key);

  Future<void> saveCustom(List<Category> categories);
}
