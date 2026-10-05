import 'package:depenses/layers/functional/Appearance/domain/entities/color_palette.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_menthe_tokens.dart';
import 'package:depenses/layers/technical/Theme/app_ocean_tokens.dart';
import 'package:depenses/layers/technical/Theme/app_prune_tokens.dart';
import 'package:flutter/material.dart';

import '../l10n/profile_locale.dart';
import 'profile_palette_swatch.dart';

const _terracottaSwatch = Color(0xFFA9471F);

class ProfilePalettePicker extends StatelessWidget {
  const ProfilePalettePicker({super.key, required this.selected, required this.onSelected});

  final ColorPalette selected;
  final ValueChanged<ColorPalette> onSelected;

  @override
  Widget build(BuildContext context) {
    final palettes = [
      (ColorPalette.menthe, AppMentheTokens.light.mint, context.tr(ProfileLocale.paletteMenthe)),
      (ColorPalette.ocean, AppOceanTokens.light.mint, context.tr(ProfileLocale.paletteOcean)),
      (ColorPalette.prune, AppPruneTokens.light.mint, context.tr(ProfileLocale.palettePrune)),
      (ColorPalette.terracotta, _terracottaSwatch, context.tr(ProfileLocale.paletteTerracotta)),
    ];
    return Row(
      children: [
        for (final (palette, color, name) in palettes)
          Expanded(
            child: ProfilePaletteSwatch(
              color: color,
              name: name,
              isSelected: palette == selected,
              onTap: () => onSelected(palette),
            ),
          ),
      ],
    );
  }
}
