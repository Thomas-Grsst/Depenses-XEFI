enum VisualStyle {
  menthe('menthe'),
  graphite('graphite');

  const VisualStyle(this.storageKey);

  final String storageKey;

  static VisualStyle fromStorageKey(String? key) =>
      VisualStyle.values.firstWhere((s) => s.storageKey == key, orElse: () => VisualStyle.menthe);
}
