import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

class OccurrenceDateStack extends StatelessWidget {
  const OccurrenceDateStack({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return SizedBox(
      width: 40,
      child: Column(
        children: [
          Text('${date.day}', style: tokens.ts(16, FontWeight.w700)),
          Text(context.dates.shortMonthName(date), style: tokens.ts(11, FontWeight.w700, tokens.muted)),
        ],
      ),
    );
  }
}
