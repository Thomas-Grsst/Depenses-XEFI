sealed class SavingsGoalSheetResult {
  const SavingsGoalSheetResult();
}

class SavingsGoalSaved extends SavingsGoalSheetResult {
  const SavingsGoalSaved({required this.name, required this.target, required this.saved, required this.monthly});

  final String name;
  final double target;
  final double saved;
  final double monthly;
}

class SavingsGoalDeleted extends SavingsGoalSheetResult {
  const SavingsGoalDeleted();
}
