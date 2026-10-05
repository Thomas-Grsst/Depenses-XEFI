abstract class AuthorizationStateGateway {
  String? pending();

  Future<void> remember(String state);

  Future<void> clear();
}
