import '../gateways/goal_gateway.dart';

class DeleteGoalUseCase {
  DeleteGoalUseCase(this._goals);

  final GoalGateway _goals;

  Future<void> call(String id) => _goals.saveAll(_goals.all().where((g) => g.id != id).toList());
}
