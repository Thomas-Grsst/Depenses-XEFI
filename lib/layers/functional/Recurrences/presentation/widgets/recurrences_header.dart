import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../cubit/recurrences_mode.dart';
import '../l10n/recurrences_locale.dart';
import 'recurrences_mode_switch.dart';

class RecurrencesHeader extends StatelessWidget {
  const RecurrencesHeader({super.key, required this.mode});

  final RecurrencesMode mode;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final title = context.tr(RecurrencesLocale.title);
    if (!tokens.isGraphite) {
      return Text(title, style: tokens.ts(28, FontWeight.w800).copyWith(letterSpacing: -0.5));
    }
    return Row(
      children: [
        Expanded(child: Text(title, style: tokens.ts(15, FontWeight.w500))),
        RecurrencesModeSwitch(mode: mode),
      ],
    );
  }
}
