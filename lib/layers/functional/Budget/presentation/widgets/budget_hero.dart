import 'package:depenses/layers/functional/Forecast/domain/entities/month_stats.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import 'budget_graphite_hero.dart';
import 'budget_intro_panel.dart';
import 'budget_menthe_hero.dart';

class BudgetHero extends StatelessWidget {
  const BudgetHero({super.key, required this.stats, required this.margin, required this.hasBudget});

  final MonthStats stats;
  final double margin;
  final bool hasBudget;

  @override
  Widget build(BuildContext context) {
    if (!hasBudget) return const BudgetIntroPanel();
    if (context.tokens.isGraphite) return BudgetGraphiteHero(stats: stats, margin: margin);
    return BudgetMentheHero(stats: stats, margin: margin);
  }
}
