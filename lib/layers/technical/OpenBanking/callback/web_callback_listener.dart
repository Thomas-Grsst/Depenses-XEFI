import '../authorization_callback_listener.dart';
import 'authorization_browser.dart';

const _callbackRoute = '/#/bank-callback';

class WebCallbackListener implements AuthorizationCallbackListener {
  WebCallbackListener(this._base, {AuthorizationPageLauncher? launch}) : _launch = launch ?? launchInCurrentTab;

  final Uri _base;
  final AuthorizationPageLauncher _launch;

  @override
  String get redirectUrl => '${_base.origin}$_callbackRoute';

  @override
  Stream<Uri> get callbacks => const Stream.empty();

  @override
  Future<void> open(Uri authorizationUrl, {required String returnMessage}) =>
      openAuthorizationPage(authorizationUrl, _launch);

  @override
  Future<void> close() async {}
}
