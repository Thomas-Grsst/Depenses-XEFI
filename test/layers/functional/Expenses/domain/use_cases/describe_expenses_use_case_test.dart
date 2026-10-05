import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/describe_expenses_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../expenses_seed.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() => dependencies = TestDependencies());
  tearDown(() => dependencies.dispose());

  test('attaches the category and the merchant look of each expense', () async {
    final netflix = await seedExpense(dependencies, name: 'Netflix', categoryKey: 'loi');
    final groceries = await seedExpense(dependencies, name: 'Carrefour', categoryKey: 'ali');

    final described = dependencies.get<DescribeExpensesUseCase>()([netflix, groceries]);

    expect(described.map((d) => d.category.name), ['Loisirs', 'Alimentation']);
    expect(described.first.look, const MerchantLook.letter('N'));
    expect(described.last.look, const MerchantLook.icon('cart'));
  });

  test('falls back to the other category for an unknown key', () async {
    final expense = await seedExpense(dependencies, name: 'Truc', categoryKey: 'gone');

    final described = dependencies.get<DescribeExpensesUseCase>()([expense]);

    expect(described.single.category.key, 'aut');
  });
}
