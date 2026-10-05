import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/hypothesis.dart';
import '../../domain/entities/hypothesis_scale.dart';
import '../l10n/simulations_labels.dart';
import '../l10n/simulations_locale.dart';
import 'simulation_step_button.dart';

const _negligibleAmount = 0.005;
const _changeThreshold = 0.004;
const _overlayAlpha = 0.12;

class SimulationHypothesisAmount extends StatelessWidget {
  const SimulationHypothesisAmount({super.key, required this.hypothesis, required this.onStep, required this.onSlide});

  final Hypothesis hypothesis;
  final ValueChanged<int> onStep;
  final ValueChanged<double> onSlide;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final delta = hypothesis.monthlyDelta;
    final deltaText = delta.abs() < _negligibleAmount
        ? context.tr(SimulationsLocale.unchanged)
        : context.trWith(SimulationsLocale.amountPerMonth, [context.money.withSign(delta, context.money.wholeEuros)]);
    final deltaColor = delta > _changeThreshold
        ? tokens.warn
        : (delta < -_changeThreshold ? tokens.mint : tokens.muted);
    final maximum = HypothesisScale.of(hypothesis).maximum;
    final accent = graphite ? tokens.fab : tokens.mint;
    final isEditable = hypothesis.isKept;
    return Column(
      children: [
        Row(
          children: [
            SimulationStepButton(
              icon: 'minus',
              semanticsLabel: context.tr(SimulationsLocale.decrease),
              onTap: isEditable ? () => onStep(-1) : null,
            ),
            Expanded(
              child: Column(
                children: [
                  FittedBox(
                    child: Text(
                      context.amountWithFrequency(hypothesis.newAmount, hypothesis.frequency),
                      style: tokens
                          .ts(graphite ? 52 : 34, graphite ? FontWeight.w300 : FontWeight.w800)
                          .copyWith(letterSpacing: graphite ? -2 : -0.7, height: 1.1),
                    ),
                  ),
                  Text(deltaText, style: tokens.ts(13, graphite ? FontWeight.w400 : FontWeight.w800, deltaColor)),
                ],
              ),
            ),
            SimulationStepButton(
              icon: 'plus',
              semanticsLabel: context.tr(SimulationsLocale.increase),
              onTap: isEditable ? () => onStep(1) : null,
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: accent,
            inactiveTrackColor: graphite ? tokens.lineStrong : tokens.track,
            thumbColor: accent,
            overlayColor: accent.withValues(alpha: _overlayAlpha),
            trackHeight: graphite ? 2 : 4,
          ),
          child: Slider(
            value: hypothesis.newAmount.clamp(0, maximum).toDouble(),
            max: maximum,
            onChanged: isEditable ? onSlide : null,
          ),
        ),
      ],
    );
  }
}
