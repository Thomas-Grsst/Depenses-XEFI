import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class SavingsTotalRow extends StatelessWidget {
  const SavingsTotalRow(this.label, {super.key, required this.trailing, this.isStrong = false, this.isLast = false});

  final String label;
  final Widget trailing;
  final bool isStrong;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppRuled(
      bottom: isLast,
      child: Row(
        children: [
          Expanded(child: Text(label, style: tokens.ts(15, isStrong ? tokens.wStrong : tokens.wItem))),
          trailing,
        ],
      ),
    );
  }
}
