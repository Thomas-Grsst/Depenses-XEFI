import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_toggle.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/hypothesis.dart';
import '../../domain/entities/merchant_badge.dart';
import '../cubit/simulation_cubit.dart';
import '../l10n/simulations_locale.dart';
import 'simulation_hypothesis_amount.dart';
import 'simulation_hypothesis_title.dart';

const _disabledOpacity = 0.35;

class SimulationHypothesisCard extends StatelessWidget {
  const SimulationHypothesisCard({super.key, required this.index, required this.hypothesis, required this.badge});

  final int index;
  final Hypothesis hypothesis;
  final MerchantBadge badge;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final cubit = context.read<SimulationCubit>();
    final card = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SimulationHypothesisTitle(hypothesis: hypothesis, badge: badge, onRemove: () => cubit.remove(index)),
        SizedBox(height: graphite ? 16 : 12),
        Opacity(
          opacity: hypothesis.isKept ? 1 : _disabledOpacity,
          child: SimulationHypothesisAmount(
            hypothesis: hypothesis,
            onStep: (direction) => cubit.step(index, direction),
            onSlide: (amount) => cubit.slide(index, amount),
          ),
        ),
        if (!hypothesis.isNew)
          Row(
            children: [
              Expanded(
                child: Text(
                  context.trWith(SimulationsLocale.keepName, [hypothesis.name]),
                  style: tokens.ts(14, tokens.wSemi, tokens.muted),
                ),
              ),
              AppToggle(value: hypothesis.isKept, onChanged: (isKept) => cubit.keep(index, isKept)),
            ],
          ),
      ],
    );
    return graphite ? AppRuled(verticalPadding: 18, child: card) : AppPanel(child: card);
  }
}
