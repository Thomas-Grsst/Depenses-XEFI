import 'package:depenses/layers/technical/Localization/capitalize.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expenses_cubit.dart';
import '../l10n/expenses_locale.dart';
import 'expenses_month_sheet.dart';

class ExpensesMonthButton extends StatelessWidget {
  const ExpensesMonthButton({super.key, required this.month, required this.isCurrentYear});

  final DateTime month;
  final bool isCurrentYear;

  Future<void> _pickMonth(BuildContext context) async {
    final cubit = context.read<ExpensesCubit>();
    final picked = await AppSheet.show<DateTime>(
      context,
      title: context.tr(ExpensesLocale.pickMonth),
      closeLabel: context.tr(ExpensesLocale.close),
      builder: (_) => ExpensesMonthSheet(months: cubit.state.months),
    );
    if (picked != null) cubit.selectMonth(picked);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final label = isCurrentYear && isGraphite
        ? capitalize(context.dates.monthName(month))
        : context.dates.monthYear(month);
    return AppPressable(
      onTap: () => _pickMonth(context),
      child: Container(
        height: isGraphite ? 44 : 40,
        padding: isGraphite ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 14),
        decoration: isGraphite ? null : BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: tokens.ts(isGraphite ? 15 : 14, isGraphite ? FontWeight.w400 : FontWeight.w700)),
            const SizedBox(width: 6),
            AppIcon('chevD', size: isGraphite ? 14 : 16, color: tokens.ink, stroke: isGraphite ? 1.6 : 2),
          ],
        ),
      ),
    );
  }
}
