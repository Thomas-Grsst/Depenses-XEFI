import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/hypothesis.dart';
import '../../domain/entities/merchant_badge.dart';
import '../l10n/simulations_labels.dart';
import '../l10n/simulations_locale.dart';
import 'simulations_badge.dart';

class SimulationHypothesisTitle extends StatelessWidget {
  const SimulationHypothesisTitle({super.key, required this.hypothesis, required this.badge, required this.onRemove});

  final Hypothesis hypothesis;
  final MerchantBadge badge;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final current = hypothesis.isNew
        ? context.tr(SimulationsLocale.newCharge)
        : context.trWith(SimulationsLocale.currentAmount, [
            context.amountWithFrequency(hypothesis.oldAmount, hypothesis.frequency),
          ]);
    return Row(
      children: [
        SimulationsBadge(badge: badge, size: graphite ? 34 : 32),
        SizedBox(width: graphite ? 14 : 10),
        Expanded(child: Text(hypothesis.name, style: tokens.ts(15, graphite ? FontWeight.w400 : FontWeight.w700))),
        Text(current, style: tokens.ts(13, tokens.wSemi, tokens.muted)),
        AppPressable(
          onTap: onRemove,
          semanticsLabel: context.tr(SimulationsLocale.removeHypothesis),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: AppIcon('close', size: 16, color: tokens.muted),
          ),
        ),
      ],
    );
  }
}
