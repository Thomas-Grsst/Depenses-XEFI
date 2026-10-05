import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_confirm_dialog.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_text_field.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/category.dart';
import '../cubit/category_editor_cubit.dart';
import '../l10n/categories_locale.dart';
import 'category_color_picker.dart';
import 'category_icon_picker.dart';

class CategoryEditorForm extends StatefulWidget {
  const CategoryEditorForm({super.key, this.category});

  final Category? category;

  @override
  State<CategoryEditorForm> createState() => _CategoryEditorFormState();
}

class _CategoryEditorFormState extends State<CategoryEditorForm> {
  late final _name = TextEditingController(text: widget.category?.name ?? '');

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(Category category) async {
    final cubit = context.read<CategoryEditorCubit>();
    final isConfirmed = await AppConfirmDialog.show(
      context,
      title: context.trWith(CategoriesLocale.deleteTitle, [category.name]),
      message: context.tr(CategoriesLocale.deleteMessage),
      confirmLabel: context.tr(CategoriesLocale.delete),
      cancelLabel: context.tr(CategoriesLocale.cancel),
    );
    if (isConfirmed) await cubit.delete();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          context.tr(CategoriesLocale.name),
          controller: _name,
          hint: context.tr(CategoriesLocale.nameHint),
          autofocus: category == null,
        ),
        const SizedBox(height: 18),
        AppSectionLabel(context.tr(CategoriesLocale.icon)),
        const SizedBox(height: AppSpacing.sm),
        const CategoryIconPicker(),
        const SizedBox(height: 18),
        AppSectionLabel(context.tr(CategoriesLocale.color)),
        const SizedBox(height: AppSpacing.sm),
        const CategoryColorPicker(),
        const SizedBox(height: 22),
        AppButton.primary(
          context.tr(CategoriesLocale.save),
          onTap: () => context.read<CategoryEditorCubit>().save(_name.text),
        ),
        if (category != null) ...[
          const SizedBox(height: 10),
          AppButton.secondary(
            context.tr(CategoriesLocale.deleteCategory),
            color: context.tokens.warn,
            onTap: () => _confirmDelete(category),
          ),
        ],
      ],
    );
  }
}
