import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:depenses/layers/technical/Theme/spaced.dart';
import 'package:flutter/material.dart';

class SimulationsComparisonColumns extends StatelessWidget {
  const SimulationsComparisonColumns({super.key, required this.columns});

  final List<(String, String)> columns;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: graphite ? tokens.lineStrong : tokens.line)),
      ),
      child: Row(
        children: spaced([
          for (final (letter, title) in columns)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(letter, style: tokens.ts(graphite ? 15 : 13, graphite ? FontWeight.w400 : FontWeight.w800)),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.ts(11, tokens.wSemi, tokens.muted),
                  ),
                ],
              ),
            ),
        ], AppSpacing.sm),
      ),
    );
  }
}
