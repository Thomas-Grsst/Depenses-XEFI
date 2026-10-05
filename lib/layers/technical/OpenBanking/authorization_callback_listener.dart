abstract class AuthorizationCallbackListener {
  String get redirectUrl;

  Stream<Uri> get callbacks;

  Future<void> open(Uri authorizationUrl, {required String returnMessage});

  Future<void> close();
}
