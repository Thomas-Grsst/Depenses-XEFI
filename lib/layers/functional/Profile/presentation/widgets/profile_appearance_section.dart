import 'package:depenses/layers/functional/Appearance/domain/entities/appearance_settings.dart';
import 'package:depenses/layers/functional/Appearance/domain/entities/theme_preference.dart';
import 'package:depenses/layers/functional/Appearance/domain/entities/visual_style.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_segmented.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/profile_cubit.dart';
import '../l10n/profile_locale.dart';
import 'profile_palette_picker.dart';

class ProfileAppearanceSection extends StatelessWidget {
  const ProfileAppearanceSection({super.key, required this.appearance});

  final AppearanceSettings appearance;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionLabel(context.tr(ProfileLocale.appearance)),
        const SizedBox(height: AppSpacing.sm),
        AppSegmented<VisualStyle>(
          options: [
            (VisualStyle.menthe, context.tr(ProfileLocale.styleMenthe)),
            (VisualStyle.graphite, context.tr(ProfileLocale.styleGraphite)),
          ],
          value: appearance.style,
          onChanged: cubit.chooseStyle,
        ),
        const SizedBox(height: 10),
        AppSegmented<ThemePreference>(
          options: [
            (ThemePreference.light, context.tr(ProfileLocale.themeLight)),
            (ThemePreference.dark, context.tr(ProfileLocale.themeDark)),
            (ThemePreference.auto, context.tr(ProfileLocale.themeAuto)),
          ],
          value: appearance.themePreference,
          onChanged: cubit.chooseThemePreference,
        ),
        if (!context.tokens.isGraphite) ...[
          const SizedBox(height: AppSpacing.md),
          ProfilePalettePicker(selected: appearance.palette, onSelected: cubit.choosePalette),
        ],
      ],
    );
  }
}
