import 'package:depenses/layers/functional/Budget/domain/gateways/envelope_gateway.dart';
import 'package:depenses/layers/functional/Budget/domain/gateways/label_envelope_gateway.dart';
import 'package:depenses/layers/functional/Budget/presentation/cubit/budget_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

Map<String, dynamic> _expense(String id, String category, double amount, List<String> labels) => {
  'id': id,
  'name': id,
  'amount': amount,
  'date': '2026-10-05',
  'cat': category,
  'labels': labels,
};

void main() {
  late TestDependencies dependencies;
  late BudgetCubit cubit;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [
          _expense('a', 'ali', 120, ['Sorties']),
          _expense('b', 'loi', 30, []),
        ],
        'envelopes': {'ali': 300},
        'labels': ['Sorties', 'Vacances'],
        'labelEnvs': [
          {'id': 'e1', 'name': 'Mes sorties', 'label': 'Sorties', 'amount': 100},
        ],
      },
    );
    cubit = dependencies.get<BudgetCubit>();
  });
  tearDown(() async {
    await cubit.close();
    await dependencies.dispose();
  });

  test('loading exposes the month stats, envelopes and label envelopes', () {
    final state = cubit.state;

    expect(state.stats?.budget, 300);
    expect(state.hasBudget, isTrue);
    expect(state.margin, state.stats!.budget - state.stats!.forecast);
    expect(state.categoryEnvelopes.firstWhere((e) => e.category.key == 'ali').budget, 300);
    expect(state.labelEnvelopes.single.spent, 120);
    expect(state.labels, containsAll(['Sorties', 'Vacances']));
  });

  test('setting an envelope reloads the state', () async {
    await cubit.setEnvelope('loi', 80);

    expect(dependencies.get<EnvelopeGateway>().all(), {'ali': 300, 'loi': 80});
    expect(cubit.state.stats?.budget, 380);
  });

  test('setting all envelopes at once replaces them', () async {
    await cubit.setEnvelopes({'ali': 0, 'tra': 50});

    expect(cubit.state.stats?.budget, 50);
    expect(cubit.state.hasBudget, isTrue);
  });

  test('saving then deleting a label envelope updates the list', () async {
    final isSaved = await cubit.saveLabelEnvelope(
      name: '',
      fallbackName: 'Libellé « Vacances »',
      label: 'Vacances',
      amount: 400,
    );

    expect(isSaved, isTrue);
    expect([for (final p in cubit.state.labelEnvelopes) p.envelope.name], ['Mes sorties', 'Libellé « Vacances »']);

    await cubit.deleteLabelEnvelope('e1');

    expect(dependencies.get<LabelEnvelopeGateway>().all().single.label, 'Vacances');
    expect(cubit.state.labelEnvelopes, hasLength(1));
  });
}
