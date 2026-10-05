import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/default_categories.dart';
import '../../domain/gateways/category_gateway.dart';
import '../models/category_model.dart';

class CategoryGatewayImpl implements CategoryGateway {
  CategoryGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  List<Category> all() => [
    ...defaultCategories.where((c) => c.key != Category.otherKey),
    ...custom(),
    defaultCategories.last,
  ];

  @override
  List<Category> custom() => [
    for (final json in jsonRecords(_store.read(LedgerSection.categories))) CategoryModel.fromJson(json),
  ];

  @override
  Category byKey(String key) => all().firstWhere((c) => c.key == key, orElse: () => defaultCategories.last);

  @override
  Future<void> saveCustom(List<Category> categories) =>
      _store.write(LedgerSection.categories, [for (final c in categories) CategoryModel.toJson(c)]);
}
