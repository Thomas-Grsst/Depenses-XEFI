import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class SimulationStepButton extends StatelessWidget {
  const SimulationStepButton({super.key, required this.icon, required this.semanticsLabel, this.onTap});

  final String icon;
  final String semanticsLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: semanticsLabel,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: graphite ? Colors.transparent : tokens.chip,
          borderRadius: BorderRadius.circular(graphite ? 24 : 16),
          border: graphite ? Border.all(color: tokens.lineStrong) : null,
        ),
        child: AppIcon(icon, size: 20, color: tokens.ink, stroke: graphite ? 1.4 : 2),
      ),
    );
  }
}
