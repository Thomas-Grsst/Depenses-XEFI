import 'package:depenses/layers/functional/Budget/domain/entities/category_envelope.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/budget_locale.dart';

class BudgetEnvelopeNote extends StatelessWidget {
  const BudgetEnvelopeNote({super.key, required this.envelope, required this.day, required this.daysInMonth});

  final CategoryEnvelope envelope;
  final int day;
  final int daysInMonth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    final note = switch (envelope.status) {
      CategoryEnvelopeStatus.untrackedWithSpending => context.tr(BudgetLocale.noteUntrackedWithSpending),
      CategoryEnvelopeStatus.untracked => context.tr(BudgetLocale.noteUntracked),
      CategoryEnvelopeStatus.overspent => context.trWith(BudgetLocale.noteOverspent, [
        money.autoEuros(envelope.overspentBy),
      ]),
      CategoryEnvelopeStatus.projectedOverrun => context.trWith(BudgetLocale.noteProjectedOverrun, [
        money.percent(envelope.usedRatio),
        day,
        money.wholeEuros(envelope.projectedOverrun),
      ]),
      CategoryEnvelopeStatus.onTrack => context.trWith(BudgetLocale.noteOnTrack, [
        daysInMonth,
        money.wholeEuros(envelope.projected),
      ]),
    };
    return Text(note, style: tokens.ts(12, tokens.wSemi, envelope.isProjectedOver ? tokens.warn : tokens.muted));
  }
}
