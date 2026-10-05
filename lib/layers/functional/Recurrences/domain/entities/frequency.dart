enum Frequency {
  week('week'),
  month('month'),
  year('year');

  const Frequency(this.storageKey);

  final String storageKey;

  static Frequency fromStorageKey(String key) =>
      Frequency.values.firstWhere((f) => f.storageKey == key, orElse: () => Frequency.month);

  double monthlyAmount(double amount) => switch (this) {
    Frequency.week => amount * 52 / 12,
    Frequency.year => amount / 12,
    Frequency.month => amount,
  };
}
