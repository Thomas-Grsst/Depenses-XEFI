import '../entities/goal.dart';
import 'add_goal_use_case.dart';
import 'update_goal_use_case.dart';

class SaveGoalUseCase {
  SaveGoalUseCase(this._add, this._update);

  final AddGoalUseCase _add;
  final UpdateGoalUseCase _update;

  Future<bool> call({
    Goal? existing,
    required String name,
    required double target,
    required double saved,
    required double monthly,
    required String fallbackName,
  }) async {
    if (target <= 0) return false;
    final trimmed = name.trim();
    final goalName = trimmed.isEmpty ? fallbackName : trimmed;
    if (existing == null) {
      await _add(name: goalName, target: target, saved: saved, monthly: monthly);
    } else {
      await _update(existing.copyWith(name: goalName, target: target, saved: saved, monthly: monthly));
    }
    return true;
  }
}
