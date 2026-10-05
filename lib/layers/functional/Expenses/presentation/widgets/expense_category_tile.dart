import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expense_editor_cubit.dart';
import 'expense_badge.dart';

class ExpenseCategoryTile extends StatelessWidget {
  const ExpenseCategoryTile({super.key, required this.category, required this.isSelected});

  final Category category;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppPressable(
      onTap: () => context.read<ExpenseEditorCubit>().selectCategory(category.key),
      onLongPress: category.isCustom
          ? () => openRoute<String>(context, AppRoute.editCategory, arguments: category)
          : null,
      semanticsLabel: category.name,
      child: tokens.isGraphite
          ? Column(
              children: [
                ExpenseBadge.category(category: category, size: 44, selected: isSelected),
                const SizedBox(height: 6),
                Text(
                  category.shortName,
                  maxLines: 1,
                  style: tokens.ts(10, FontWeight.w400, isSelected ? tokens.ink : tokens.muted),
                ),
              ],
            )
          : AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: tokens.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? tokens.ink : Colors.transparent, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ExpenseBadge.category(category: category, size: 36),
                  const SizedBox(height: 6),
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.ts(12, FontWeight.w700),
                  ),
                ],
              ),
            ),
    );
  }
}
