import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import 'simulation_result_line.dart';
import 'simulation_trend.dart';
import 'simulations_tag.dart';

const _graphiteArrow = '→';

class SimulationResultRow extends StatelessWidget {
  const SimulationResultRow({super.key, required this.line});

  final SimulationResultLine line;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final chipColor = switch (line.trend) {
      SimulationTrend.worse => tokens.warn,
      SimulationTrend.better => tokens.mint,
      SimulationTrend.neutral => tokens.muted,
    };
    final chipBackground = switch (line.trend) {
      SimulationTrend.worse => tokens.warnSoft,
      SimulationTrend.better => tokens.mintSoft,
      SimulationTrend.neutral => tokens.chip,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                line.label,
                style: graphite ? tokens.ts(13, FontWeight.w400, tokens.muted) : tokens.ts(14, FontWeight.w700),
              ),
            ),
            if (graphite)
              Text(line.change, style: tokens.mono(11, chipColor))
            else
              SimulationsTag(
                line.change,
                color: chipColor,
                background: chipBackground,
                weight: FontWeight.w800,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Flexible(
              child: Text(
                line.before,
                style: tokens.ts(graphite ? 15 : 14, tokens.wSemi, graphite ? tokens.faint : tokens.muted),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: graphite
                  ? Text(_graphiteArrow, style: tokens.ts(15, FontWeight.w400, tokens.faint))
                  : AppIcon('arrowR', size: 14, color: tokens.muted),
            ),
            Flexible(
              child: Text(
                line.after,
                style: tokens.ts(graphite ? 15 : 14, graphite ? FontWeight.w400 : FontWeight.w800),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
