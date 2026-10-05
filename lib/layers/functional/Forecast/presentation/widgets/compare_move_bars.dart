import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class CompareMoveBars extends StatelessWidget {
  const CompareMoveBars({super.key, required this.delta, required this.share});

  final double delta;
  final double share;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return LayoutBuilder(
      builder: (context, constraints) {
        final half = constraints.maxWidth / 2;
        return SizedBox(
          height: graphite ? 3 : 10,
          child: Row(
            children: [
              SizedBox(
                width: half,
                child: Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: graphite ? tokens.ghost : tokens.lineStrong)),
                  ),
                  child: Container(
                    width: delta < 0 ? half * share : 0,
                    decoration: BoxDecoration(
                      color: tokens.good,
                      borderRadius: graphite ? null : const BorderRadius.horizontal(left: Radius.circular(5)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: half,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: delta > 0 ? half * share : 0,
                    decoration: BoxDecoration(
                      color: tokens.bad,
                      borderRadius: graphite ? null : const BorderRadius.horizontal(right: Radius.circular(5)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
