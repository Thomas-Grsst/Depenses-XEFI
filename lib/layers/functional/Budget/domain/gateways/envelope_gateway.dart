abstract class EnvelopeGateway {
  Map<String, double> all();

  Future<void> set(String categoryKey, double amount);

  Future<void> mergeInto({required String from, required String to});

  Future<void> clear();
}
