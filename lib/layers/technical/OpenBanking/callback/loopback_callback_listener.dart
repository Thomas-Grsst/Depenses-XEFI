import 'dart:async';

import '../authorization_callback_listener.dart';
import 'authorization_browser.dart';
import 'loopback_callback_server_stub.dart' if (dart.library.io) 'loopback_callback_server_io.dart';

const loopbackCallbackPort = 8765;
const _callbackPath = '/bank-callback';

class LoopbackCallbackListener implements AuthorizationCallbackListener {
  LoopbackCallbackListener({this.port = loopbackCallbackPort, AuthorizationPageLauncher? launch})
    : _launch = launch ?? launchInExternalBrowser;

  final int port;
  final AuthorizationPageLauncher _launch;
  final LoopbackCallbackServer _server = LoopbackCallbackServer();
  final StreamController<Uri> _callbacks = StreamController<Uri>.broadcast();

  @override
  String get redirectUrl => 'http://localhost:$port$_callbackPath';

  @override
  Stream<Uri> get callbacks => _callbacks.stream;

  @override
  Future<void> open(Uri authorizationUrl, {required String returnMessage}) async {
    await _server.start(port: port, path: _callbackPath, page: returnMessage, onCallback: _callbacks.add);
    await openAuthorizationPage(authorizationUrl, _launch);
  }

  @override
  Future<void> close() async {
    await _server.stop();
    await _callbacks.close();
  }
}
