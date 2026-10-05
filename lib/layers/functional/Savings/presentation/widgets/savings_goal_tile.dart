import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_progress_bar.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/goal.dart';
import '../l10n/savings_locale.dart';
import 'savings_goal_eta.dart';

class SavingsGoalTile extends StatelessWidget {
  const SavingsGoalTile({super.key, required this.goal, required this.today, required this.onTap});

  final Goal goal;
  final DateTime today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final money = context.money;
    final format = graphite ? money.wholeNumber : money.wholeEuros;
    final targetStyle = graphite
        ? TextStyle(color: tokens.faint)
        : TextStyle(color: tokens.muted, fontWeight: FontWeight.w600);
    return AppPressable(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  goal.name,
                  style: tokens.ts(graphite ? 15 : 16, graphite ? FontWeight.w400 : FontWeight.w800),
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: format(goal.saved)),
                    TextSpan(text: context.trWith(SavingsLocale.goalTarget, [format(goal.target)]), style: targetStyle),
                  ],
                ),
                style: graphite ? tokens.mono(13) : tokens.ts(14, FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: graphite ? 12 : 10),
          AppProgressBar(goal.target > 0 ? goal.saved / goal.target : 0, height: 10, dot: true),
          SizedBox(height: graphite ? 12 : 8),
          Text(savingsGoalSubtitle(context, goal, today), style: tokens.ts(13, tokens.wSemi, tokens.muted)),
        ],
      ),
    );
  }
}
