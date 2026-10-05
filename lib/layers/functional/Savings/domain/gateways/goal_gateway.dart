import '../entities/goal.dart';

abstract class GoalGateway {
  List<Goal> all();

  Future<void> saveAll(List<Goal> goals);
}
