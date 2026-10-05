import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_text_link.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/savings_goals_cubit.dart';
import '../cubit/savings_goals_state.dart';
import '../l10n/savings_locale.dart';
import 'savings_goal_sheet.dart';
import 'savings_goal_tile.dart';

class SavingsGoalsList extends StatelessWidget {
  const SavingsGoalsList({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return BlocBuilder<SavingsGoalsCubit, SavingsGoalsState>(
      builder: (context, state) {
        final goals = state.goals;
        final today = state.today;
        if (today == null) return const SizedBox.shrink();
        final tiles = [
          for (final goal in goals)
            SavingsGoalTile(
              goal: goal,
              today: today,
              onTap: () => SavingsGoalSheet.edit(context, goal: goal),
            ),
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSectionLabel(
              context.tr(SavingsLocale.goalsTitle),
              trailing: AppTextLink(
                context.tr(graphite ? SavingsLocale.newGoalShort : SavingsLocale.newGoal),
                onTap: () => SavingsGoalSheet.edit(context),
              ),
            ),
            SizedBox(height: graphite ? 6 : 8),
            if (goals.isEmpty)
              AppPanel(
                child: AppRuled(
                  bottom: true,
                  child: Text(
                    context.tr(SavingsLocale.goalsEmpty),
                    style: tokens.ts(14, tokens.wBody, tokens.muted).copyWith(height: 1.45),
                  ),
                ),
              ),
            if (graphite)
              for (var i = 0; i < tiles.length; i++)
                AppRuled(verticalPadding: 16, bottom: i == tiles.length - 1, child: tiles[i])
            else
              ...spaced([for (final tile in tiles) AppPanel(child: tile)], 8),
          ],
        );
      },
    );
  }
}
