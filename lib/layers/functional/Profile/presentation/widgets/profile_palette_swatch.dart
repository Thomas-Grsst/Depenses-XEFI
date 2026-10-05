import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/profile_locale.dart';

const _checkColor = Colors.white;

class ProfilePaletteSwatch extends StatelessWidget {
  const ProfilePaletteSwatch({
    super.key,
    required this.color,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: context.trWith(ProfileLocale.paletteSemantics, [name]),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? tokens.ink : Colors.transparent, width: 2.5),
            ),
            child: isSelected ? const Center(child: AppIcon('check', size: 16, color: _checkColor, stroke: 2.6)) : null,
          ),
          const SizedBox(height: 4),
          Text(name, style: tokens.ts(11, FontWeight.w600, tokens.muted)),
        ],
      ),
    );
  }
}
