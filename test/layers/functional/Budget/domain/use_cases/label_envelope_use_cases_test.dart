import 'package:depenses/layers/functional/Budget/domain/entities/label_envelope.dart';
import 'package:depenses/layers/functional/Budget/domain/gateways/label_envelope_gateway.dart';
import 'package:depenses/layers/functional/Budget/domain/use_cases/get_label_envelope_progress_use_case.dart';
import 'package:depenses/layers/functional/Budget/domain/use_cases/save_label_envelope_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

Map<String, dynamic> _expense(String id, double amount, String date, List<String> labels) => {
  'id': id,
  'name': id,
  'amount': amount,
  'date': date,
  'cat': 'loi',
  'labels': labels,
};

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [
          _expense('a', 40, '2026-10-02', ['Sorties']),
          _expense('b', 25, '2026-10-09', ['Sorties', 'Vacances']),
          _expense('c', 90, '2026-09-20', ['Sorties']),
        ],
        'labelEnvs': [
          {'id': 'e1', 'name': 'Mes sorties', 'label': 'Sorties', 'amount': 50},
        ],
      },
    );
  });
  tearDown(() => dependencies.dispose());

  SaveLabelEnvelopeUseCase save() => dependencies.get<SaveLabelEnvelopeUseCase>();

  test('progress sums the current month expenses carrying the label', () {
    final progress = dependencies.get<GetLabelEnvelopeProgressUseCase>()().single;

    expect(progress.spent, 65);
    expect(progress.isOver, isTrue);
    expect(progress.usedRatio, 1.3);
  });

  test('saving a new envelope with a blank name uses the fallback name', () async {
    final isSaved = await save()(name: '  ', fallbackName: 'Libellé « Vacances »', label: 'Vacances', amount: 300);

    expect(isSaved, isTrue);
    expect(dependencies.get<LabelEnvelopeGateway>().all().last.name, 'Libellé « Vacances »');
  });

  test('saving an existing envelope updates it in place', () async {
    final existing = dependencies.get<LabelEnvelopeGateway>().all().single;

    await save()(existing: existing, name: ' Sorties ', fallbackName: 'unused', label: 'Sorties', amount: 80);

    expect(dependencies.get<LabelEnvelopeGateway>().all(), [
      const LabelEnvelope(id: 'e1', name: 'Sorties', label: 'Sorties', amount: 80),
    ]);
  });

  test('an envelope without amount or label is not saved', () async {
    expect(await save()(name: 'x', fallbackName: 'y', label: 'Sorties', amount: 0), isFalse);
    expect(await save()(name: 'x', fallbackName: 'y', label: '', amount: 20), isFalse);
    expect(dependencies.get<LabelEnvelopeGateway>().all(), hasLength(1));
  });
}
