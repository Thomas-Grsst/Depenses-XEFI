enum ColorPalette {
  menthe('menthe'),
  ocean('ocean'),
  prune('prune'),
  terracotta('terracotta');

  const ColorPalette(this.storageKey);

  final String storageKey;

  static ColorPalette fromStorageKey(String? key) =>
      ColorPalette.values.firstWhere((p) => p.storageKey == key, orElse: () => ColorPalette.menthe);
}
