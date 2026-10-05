import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_toggle.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/goal.dart';
import '../../domain/entities/round_up_summary.dart';
import '../cubit/savings_cubit.dart';
import '../l10n/savings_locale.dart';
import 'savings_move_buttons.dart';
import 'savings_total_row.dart';

class SavingsRoundUpTotals extends StatelessWidget {
  const SavingsRoundUpTotals({super.key, required this.isRoundUpEnabled, required this.summary, required this.goals});

  final bool isRoundUpEnabled;
  final RoundUpSummary summary;
  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SavingsTotalRow(
          context.tr(SavingsLocale.roundUpToggle),
          trailing: AppToggle(value: isRoundUpEnabled, onChanged: context.read<SavingsCubit>().setRoundUpEnabled),
        ),
        SavingsTotalRow(
          context.tr(SavingsLocale.totalSaved),
          trailing: Text(money.euros(summary.total), style: tokens.ts(15, tokens.wStrong)),
        ),
        if (summary.used > 0)
          SavingsTotalRow(
            context.tr(SavingsLocale.alreadyMoved),
            trailing: Text(money.euros(summary.used), style: tokens.ts(15, tokens.wItem, tokens.muted)),
          ),
        SavingsTotalRow(
          context.tr(SavingsLocale.available),
          isStrong: true,
          isLast: true,
          trailing: Text(money.euros(summary.available), style: tokens.ts(17, tokens.wStrong, tokens.mint)),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (summary.available > 0 && goals.isNotEmpty)
          SavingsMoveButtons(available: summary.available, goals: goals)
        else if (summary.available > 0)
          Text(context.tr(SavingsLocale.createGoalHint), style: tokens.ts(12, tokens.wSemi, tokens.muted)),
      ],
    );
  }
}
