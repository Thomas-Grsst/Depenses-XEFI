import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Theme/app_icon_badge.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class BudgetCategoryBadge extends StatelessWidget {
  const BudgetCategoryBadge({super.key, required this.category, this.size = 40});

  final Category category;
  final double size;

  @override
  Widget build(BuildContext context) =>
      AppIconBadge(icon: category.icon, color: context.tokens.swatch(category.colorIndex), size: size);
}
