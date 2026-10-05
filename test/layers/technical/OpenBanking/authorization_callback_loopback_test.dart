import 'dart:convert';
import 'dart:io';

import 'package:depenses/layers/technical/OpenBanking/callback/loopback_callback_listener.dart';
import 'package:depenses/layers/technical/OpenBanking/callback/platform_callback_listener.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

const _port = 8799;

Future<(int, String)> _get(String path) async {
  final client = HttpClient();
  try {
    final response = await (await client.getUrl(Uri.parse('http://127.0.0.1:$_port$path'))).close();
    return (response.statusCode, await response.transform(utf8.decoder).join());
  } finally {
    client.close(force: true);
  }
}

void main() {
  late List<Uri> opened;
  late LoopbackCallbackListener listener;

  setUp(() {
    opened = [];
    listener = LoopbackCallbackListener(
      port: _port,
      launch: (url) async {
        opened.add(url);
        return true;
      },
    );
  });
  tearDown(() => listener.close());

  test('the local loop receives the bank redirect and greets the user', () async {
    final callback = listener.callbacks.first;

    await listener.open(Uri.parse('https://bank.example/authorize'), returnMessage: 'C’est fait <3');
    final (status, body) = await _get('/bank-callback?code=abc&state=s1');

    expect(listener.redirectUrl, 'http://localhost:$_port/bank-callback');
    expect(opened, [Uri.parse('https://bank.example/authorize')]);
    expect(status, HttpStatus.ok);
    expect(body, contains('C’est fait &lt;3'));
    expect((await callback).queryParameters, {'code': 'abc', 'state': 's1'});
  });

  test('other paths are ignored and opening twice keeps one server', () async {
    await listener.open(Uri.parse('https://bank.example/authorize'), returnMessage: 'ok');
    await listener.open(Uri.parse('https://bank.example/authorize'), returnMessage: 'ok');

    final (status, _) = await _get('/favicon.ico');

    expect(status, HttpStatus.notFound);
    expect(opened, hasLength(2));
  });

  test('desktop platforms listen on the local loop', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    final platformListener = createPlatformCallbackListener();
    addTearDown(platformListener.close);

    expect(platformListener.redirectUrl, 'http://localhost:8765/bank-callback');
  });

  test('a busy port still opens the browser so the address can be pasted', () async {
    final occupant = await HttpServer.bind(InternetAddress.loopbackIPv4, _port);
    addTearDown(() => occupant.close(force: true));

    await listener.open(Uri.parse('https://bank.example/authorize'), returnMessage: 'ok');

    expect(opened, hasLength(1));
  });
}
