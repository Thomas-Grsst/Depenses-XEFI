import 'package:depenses/layers/functional/Appearance/domain/entities/visual_style.dart';
import 'package:depenses/layers/functional/Profile/domain/use_cases/get_profile_overview_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'settings': {
          'name': 'Camille',
          'income': 2400,
          'payDay': 28,
          'balance': 1000,
          'balanceDate': '2026-10-15',
          'style': 'graphite',
          'alerts': false,
          'detection': true,
          'roundUp': false,
        },
        'expenses': [
          {
            'id': 'a',
            'name': 'Café',
            'amount': 2.4,
            'date': '2026-10-10',
            'cat': 'ali',
            'labels': ['Sorties'],
            'roundUp': 0.6,
          },
          {
            'id': 'b',
            'name': 'Pain',
            'amount': 1.2,
            'date': '2026-10-11',
            'cat': 'ali',
            'labels': <String>[],
            'roundUp': 0.8,
          },
        ],
        'labels': ['Sorties', 'Vacances'],
        'sims': [
          {'id': 's', 'title': 'T', 'desc': '', 'createdAt': '2026-10-01', 'hyps': <Object>[]},
        ],
      },
    );
  });
  tearDown(() => dependencies.dispose());

  test('gathers everything the profile tab shows', () {
    final overview = dependencies.get<GetProfileOverviewUseCase>()();

    expect(overview.name, 'Camille');
    expect(overview.hasIncome, isTrue);
    expect(overview.account.payDay, 28);
    expect(overview.account.hasBalance, isTrue);
    expect(overview.balance, 1000);
    expect(overview.scenarioCount, 1);
    expect(overview.hasScenarios, isTrue);
    expect(overview.categoryCount, 6);
    expect(overview.labels.map((l) => (l.label, l.expenseCount)), [('Sorties', 1), ('Vacances', 0)]);
    expect(overview.roundUpTotal, closeTo(1.4, 0.0001));
    expect(overview.isRoundUpEnabled, isFalse);
    expect(overview.areAlertsEnabled, isFalse);
    expect(overview.isDetectionEnabled, isTrue);
    expect(overview.appearance.style, VisualStyle.graphite);
    expect(overview.expenseCount, 2);
  });
}
