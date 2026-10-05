import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_item_row.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';
import '../l10n/categories_locale.dart';
import '../views/category_editor_body.dart';
import 'category_badge.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final category in state.categories)
            AppRuled(
              child: AppItemRow(
                leading: CategoryBadge(category: category, size: 34),
                title: category.name,
                subtitle: context.tr(
                  category.isCustom ? CategoriesLocale.customSubtitle : CategoriesLocale.baseSubtitle,
                ),
                onTap: category.isCustom ? () => CategoryEditorBody.show(context, category: category) : null,
              ),
            ),
          const SizedBox(height: 14),
          AppButton.dashed(context.tr(CategoriesLocale.addCategory), onTap: () => CategoryEditorBody.show(context)),
          const SizedBox(height: 6),
          Text(
            context.tr(CategoriesLocale.baseCategoriesNote),
            textAlign: TextAlign.center,
            style: tokens.ts(12, tokens.wSemi, tokens.muted),
          ),
        ],
      ),
    );
  }
}
