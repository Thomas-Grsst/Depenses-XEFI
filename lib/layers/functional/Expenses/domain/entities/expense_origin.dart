enum ExpenseOrigin {
  manual('manual'),
  bank('bank');

  const ExpenseOrigin(this.storageKey);

  final String storageKey;

  static ExpenseOrigin fromStorageKey(String? key) =>
      ExpenseOrigin.values.firstWhere((origin) => origin.storageKey == key, orElse: () => ExpenseOrigin.manual);
}
