import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Localization/schedule_labels.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_item_row.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/hypothesis_badges.dart';
import '../l10n/simulations_locale.dart';
import 'simulation_hypothesis_choice.dart';
import 'simulations_badge.dart';

class SimulationAddHypothesisSheet extends StatelessWidget {
  const SimulationAddHypothesisSheet({
    super.key,
    required this.recurrences,
    required this.hasRecurrences,
    required this.badges,
  });

  final List<Recurrence> recurrences;
  final bool hasRecurrences;
  final HypothesisBadges badges;

  String _schedule(BuildContext context, Recurrence recurrence) => switch (recurrence.frequency) {
    Frequency.week => context.everyWeekOn(recurrence.start),
    Frequency.month => context.everyMonthOn(recurrence.start),
    Frequency.year => context.everyYearOn(recurrence.start),
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (recurrences.isNotEmpty) ...[
          AppSectionLabel(context.tr(SimulationsLocale.changeOrCut)),
          const SizedBox(height: 6),
          for (final recurrence in recurrences)
            AppRuled(
              child: AppItemRow(
                leading: SimulationsBadge(badge: badges.of(recurrence.name, recurrence.categoryKey), size: 36),
                title: recurrence.name,
                subtitle: _schedule(context, recurrence),
                trailing: context.money.euros(recurrence.amount),
                onTap: () => Navigator.pop(context, SimulationHypothesisChoice.recurrence(recurrence)),
              ),
            ),
          const SizedBox(height: 18),
        ],
        if (!hasRecurrences)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(context.tr(SimulationsLocale.noRecurrences), style: tokens.ts(13, tokens.wBody, tokens.muted)),
          ),
        AppButton.secondary(
          context.tr(SimulationsLocale.newMonthlyCharge),
          onTap: () => Navigator.pop(context, const SimulationHypothesisChoice.newCharge()),
        ),
      ],
    );
  }
}
