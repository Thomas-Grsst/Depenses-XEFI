import 'package:depenses/layers/functional/Expenses/domain/entities/label_usage.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_ruled.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/profile_locale.dart';

class ProfileLabelRow extends StatelessWidget {
  const ProfileLabelRow({super.key, required this.usage, required this.onDelete});

  final LabelUsage usage;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppRuled(
      child: Row(
        children: [
          Expanded(child: Text(usage.label, style: tokens.ts(15, tokens.wItem))),
          Text('${usage.expenseCount}', style: tokens.ts(13, tokens.wSemi, tokens.muted)),
          AppPressable(
            onTap: onDelete,
            semanticsLabel: context.trWith(ProfileLocale.deleteLabel, [usage.label]),
            child: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: AppIcon('trash', size: 18, color: tokens.warn),
            ),
          ),
        ],
      ),
    );
  }
}
