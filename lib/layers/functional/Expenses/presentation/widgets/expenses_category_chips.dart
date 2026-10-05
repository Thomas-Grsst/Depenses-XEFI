import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';

import 'expenses_category_chip.dart';

class ExpensesCategoryChips extends StatelessWidget {
  const ExpensesCategoryChips({super.key, required this.categories, required this.selectedKey});

  final List<Category> categories;
  final String? selectedKey;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: context.tokens.isGraphite ? 40 : 36,
    child: ListView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      children: spaced([
        for (final category in categories)
          ExpensesCategoryChip(category: category, isSelected: category.key == selectedKey),
      ], AppSpacing.sm),
    ),
  );
}
