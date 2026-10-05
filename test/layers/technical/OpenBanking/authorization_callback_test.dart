import 'dart:math';

import 'package:depenses/layers/technical/OpenBanking/callback/authorization_browser.dart';
import 'package:depenses/layers/technical/OpenBanking/callback/authorization_callback.dart';
import 'package:depenses/layers/technical/OpenBanking/callback/app_links_callback_listener.dart';
import 'package:depenses/layers/technical/OpenBanking/callback/web_callback_listener.dart';
import 'package:depenses/layers/technical/OpenBanking/secure_authorization_state_generator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthorizationCallback', () {
    test('reads the code and state from the query', () {
      final callback = AuthorizationCallback.fromUri(Uri.parse('depenses://bank-callback?code=abc&state=s1'));

      expect(callback, const AuthorizationCallback(code: 'abc', state: 's1'));
      expect(callback.isEmpty, isFalse);
    });

    test('reads the parameters of a hash route', () {
      final callback = AuthorizationCallback.fromUri(
        Uri.parse('http://localhost:8080/#/bank-callback?code=abc&state=s1'),
      );

      expect(callback, const AuthorizationCallback(code: 'abc', state: 's1'));
    });

    test('reads a refusal and ignores empty values', () {
      final callback = AuthorizationCallback.fromUri(Uri.parse('depenses://bank-callback?error=access_denied&code='));

      expect(callback, const AuthorizationCallback(error: 'access_denied'));
    });

    test('a pasted address is accepted only when it carries callback parameters', () {
      expect(AuthorizationCallback.uriFromText('  http://localhost:8765/bank-callback?code=a&state=b \n'), isNotNull);
      expect(AuthorizationCallback.uriFromText('http://localhost:8765/bank-callback'), isNull);
      expect(AuthorizationCallback.uriFromText('http://[broken'), isNull);
    });
  });

  test('authorization states look like random UUIDs', () {
    final generator = SecureAuthorizationStateGenerator(Random(7));

    final first = generator.next();
    final second = generator.next();

    expect(first, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')));
    expect(second, isNot(first));
  });

  group('platform listeners', () {
    final authorizationUrl = Uri.parse('https://bank.example/authorize');

    test('the web comes back to the hash route of the current origin', () async {
      final opened = <Uri>[];
      final listener = WebCallbackListener(
        Uri.parse('http://localhost:8080/#/profile'),
        launch: (url) async {
          opened.add(url);
          return true;
        },
      );

      await listener.open(authorizationUrl, returnMessage: 'ok');

      expect(listener.redirectUrl, 'http://localhost:8080/#/bank-callback');
      expect(opened, [authorizationUrl]);
      expect(await listener.callbacks.isEmpty, isTrue);
      await listener.close();
    });

    test('Android keeps only the bank callback deep links', () async {
      final callback = Uri.parse('depenses://bank-callback?code=a&state=b');
      final listener = AppLinksCallbackListener(
        links: Stream.fromIterable([Uri.parse('depenses://other'), callback]),
        launch: (_) async => true,
      );

      expect(listener.redirectUrl, 'depenses://bank-callback');
      expect(await listener.callbacks.toList(), [callback]);
      await listener.open(authorizationUrl, returnMessage: 'ok');
      await listener.close();
    });

    test('a browser that refuses to open is reported', () async {
      expect(
        openAuthorizationPage(authorizationUrl, (_) async => false),
        throwsA(isA<AuthorizationBrowserException>()),
      );
      expect(
        openAuthorizationPage(authorizationUrl, (_) async => throw PlatformException(code: 'ACTIVITY_NOT_FOUND')),
        throwsA(isA<AuthorizationBrowserException>()),
      );
    });
  });
}
