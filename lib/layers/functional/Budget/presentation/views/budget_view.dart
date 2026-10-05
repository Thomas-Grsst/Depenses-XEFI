import 'package:depenses/layers/technical/Theme/app_page_list.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/budget_cubit.dart';
import '../cubit/budget_state.dart';
import '../widgets/budget_category_envelope_list.dart';
import '../widgets/budget_header.dart';
import '../widgets/budget_hero.dart';
import '../widgets/budget_label_section.dart';
import '../widgets/budget_simulation_link.dart';

class BudgetView extends StatelessWidget {
  const BudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGraphite = tokens.isGraphite;
    return Scaffold(
      backgroundColor: tokens.bg,
      body: BlocBuilder<BudgetCubit, BudgetState>(
        builder: (context, state) {
          final stats = state.stats;
          if (stats == null) return const SizedBox.shrink();
          return AppPageList(
            gap: isGraphite ? 30 : 14,
            children: [
              BudgetHeader(month: stats.month),
              BudgetHero(stats: stats, margin: state.margin, hasBudget: state.hasBudget),
              if (!isGraphite) const BudgetSimulationLink(),
              if (state.categoryEnvelopes.isNotEmpty)
                BudgetCategoryEnvelopeList(envelopes: state.categoryEnvelopes, stats: stats),
              BudgetLabelSection(envelopes: state.labelEnvelopes),
              if (isGraphite) const BudgetSimulationLink(),
            ],
          );
        },
      ),
    );
  }
}
