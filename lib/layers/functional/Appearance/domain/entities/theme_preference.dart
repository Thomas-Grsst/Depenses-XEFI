enum ThemePreference {
  light('light'),
  dark('dark'),
  auto('auto');

  const ThemePreference(this.storageKey);

  final String storageKey;

  static ThemePreference fromStorageKey(String? key) =>
      ThemePreference.values.firstWhere((p) => p.storageKey == key, orElse: () => ThemePreference.auto);
}
