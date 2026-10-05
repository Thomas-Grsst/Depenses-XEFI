import 'package:app_links/app_links.dart';

import '../authorization_callback_listener.dart';
import 'authorization_browser.dart';

const _scheme = 'depenses';
const _host = 'bank-callback';

class AppLinksCallbackListener implements AuthorizationCallbackListener {
  AppLinksCallbackListener({Stream<Uri>? links, AuthorizationPageLauncher? launch})
    : _links = links ?? AppLinks().uriLinkStream,
      _launch = launch ?? launchInExternalBrowser;

  final Stream<Uri> _links;
  final AuthorizationPageLauncher _launch;

  @override
  String get redirectUrl => '$_scheme://$_host';

  @override
  Stream<Uri> get callbacks => _links.where((link) => link.scheme == _scheme && link.host == _host);

  @override
  Future<void> open(Uri authorizationUrl, {required String returnMessage}) =>
      openAuthorizationPage(authorizationUrl, _launch);

  @override
  Future<void> close() async {}
}
