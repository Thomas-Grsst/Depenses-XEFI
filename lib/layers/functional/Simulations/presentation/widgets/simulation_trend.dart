const _changeThreshold = 0.004;

enum SimulationTrend {
  worse,
  better,
  neutral;

  static SimulationTrend of(double delta) => delta > _changeThreshold
      ? SimulationTrend.worse
      : (delta < -_changeThreshold ? SimulationTrend.better : SimulationTrend.neutral);
}
