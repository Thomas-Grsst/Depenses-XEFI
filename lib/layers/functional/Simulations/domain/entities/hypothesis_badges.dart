import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:equatable/equatable.dart';

import 'merchant_badge.dart';
import 'scenario.dart';

const _fallbackColorIndex = 5;
const _fallbackIcon = 'dots';

class HypothesisBadges extends Equatable {
  const HypothesisBadges([this.badges = const {}]);

  final Map<(String, String), MerchantBadge> badges;

  static (String, String) leadKeyOf(Scenario scenario) {
    if (scenario.hypotheses.isEmpty) return ('', Category.otherKey);
    final lead = scenario.hypotheses.first;
    return (lead.name, lead.categoryKey);
  }

  MerchantBadge of(String name, String categoryKey) =>
      badges[(name, categoryKey)] ??
      const MerchantBadge(colorIndex: _fallbackColorIndex, look: MerchantLook.icon(_fallbackIcon));

  MerchantBadge leadOf(Scenario scenario) {
    final (name, categoryKey) = leadKeyOf(scenario);
    return of(name, categoryKey);
  }

  @override
  List<Object?> get props => [badges];
}
