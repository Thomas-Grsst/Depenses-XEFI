import 'package:depenses/layers/technical/Theme/app_palette.dart';
import 'package:depenses/layers/technical/Theme/app_style.dart';
import 'package:depenses/layers/technical/Theme/app_tokens.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/appearance_settings.dart';
import '../../domain/entities/color_palette.dart';
import '../../domain/entities/theme_preference.dart';
import '../../domain/entities/visual_style.dart';

extension AppearanceTokens on AppearanceSettings {
  bool isDarkWith(Brightness platformBrightness) => switch (themePreference) {
    ThemePreference.dark => true,
    ThemePreference.light => false,
    ThemePreference.auto => platformBrightness == Brightness.dark,
  };

  AppStyle get appStyle => switch (style) {
    VisualStyle.menthe => AppStyle.menthe,
    VisualStyle.graphite => AppStyle.graphite,
  };

  AppPalette get appPalette => switch (palette) {
    ColorPalette.menthe => AppPalette.menthe,
    ColorPalette.ocean => AppPalette.ocean,
    ColorPalette.prune => AppPalette.prune,
    ColorPalette.terracotta => AppPalette.terracotta,
  };

  AppTokens tokensWith(Brightness platformBrightness) =>
      AppTokens.resolve(style: appStyle, palette: appPalette, isDark: isDarkWith(platformBrightness));
}
