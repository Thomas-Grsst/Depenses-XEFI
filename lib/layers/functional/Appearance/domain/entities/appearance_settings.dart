import 'package:equatable/equatable.dart';

import 'color_palette.dart';
import 'theme_preference.dart';
import 'visual_style.dart';

class AppearanceSettings extends Equatable {
  const AppearanceSettings({
    this.themePreference = ThemePreference.auto,
    this.style = VisualStyle.menthe,
    this.palette = ColorPalette.menthe,
  });

  final ThemePreference themePreference;
  final VisualStyle style;
  final ColorPalette palette;

  AppearanceSettings copyWith({ThemePreference? themePreference, VisualStyle? style, ColorPalette? palette}) =>
      AppearanceSettings(
        themePreference: themePreference ?? this.themePreference,
        style: style ?? this.style,
        palette: palette ?? this.palette,
      );

  @override
  List<Object?> get props => [themePreference, style, palette];
}
