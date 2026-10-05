import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/category.dart';
import '../l10n/categories_locale.dart';
import 'category_editor_body.dart';

class CategoryEditorSheet extends StatelessWidget {
  const CategoryEditorSheet({super.key, this.category});

  final Category? category;

  @override
  Widget build(BuildContext context) => AppSheet(
    title: CategoryEditorBody.titleOf(context, category),
    closeLabel: context.tr(CategoriesLocale.close),
    child: CategoryEditorBody(category: category),
  );
}
