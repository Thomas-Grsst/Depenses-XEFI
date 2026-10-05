import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';

class SimulationsMetricRow extends StatelessWidget {
  const SimulationsMetricRow({super.key, required this.label, required this.cells});

  final String label;
  final List<(String, bool)> cells;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    FontWeight weightOf(bool isBest) =>
        isBest ? (graphite ? FontWeight.w500 : FontWeight.w800) : (graphite ? FontWeight.w400 : FontWeight.w600);
    return Container(
      padding: EdgeInsets.symmetric(vertical: graphite ? 12 : 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: tokens.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            graphite ? label.toUpperCase() : label,
            style: graphite ? tokens.mono(10, tokens.faint) : tokens.ts(12, FontWeight.w700, tokens.muted),
          ),
          const SizedBox(height: 6),
          Row(
            children: spaced([
              for (final (value, isBest) in cells)
                Expanded(child: Text(value, style: tokens.ts(14, weightOf(isBest), isBest ? tokens.mint : tokens.ink))),
            ], AppSpacing.sm),
          ),
        ],
      ),
    );
  }
}
