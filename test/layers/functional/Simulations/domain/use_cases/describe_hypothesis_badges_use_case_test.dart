import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/functional/Simulations/domain/entities/hypothesis_badges.dart';
import 'package:depenses/layers/functional/Simulations/domain/use_cases/describe_hypothesis_badges_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../simulations_fixtures.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() => dependencies = TestDependencies());
  tearDown(() => dependencies.dispose());

  test('each name gets its merchant look and its category colour', () {
    final badges = dependencies.get<DescribeHypothesisBadgesUseCase>()([('Netflix', 'loi'), ('Loyer', 'log')]);

    expect(badges.of('Netflix', 'loi').look, const MerchantLook.letter('N'));
    expect(badges.of('Netflix', 'loi').colorIndex, 3);
    expect(badges.of('Loyer', 'log').colorIndex, 0);
  });

  test('the lead badge of a scenario is the one of its first hypothesis', () {
    final scenario = scenarioWith('a', [rentHypothesis()]);
    final empty = scenarioWith('b', const []);

    expect(HypothesisBadges.leadKeyOf(scenario), ('Loyer', 'log'));
    expect(HypothesisBadges.leadKeyOf(empty), ('', 'aut'));
    expect(const HypothesisBadges().leadOf(empty).colorIndex, 5);
  });
}
