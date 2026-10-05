import 'dart:math';

const _historyWeightRampDays = 10;
const _maxCurrentWeight = 0.6;

class SpendingPace {
  const SpendingPace({required this.elapsedDays, required this.historyDays});

  final int elapsedDays;
  final int historyDays;

  double dailyRate(double currentTotal, double historyTotal) {
    final currentRate = currentTotal / elapsedDays;
    if (historyDays == 0) return currentRate;
    final historyRate = historyTotal / historyDays;
    final currentWeight = min(1.0, elapsedDays / _historyWeightRampDays) * _maxCurrentWeight;
    return currentRate * currentWeight + historyRate * (1 - currentWeight);
  }
}
