import 'package:depenses/layers/functional/Simulations/domain/entities/hypothesis_scale.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../simulations_fixtures.dart';

void main() {
  test('large amounts move by tens and the slider reaches twice the current amount', () {
    final scale = HypothesisScale.of(rentHypothesis(newAmount: 700));

    expect(scale.step, 10);
    expect(scale.maximum, 1400);
    expect(scale.stepped(700, 1), 710);
    expect(scale.stepped(5, -1), 0);
    expect(scale.snapped(904), 900);
  });

  test('medium and small amounts use finer steps', () {
    final medium = HypothesisScale.of(rentHypothesis().copyWith(oldAmount: 30, newAmount: 30));
    final small = HypothesisScale.of(rentHypothesis().copyWith(oldAmount: 5, newAmount: 5));

    expect(medium.step, 1);
    expect(medium.maximum, 130);
    expect(small.step, 0.5);
    expect(small.snapped(3.3), 3.5);
  });
}
