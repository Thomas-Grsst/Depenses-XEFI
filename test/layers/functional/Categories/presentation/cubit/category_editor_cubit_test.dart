import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/add_category_use_case.dart';
import 'package:depenses/layers/functional/Categories/domain/use_cases/get_categories_use_case.dart';
import 'package:depenses/layers/functional/Categories/presentation/cubit/category_editor_cubit.dart';
import 'package:depenses/layers/functional/Categories/presentation/cubit/category_editor_state.dart';
import 'package:depenses/layers/functional/Categories/presentation/cubit/category_editor_target.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() => dependencies = TestDependencies());
  tearDown(() => dependencies.dispose());

  CategoryEditorCubit buildCubit([Category? category]) =>
      dependencies.getIt<CategoryEditorCubit>(param1: CategoryEditorTarget(category: category, paletteSize: 8));

  List<Category> custom() => dependencies.get<GetCategoriesUseCase>()().where((c) => c.isCustom).toList();

  test('creates a category with the picked icon and colour', () async {
    final cubit = buildCubit();
    expect(cubit.state.icon, 'gift');
    expect(cubit.state.customColor, 0);

    cubit
      ..selectIcon('plane')
      ..selectColor(3);
    await cubit.save('  Voyages ');

    expect(cubit.state.status, CategoryEditorStatus.closed);
    expect(cubit.state.savedKey, custom().single.key);
    expect(custom().single.name, 'Voyages');
    expect(custom().single.icon, 'plane');
    expect(custom().single.customColor, 3);
    await cubit.close();
  });

  test('closes without saving a blank name', () async {
    final cubit = buildCubit();

    await cubit.save('   ');

    expect(cubit.state.status, CategoryEditorStatus.closed);
    expect(cubit.state.savedKey, isNull);
    expect(custom(), isEmpty);
    await cubit.close();
  });

  test('updates then deletes an existing category', () async {
    final existing = await dependencies.get<AddCategoryUseCase>()(name: 'Animaux', icon: 'heart', customColor: 1);
    final editor = buildCubit(existing);
    expect(editor.state.customColor, 1);

    await editor.save('Chats');
    expect(editor.state.savedKey, existing.key);
    expect(custom().single.name, 'Chats');
    await editor.close();

    final deleter = buildCubit(custom().single);
    await deleter.delete();
    expect(deleter.state.status, CategoryEditorStatus.closed);
    expect(custom(), isEmpty);
    await deleter.close();
  });
}
