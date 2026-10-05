import 'package:depenses/layers/functional/Appearance/domain/entities/appearance_settings.dart';
import 'package:depenses/layers/functional/Appearance/domain/entities/color_palette.dart';
import 'package:depenses/layers/functional/Appearance/domain/entities/theme_preference.dart';
import 'package:depenses/layers/functional/Appearance/domain/entities/visual_style.dart';
import 'package:depenses/layers/functional/Appearance/domain/use_cases/save_appearance_use_case.dart';
import 'package:depenses/layers/functional/Appearance/presentation/cubit/appearance_cubit.dart';
import 'package:depenses/layers/functional/Appearance/presentation/theme/appearance_tokens.dart';
import 'package:depenses/layers/technical/Theme/app_palette.dart';
import 'package:depenses/layers/technical/Theme/app_style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;
  late AppearanceCubit cubit;

  setUp(() {
    dependencies = TestDependencies(
      data: {
        'settings': {'themeMode': 'light', 'style': 'menthe', 'palette': 'prune'},
      },
    );
    cubit = dependencies.get<AppearanceCubit>();
  });
  tearDown(() async {
    await cubit.close();
    await dependencies.dispose();
  });

  test('starts with the stored appearance', () {
    expect(
      cubit.state,
      const AppearanceSettings(
        themePreference: ThemePreference.light,
        style: VisualStyle.menthe,
        palette: ColorPalette.prune,
      ),
    );
  });

  test('follows every saved appearance change', () async {
    await dependencies.get<SaveAppearanceUseCase>()(
      const AppearanceSettings(themePreference: ThemePreference.auto, style: VisualStyle.graphite),
    );

    expect(cubit.state.style, VisualStyle.graphite);
    expect(cubit.state.themePreference, ThemePreference.auto);
  });

  test('maps the settings to theme tokens', () {
    const settings = AppearanceSettings(
      themePreference: ThemePreference.auto,
      style: VisualStyle.graphite,
      palette: ColorPalette.terracotta,
    );

    expect(settings.appStyle, AppStyle.graphite);
    expect(settings.appPalette, AppPalette.terracotta);
    expect(settings.isDarkWith(Brightness.dark), isTrue);
    expect(settings.isDarkWith(Brightness.light), isFalse);
    expect(settings.tokensWith(Brightness.dark).isGraphite, isTrue);
    expect(settings.tokensWith(Brightness.dark).isDark, isTrue);
    expect(cubit.state.isDarkWith(Brightness.dark), isFalse);
  });
}
