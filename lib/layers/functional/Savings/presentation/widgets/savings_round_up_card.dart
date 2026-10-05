import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/round_up_summary.dart';
import '../l10n/savings_locale.dart';
import 'savings_round_up_card_graphite.dart';
import 'savings_round_up_card_menthe.dart';

class SavingsRoundUpCard extends StatelessWidget {
  const SavingsRoundUpCard({super.key, required this.summary, required this.month, this.lastRounded});

  final RoundUpSummary summary;
  final DateTime month;
  final Expense? lastRounded;

  String _details(BuildContext context) {
    if (summary.total <= 0) return '';
    final money = context.money;
    final last = lastRounded;
    return [
      context.trWith(SavingsLocale.sinceStart, [money.euros(summary.total)]),
      if (last != null)
        context.trWith(SavingsLocale.lastRounded, [money.euros(last.amount), money.wholeEuros(last.debited)]),
    ].join(context.tr(SavingsLocale.separator));
  }

  @override
  Widget build(BuildContext context) {
    final money = context.money;
    final amount = context.trWith(SavingsLocale.gain, [money.euros(summary.thisMonth)]);
    final monthName = context.dates.monthName(month);
    final details = _details(context);
    return AppPressable(
      onTap: () => openRoute<void>(context, AppRoute.roundUp),
      child: context.tokens.isGraphite
          ? SavingsRoundUpCardGraphite(
              label: context.trWith(SavingsLocale.cardLabelShort, [monthName.toUpperCase()]),
              amount: amount,
              details: details,
            )
          : SavingsRoundUpCardMenthe(
              label: context.trWith(SavingsLocale.cardLabel, [monthName]),
              amount: amount,
              details: details,
            ),
    );
  }
}
