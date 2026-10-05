import 'package:depenses/layers/technical/Localization/capitalize.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_back_header.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_small_button.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/budget_locale.dart';
import 'budget_envelopes_sheet.dart';

class BudgetHeader extends StatelessWidget {
  const BudgetHeader({super.key, required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    final monthName = context.dates.monthName(month);
    final editLabel = context.tr(BudgetLocale.edit);
    void edit() => BudgetEnvelopesSheet.open(context);
    return AppBackHeader(
      context.trWith(BudgetLocale.title, [isGraphite ? capitalize(monthName) : monthName]),
      backLabel: context.tr(BudgetLocale.back),
      trailing: isGraphite
          ? AppPressable(
              onTap: edit,
              child: Text(editLabel, style: tokens.ts(13, FontWeight.w400, tokens.muted)),
            )
          : AppSmallButton.secondary(editLabel, onTap: edit),
    );
  }
}
