import 'package:depenses/layers/technical/Storage/id_generator.dart';

import '../entities/goal.dart';
import '../gateways/goal_gateway.dart';

class AddGoalUseCase {
  AddGoalUseCase(this._goals, this._ids);

  final GoalGateway _goals;
  final IdGenerator _ids;

  Future<Goal> call({
    required String name,
    required double target,
    required double saved,
    required double monthly,
  }) async {
    final goal = Goal(id: _ids.next(), name: name, target: target, saved: saved, monthly: monthly);
    await _goals.saveAll([..._goals.all(), goal]);
    return goal;
  }
}
