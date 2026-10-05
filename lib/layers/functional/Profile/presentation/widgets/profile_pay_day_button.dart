import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class ProfilePayDayButton extends StatelessWidget {
  const ProfilePayDayButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    return AppPressable(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: graphite ? Colors.transparent : tokens.chip,
          borderRadius: BorderRadius.circular(graphite ? 22 : 14),
          border: graphite ? Border.all(color: tokens.lineStrong) : null,
        ),
        child: Text(label, style: tokens.ts(20, FontWeight.w500)),
      ),
    );
  }
}
