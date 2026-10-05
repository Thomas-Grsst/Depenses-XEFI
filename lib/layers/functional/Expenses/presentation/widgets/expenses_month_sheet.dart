import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/month_spending.dart';

class ExpensesMonthSheet extends StatelessWidget {
  const ExpensesMonthSheet({super.key, required this.months});

  final List<MonthSpending> months;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      children: [
        for (final spending in months)
          AppRuled(
            child: AppPressable(
              onTap: () => Navigator.pop(context, spending.month),
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(child: Text(context.dates.monthYear(spending.month), style: tokens.ts(16, tokens.wItem))),
                    Text(context.money.euros(spending.total), style: tokens.ts(14, tokens.wSemi, tokens.muted)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
