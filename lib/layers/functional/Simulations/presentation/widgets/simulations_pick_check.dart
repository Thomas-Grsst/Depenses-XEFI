import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class SimulationsPickCheck extends StatelessWidget {
  const SimulationsPickCheck({super.key, required this.isPicked});

  final bool isPicked;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final size = graphite ? 22.0 : 26.0;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPicked ? tokens.fab : Colors.transparent,
        border: Border.all(
          color: isPicked ? tokens.fab : (graphite ? tokens.lineStrong : tokens.off),
          width: graphite ? 1 : 2,
        ),
      ),
      child: isPicked ? AppIcon('check', size: 14, color: tokens.fabInk, stroke: 2.4) : null,
    );
  }
}
