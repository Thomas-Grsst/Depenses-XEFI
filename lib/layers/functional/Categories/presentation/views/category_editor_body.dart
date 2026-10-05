import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/category.dart';
import '../cubit/category_editor_cubit.dart';
import '../cubit/category_editor_state.dart';
import '../cubit/category_editor_target.dart';
import '../l10n/categories_locale.dart';
import '../widgets/category_editor_form.dart';

class CategoryEditorBody extends StatelessWidget {
  const CategoryEditorBody({super.key, this.category});

  final Category? category;

  static String titleOf(BuildContext context, Category? category) =>
      context.tr(category == null ? CategoriesLocale.newCategory : CategoriesLocale.category);

  static Future<String?> show(BuildContext context, {Category? category}) => AppSheet.show<String>(
    context,
    title: titleOf(context, category),
    closeLabel: context.tr(CategoriesLocale.close),
    builder: (_) => CategoryEditorBody(category: category),
  );

  @override
  Widget build(BuildContext context) {
    final target = CategoryEditorTarget(category: category, paletteSize: context.tokens.customSwatches.length);
    return BlocProvider(
      create: (_) => GetIt.I<CategoryEditorCubit>(param1: target),
      child: BlocListener<CategoryEditorCubit, CategoryEditorState>(
        listenWhen: (previous, current) => current.status == CategoryEditorStatus.closed,
        listener: (context, state) => Navigator.pop(context, state.savedKey),
        child: CategoryEditorForm(category: category),
      ),
    );
  }
}
