double roundUpOf(double amount) {
  final cents = (amount * 100).round();
  return ((100 - cents % 100) % 100) / 100;
}
