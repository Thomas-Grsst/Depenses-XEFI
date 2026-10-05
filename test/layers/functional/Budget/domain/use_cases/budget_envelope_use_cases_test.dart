import 'package:depenses/layers/functional/Budget/domain/entities/category_envelope.dart';
import 'package:depenses/layers/functional/Budget/domain/gateways/envelope_gateway.dart';
import 'package:depenses/layers/functional/Budget/domain/use_cases/get_category_envelopes_use_case.dart';
import 'package:depenses/layers/functional/Budget/domain/use_cases/set_envelopes_use_case.dart';
import 'package:depenses/layers/functional/Forecast/domain/use_cases/compute_month_stats_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

Map<String, dynamic> _expense(String id, String category, double amount, String date) => {
  'id': id,
  'name': id,
  'amount': amount,
  'date': date,
  'cat': category,
  'labels': <String>[],
};

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'expenses': [_expense('a', 'ali', 150, '2026-10-02'), _expense('b', 'loi', 30, '2026-10-04')],
        'envelopes': {'ali': 100, 'loi': 500},
      },
    );
  });
  tearDown(() => dependencies.dispose());

  CategoryEnvelope envelopeOf(String key) {
    final stats = dependencies.get<ComputeMonthStatsUseCase>()();
    return dependencies.get<GetCategoryEnvelopesUseCase>()(stats).firstWhere((e) => e.category.key == key);
  }

  test('every category gets an envelope in category order', () {
    final stats = dependencies.get<ComputeMonthStatsUseCase>()();

    final envelopes = dependencies.get<GetCategoryEnvelopesUseCase>()(stats);

    expect([for (final e in envelopes) e.category.key], ['log', 'ali', 'tra', 'loi', 'san', 'aut']);
  });

  test('an envelope spent beyond its budget is overspent and flagged as over', () {
    final envelope = envelopeOf('ali');

    expect(envelope.status, CategoryEnvelopeStatus.overspent);
    expect(envelope.isProjectedOver, isTrue);
    expect(envelope.overspentBy, 50);
    expect(envelope.usedRatio, 1.5);
  });

  test('an envelope within its budget is on track', () {
    expect(envelopeOf('loi').status, CategoryEnvelopeStatus.onTrack);
  });

  test('a category without envelope is untracked', () {
    expect(envelopeOf('log').status, CategoryEnvelopeStatus.untracked);
    expect(envelopeOf('log').usedRatio, 0);
  });

  test('setting several envelopes stores positive amounts and drops zeros', () async {
    await dependencies.get<SetEnvelopesUseCase>()({'ali': 0, 'tra': 60, 'loi': 450});

    expect(dependencies.get<EnvelopeGateway>().all(), {'loi': 450, 'tra': 60});
  });
}
