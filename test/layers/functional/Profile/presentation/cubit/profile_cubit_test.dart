import 'package:depenses/layers/functional/Appearance/domain/entities/color_palette.dart';
import 'package:depenses/layers/functional/Appearance/domain/entities/theme_preference.dart';
import 'package:depenses/layers/functional/Appearance/domain/entities/visual_style.dart';
import 'package:depenses/layers/functional/Profile/presentation/cubit/profile_cubit.dart';
import 'package:depenses/layers/functional/Profile/presentation/cubit/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;
  late ProfileCubit cubit;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'settings': {'name': 'Camille', 'income': 2000, 'payDay': 1},
        'expenses': [
          {
            'id': 'a',
            'name': 'Café',
            'amount': 2.5,
            'date': '2026-10-10',
            'cat': 'ali',
            'labels': ['Sorties'],
          },
        ],
        'labels': ['Sorties'],
        'goals': [
          {'id': 'g', 'name': 'Vacances', 'target': 1000, 'saved': 0, 'monthly': 100},
        ],
      },
    );
    cubit = dependencies.get<ProfileCubit>();
  });
  tearDown(() async {
    await cubit.close();
    await dependencies.dispose();
  });

  test('loads the profile overview', () {
    expect(cubit.state.status, ProfileStatus.ready);
    expect(cubit.state.overview.name, 'Camille');
    expect(cubit.state.overview.account.income, 2000);
    expect(cubit.state.overview.hasScenarios, isFalse);
  });

  test('saving the details refreshes the overview', () async {
    await cubit.saveDetails(name: 'Alex', income: 2500, payDay: 10, balance: 300, isBalanceBlank: false);

    expect(cubit.state.overview.name, 'Alex');
    expect(cubit.state.overview.account.payDay, 10);
    expect(cubit.state.overview.account.hasBalance, isTrue);
    expect(cubit.state.overview.balance, 300);
  });

  test('appearance choices are saved one field at a time', () async {
    await cubit.chooseStyle(VisualStyle.graphite);
    await cubit.choosePalette(ColorPalette.prune);
    await cubit.chooseThemePreference(ThemePreference.dark);

    final appearance = cubit.state.overview.appearance;
    expect(appearance.style, VisualStyle.graphite);
    expect(appearance.palette, ColorPalette.prune);
    expect(appearance.themePreference, ThemePreference.dark);
  });

  test('alert and detection toggles are saved', () async {
    await cubit.setAlertsEnabled(false);
    await cubit.setDetectionEnabled(false);

    expect(cubit.state.overview.areAlertsEnabled, isFalse);
    expect(cubit.state.overview.isDetectionEnabled, isFalse);
  });

  test('labels can be added and removed', () async {
    expect(await cubit.addLabel(' Vacances '), 'Vacances');
    expect(cubit.state.overview.labels.map((l) => l.label), ['Sorties', 'Vacances']);

    await cubit.removeLabel('Sorties');
    expect(cubit.state.overview.labels.map((l) => l.label), ['Vacances']);
  });

  test('exporting publishes a new csv each time', () {
    cubit.exportCsv();
    final first = cubit.state.exportCount;
    cubit.exportCsv();

    expect(cubit.state.exportCount, first + 1);
    expect(cubit.state.exportedCsv, startsWith('date;nom;montant;categorie;libelles;recurrente\n'));
    expect(cubit.state.exportedCsv, contains('"Café"'));
  });

  test('resetting erases the data but keeps the name', () async {
    await cubit.resetAllData();

    expect(cubit.state.overview.expenseCount, 0);
    expect(cubit.state.overview.name, 'Camille');
  });
}
