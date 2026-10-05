class LoopbackCallbackServer {
  Future<bool> start({
    required int port,
    required String path,
    required String page,
    required void Function(Uri callback) onCallback,
  }) async => false;

  Future<void> stop() async {}
}
