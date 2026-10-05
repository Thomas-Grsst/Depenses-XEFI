import 'package:depenses/layers/functional/Appearance/domain/entities/color_palette.dart';
import 'package:depenses/layers/functional/Appearance/domain/entities/theme_preference.dart';
import 'package:depenses/layers/functional/Appearance/domain/entities/visual_style.dart';
import 'package:depenses/layers/functional/Appearance/domain/use_cases/choose_visual_style_use_case.dart';
import 'package:depenses/layers/functional/Appearance/domain/use_cases/get_appearance_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      data: {
        'settings': {'themeMode': 'dark', 'style': 'menthe', 'palette': 'ocean'},
      },
    );
  });
  tearDown(() => dependencies.dispose());

  test('changes only the style', () async {
    await dependencies.get<ChooseVisualStyleUseCase>()(VisualStyle.graphite);

    final appearance = dependencies.get<GetAppearanceUseCase>()();
    expect(appearance.style, VisualStyle.graphite);
    expect(appearance.palette, ColorPalette.ocean);
    expect(appearance.themePreference, ThemePreference.dark);
  });
}
