class BudgetLabelEnvelopeFormResult {
  const BudgetLabelEnvelopeFormResult.save({
    required this.name,
    required this.fallbackName,
    required this.label,
    required this.amount,
  }) : isDeletion = false;

  const BudgetLabelEnvelopeFormResult.delete()
    : isDeletion = true,
      name = '',
      fallbackName = '',
      label = '',
      amount = 0;

  final bool isDeletion;
  final String name;
  final String fallbackName;
  final String label;
  final double amount;
}
