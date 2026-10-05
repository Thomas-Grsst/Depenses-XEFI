import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expense_editor_cubit.dart';
import '../l10n/expenses_locale.dart';

class ExpenseNewCategoryTile extends StatelessWidget {
  const ExpenseNewCategoryTile({super.key});

  Future<void> _createCategory(BuildContext context) async {
    final cubit = context.read<ExpenseEditorCubit>();
    final key = await openRoute<String>(context, AppRoute.newCategory);
    if (key != null) cubit.selectCategory(key);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final label = context.tr(ExpensesLocale.newCategory);
    return AppPressable(
      onTap: () => _createCategory(context),
      semanticsLabel: context.tr(ExpensesLocale.newCategoryHint),
      child: isGraphite
          ? Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: tokens.faint),
                  ),
                  child: AppIcon('plus', size: 20, color: tokens.muted),
                ),
                const SizedBox(height: 6),
                Text(label, style: tokens.ts(10, FontWeight.w400, tokens.muted)),
              ],
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: tokens.off, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcon('plus', size: 22, color: tokens.muted),
                  const SizedBox(height: 6),
                  Text(label, style: tokens.ts(12, FontWeight.w700, tokens.muted)),
                ],
              ),
            ),
    );
  }
}
