import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class AccountEndOfMonthLine extends StatelessWidget {
  const AccountEndOfMonthLine(this.label, {super.key, required this.amount, this.subtitle, this.isTotal = false});

  final String label;
  final String? subtitle;
  final double amount;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final money = context.money;
    final subtitle = this.subtitle;
    return AppRuled(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: tokens.ts(15, isTotal ? tokens.wStrong : tokens.wItem)),
                if (subtitle != null && subtitle.isNotEmpty)
                  Text(subtitle, style: tokens.ts(12, tokens.wSemi, tokens.muted)),
              ],
            ),
          ),
          Text(
            isTotal ? money.euros(amount) : money.withSign(amount, money.euros),
            style: tokens.ts(
              isTotal ? 17 : 15,
              isTotal ? tokens.wStrong : tokens.wItem,
              isTotal && amount < 0 ? tokens.warn : tokens.ink,
            ),
          ),
        ],
      ),
    );
  }
}
