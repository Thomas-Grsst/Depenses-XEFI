import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorizationBrowserException implements Exception {
  const AuthorizationBrowserException(this.url);

  final Uri url;

  @override
  String toString() => 'AuthorizationBrowserException: cannot open $url';
}

typedef AuthorizationPageLauncher = Future<bool> Function(Uri url);

Future<bool> launchInExternalBrowser(Uri url) => launchUrl(url, mode: LaunchMode.externalApplication);

Future<bool> launchInCurrentTab(Uri url) => launchUrl(url, webOnlyWindowName: '_self');

Future<void> openAuthorizationPage(Uri url, AuthorizationPageLauncher launch) async {
  final bool isOpened;
  try {
    isOpened = await launch(url);
  } on PlatformException {
    throw AuthorizationBrowserException(url);
  }
  if (!isOpened) throw AuthorizationBrowserException(url);
}
