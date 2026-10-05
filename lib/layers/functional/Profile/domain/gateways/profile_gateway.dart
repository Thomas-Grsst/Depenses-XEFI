abstract class ProfileGateway {
  String name();

  Future<void> saveName(String name);
}
