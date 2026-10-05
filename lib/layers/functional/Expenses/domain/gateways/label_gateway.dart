abstract class LabelGateway {
  List<String> all();

  Future<void> learn(Iterable<String> labels);

  Future<void> forget(String label);
}
