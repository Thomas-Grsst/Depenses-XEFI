import 'package:depenses/layers/functional/Budget/domain/gateways/envelope_gateway.dart';
import 'package:depenses/layers/functional/Categories/domain/gateways/category_gateway.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/add_category_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/delete_category_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/guess_category_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/look_up_merchant_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      data: {
        'expenses': [
          {'id': 'e', 'name': 'Croquettes', 'amount': 20, 'date': '2026-10-01', 'cat': 'cpet', 'labels': <String>[]},
        ],
        'envelopes': {'cpet': 30.0, 'aut': 10.0},
        'cats': [
          {'key': 'cpet', 'name': 'Animaux de compagnie', 'kind': 'heart', 'color': 2},
        ],
      },
    );
  });
  tearDown(() => dependencies.dispose());

  test('custom categories are listed before others and keep their colour', () {
    final categories = dependencies.get<CategoryGateway>().all();

    expect(categories.map((c) => c.key), ['log', 'ali', 'tra', 'loi', 'san', 'cpet', 'aut']);
    expect(categories[5].shortName, 'Animaux.');
    expect(categories[5].colorIndex, 8);
  });

  test('a new category gets a generated key', () async {
    final category = await dependencies.get<AddCategoryUseCase>()(name: 'Bébé', icon: 'gift', customColor: 1);

    expect(category.key, 'cid1');
    expect(dependencies.get<CategoryGateway>().byKey('cid1').name, 'Bébé');
  });

  test('deleting a category moves its expenses and envelope to others', () async {
    final pets = dependencies.get<CategoryGateway>().byKey('cpet');

    await dependencies.get<DeleteCategoryUseCase>()(pets);

    expect(dependencies.get<ExpenseGateway>().all().single.categoryKey, 'aut');
    expect(dependencies.get<EnvelopeGateway>().all(), {'aut': 40.0});
    expect(dependencies.get<CategoryGateway>().custom(), isEmpty);
  });

  test('merchants are recognised by brand, keyword, or fall back to their initial', () {
    final lookUp = dependencies.get<LookUpMerchantUseCase>();

    expect(lookUp('Netflix', 'loi').letter, 'N');
    expect(lookUp('Courses Carrefour', 'ali').icon, 'cart');
    expect(lookUp('zorglub', 'aut').letter, 'Z');
    expect(lookUp('zorglub', 'tra').icon, 'car');
  });

  test('the category is guessed from the merchant name', () {
    final guess = dependencies.get<GuessCategoryUseCase>();

    expect(guess('Uber'), 'tra');
    expect(guess('Pharmacie du centre'), 'san');
    expect(guess('Spotify'), 'loi');
    expect(guess('ab'), isNull);
    expect(guess('zorglub'), isNull);
  });
}
