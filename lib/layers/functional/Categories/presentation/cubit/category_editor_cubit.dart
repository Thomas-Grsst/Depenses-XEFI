import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/category_icons.dart';
import '../../domain/use_cases/add_category_use_case.dart';
import '../../domain/use_cases/delete_category_use_case.dart';
import '../../domain/use_cases/suggest_category_color_use_case.dart';
import '../../domain/use_cases/update_category_use_case.dart';
import 'category_editor_state.dart';
import 'category_editor_target.dart';

class CategoryEditorCubit extends Cubit<CategoryEditorState> {
  CategoryEditorCubit(
    this._addCategory,
    this._updateCategory,
    this._deleteCategory,
    SuggestCategoryColorUseCase suggestColor,
    CategoryEditorTarget target,
  ) : super(
        CategoryEditorState(
          category: target.category,
          icon: target.category?.icon ?? defaultCustomCategoryIcon,
          customColor: target.category?.customColor ?? suggestColor(target.paletteSize),
        ),
      );

  final AddCategoryUseCase _addCategory;
  final UpdateCategoryUseCase _updateCategory;
  final DeleteCategoryUseCase _deleteCategory;

  void selectIcon(String icon) => emit(state.copyWith(icon: icon));

  void selectColor(int customColor) => emit(state.copyWith(customColor: customColor));

  Future<void> save(String name) async {
    if (state.status != CategoryEditorStatus.editing) return;
    final trimmed = name.trim();
    final category = state.category;
    if (trimmed.isEmpty) return emit(state.copyWith(status: CategoryEditorStatus.closed));
    emit(state.copyWith(status: CategoryEditorStatus.saving));
    if (category == null) {
      final created = await _addCategory(name: trimmed, icon: state.icon, customColor: state.customColor);
      return _close(created.key);
    }
    await _updateCategory(category, name: trimmed, icon: state.icon, customColor: state.customColor);
    _close(category.key);
  }

  Future<void> delete() async {
    final category = state.category;
    if (category == null || state.status != CategoryEditorStatus.editing) return;
    emit(state.copyWith(status: CategoryEditorStatus.saving));
    await _deleteCategory(category);
    _close(null);
  }

  void _close(String? savedKey) {
    if (!isClosed) emit(state.copyWith(status: CategoryEditorStatus.closed, savedKey: savedKey));
  }
}
