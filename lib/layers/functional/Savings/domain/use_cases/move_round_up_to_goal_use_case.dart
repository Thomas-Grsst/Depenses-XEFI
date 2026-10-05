import 'package:depenses/layers/technical/Calendar/clock.dart';

import '../entities/goal.dart';
import '../gateways/goal_gateway.dart';
import '../gateways/round_up_usage_gateway.dart';
import 'get_round_up_summary_use_case.dart';

class MoveRoundUpToGoalUseCase {
  MoveRoundUpToGoalUseCase(this._goals, this._usage, this._summary, this._clock);

  final GoalGateway _goals;
  final RoundUpUsageGateway _usage;
  final GetRoundUpSummaryUseCase _summary;
  final Clock _clock;

  Future<void> call(Goal goal) async {
    final available = _summary(_clock.today()).available;
    if (available <= 0) return;
    await _goals.saveAll([for (final g in _goals.all()) g.id == goal.id ? g.copyWith(saved: g.saved + available) : g]);
    await _usage.setUsed(_usage.used() + available);
  }
}
