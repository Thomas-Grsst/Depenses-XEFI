import '../entities/goal.dart';
import '../gateways/goal_gateway.dart';

class GetGoalsUseCase {
  GetGoalsUseCase(this._goals);

  final GoalGateway _goals;

  List<Goal> call() => _goals.all();
}
