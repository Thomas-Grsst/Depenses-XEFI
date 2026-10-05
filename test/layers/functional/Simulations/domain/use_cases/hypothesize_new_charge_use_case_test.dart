import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Simulations/domain/use_cases/hypothesize_new_charge_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;
  late HypothesizeNewChargeUseCase hypothesize;

  setUp(() {
    dependencies = TestDependencies();
    hypothesize = dependencies.get<HypothesizeNewChargeUseCase>();
  });
  tearDown(() => dependencies.dispose());

  test('a new charge is a monthly hypothesis starting from zero with a guessed category', () {
    final hypothesis = hypothesize(name: ' Uber ', monthlyAmount: 120, fallbackName: 'Nouvelle charge');

    expect(hypothesis?.name, 'Uber');
    expect(hypothesis?.categoryKey, 'tra');
    expect(hypothesis?.frequency, Frequency.month);
    expect(hypothesis?.oldAmount, 0);
    expect(hypothesis?.newAmount, 120);
    expect(hypothesis?.isNew, isTrue);
  });

  test('a blank name falls back to the default name and the other category', () {
    final hypothesis = hypothesize(name: '  ', monthlyAmount: 300, fallbackName: 'Nouvelle charge');

    expect(hypothesis?.name, 'Nouvelle charge');
    expect(hypothesis?.categoryKey, 'aut');
  });

  test('a missing or non positive amount gives no hypothesis', () {
    expect(hypothesize(name: 'Crèche', monthlyAmount: null, fallbackName: 'x'), isNull);
    expect(hypothesize(name: 'Crèche', monthlyAmount: 0, fallbackName: 'x'), isNull);
  });
}
