import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_key_figure.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/app_two_up.dart';
import 'package:flutter/material.dart';

import '../l10n/recurrences_locale.dart';

class RecurrencesKeyFigures extends StatelessWidget {
  const RecurrencesKeyFigures({
    super.key,
    required this.fixedMonthly,
    required this.remainingThisMonth,
    required this.month,
  });

  final double fixedMonthly;
  final double remainingThisMonth;
  final DateTime? month;

  @override
  Widget build(BuildContext context) {
    final isGraphite = context.tokens.isGraphite;
    final money = context.money;
    final shownMonth = month;
    final remainingLabel = isGraphite || shownMonth == null
        ? context.tr(RecurrencesLocale.remainingShort)
        : context.trWith(RecurrencesLocale.remainingInMonth, [context.dates.shortMonthName(shownMonth)]);
    return AppTwoUp(
      AppKeyFigure.hero(
        context.tr(isGraphite ? RecurrencesLocale.fixedPerMonthShort : RecurrencesLocale.fixedPerMonth),
        amount: money.decimals(fixedMonthly),
        amountWithCurrency: money.euros(fixedMonthly),
      ),
      AppKeyFigure(
        remainingLabel,
        amount: money.decimals(remainingThisMonth),
        amountWithCurrency: money.euros(remainingThisMonth),
      ),
    );
  }
}
