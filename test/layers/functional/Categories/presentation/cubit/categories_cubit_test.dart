import 'package:depenses/layers/functional/Categories/domain/use_cases/add_category_use_case.dart';
import 'package:depenses/layers/functional/Categories/presentation/cubit/categories_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() => dependencies = TestDependencies());
  tearDown(() => dependencies.dispose());

  test('lists the categories and follows changes', () async {
    final cubit = dependencies.get<CategoriesCubit>();
    expect(cubit.state.categories.map((c) => c.key), ['log', 'ali', 'tra', 'loi', 'san', 'aut']);

    await dependencies.get<AddCategoryUseCase>()(name: 'Animaux', icon: 'heart', customColor: 2);

    expect(cubit.state.categories, hasLength(7));
    expect(cubit.state.categories[5].name, 'Animaux');
    await cubit.close();
  });
}
