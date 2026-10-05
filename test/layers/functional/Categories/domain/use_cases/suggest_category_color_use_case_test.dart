import 'package:depenses/layers/functional/Categories/domain/use_cases/add_category_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/suggest_category_color_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() => dependencies = TestDependencies());
  tearDown(() => dependencies.dispose());

  test('cycles through the palette as custom categories are added', () async {
    final suggest = dependencies.get<SuggestCategoryColorUseCase>();
    final add = dependencies.get<AddCategoryUseCase>();

    expect(suggest(8), 0);
    await add(name: 'Animaux', icon: 'heart', customColor: 0);
    await add(name: 'Bébé', icon: 'gift', customColor: 1);
    expect(suggest(8), 2);
    expect(suggest(2), 0);
    expect(suggest(0), 0);
  });
}
