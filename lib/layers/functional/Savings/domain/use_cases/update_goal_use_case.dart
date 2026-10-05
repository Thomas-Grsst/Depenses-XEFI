import '../entities/goal.dart';
import '../gateways/goal_gateway.dart';

class UpdateGoalUseCase {
  UpdateGoalUseCase(this._goals);

  final GoalGateway _goals;

  Future<void> call(Goal goal) => _goals.saveAll([for (final g in _goals.all()) g.id == goal.id ? goal : g]);
}
