import 'dart:convert';
import 'dart:io';

class LoopbackCallbackServer {
  HttpServer? _server;

  Future<bool> start({
    required int port,
    required String path,
    required String page,
    required void Function(Uri callback) onCallback,
  }) async {
    if (_server != null) return true;
    try {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      _server = server;
      server.listen((request) => _answer(request, path, page, onCallback));
      return true;
    } on SocketException {
      return false;
    }
  }

  Future<void> stop() async {
    final server = _server;
    _server = null;
    await server?.close(force: true);
  }

  static Future<void> _answer(HttpRequest request, String path, String page, void Function(Uri) onCallback) async {
    final isCallback = request.uri.path == path;
    if (isCallback) onCallback(request.requestedUri);
    request.response
      ..statusCode = isCallback ? HttpStatus.ok : HttpStatus.notFound
      ..headers.contentType = ContentType.html;
    if (isCallback) request.response.write(_html(page));
    await request.response.close();
  }

  static String _html(String message) =>
      '<!doctype html><html><head><meta charset="utf-8"></head>'
      '<body style="font-family:sans-serif;padding:48px;text-align:center">'
      '<p>${const HtmlEscape().convert(message)}</p></body></html>';
}
