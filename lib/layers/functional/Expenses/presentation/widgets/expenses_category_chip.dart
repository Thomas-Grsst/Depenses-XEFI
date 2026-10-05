import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expenses_cubit.dart';
import 'expense_badge.dart';

class ExpensesCategoryChip extends StatelessWidget {
  const ExpensesCategoryChip({super.key, required this.category, required this.isSelected});

  final Category category;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final Color background, border;
    if (isGraphite) {
      background = isSelected ? tokens.fab : Colors.transparent;
      border = isSelected ? tokens.fab : tokens.lineStrong;
    } else {
      background = tokens.card;
      border = isSelected ? tokens.ink : Colors.transparent;
    }
    final foreground = isGraphite && isSelected ? tokens.fabInk : tokens.ink;
    return AppPressable(
      onTap: () => context.read<ExpensesCubit>().toggleCategory(category.key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.fromLTRB(5, AppSpacing.xs, AppSpacing.md, AppSpacing.xs),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border, width: isGraphite ? 1 : 1.5),
        ),
        child: Row(
          children: [
            if (isGraphite)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: AppIcon(category.icon, size: 16, color: foreground),
              )
            else
              ExpenseBadge.category(category: category, size: 26),
            const SizedBox(width: AppSpacing.sm),
            Text(category.name, style: tokens.ts(13, isGraphite ? FontWeight.w400 : FontWeight.w600, foreground)),
          ],
        ),
      ),
    );
  }
}
