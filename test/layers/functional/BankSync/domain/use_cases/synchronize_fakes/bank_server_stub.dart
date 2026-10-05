import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const bankSyncFixtures = 'test/layers/functional/BankSync/fixtures';
const _pageSize = 2;

List<Map<String, dynamic>> readTransactionFixture(String name) {
  final json = jsonDecode(File('$bankSyncFixtures/$name').readAsStringSync()) as Map<String, dynamic>;
  return [for (final item in json['transactions'] as List) Map<String, dynamic>.from(item as Map)];
}

class BankServerStub {
  final Map<String, List<Map<String, dynamic>>> transactionsByAccount = {};
  final Map<String, double> availableBalanceByAccount = {};
  final Set<String> expiredAccounts = {};
  final List<String> requestedWindows = [];
  var isDown = false;

  late final http.Client client = MockClient(_reply);

  Future<http.Response> _reply(http.Request request) async {
    final segments = request.url.pathSegments;
    final uid = segments[1];
    if (isDown) return http.Response('{"error":"ASPSP_ERROR"}', 503);
    if (expiredAccounts.contains(uid)) return http.Response('{"error":"EXPIRED_SESSION"}', 401);
    if (segments.last == 'balances') return _json(_balances(uid));
    requestedWindows.add('$uid:${request.url.queryParameters['date_from']}');
    final offset = int.tryParse(request.url.queryParameters['continuation_key'] ?? '') ?? 0;
    final all = transactionsByAccount[uid] ?? const [];
    final end = offset + _pageSize < all.length ? offset + _pageSize : all.length;
    return _json({'transactions': all.sublist(offset, end), if (end < all.length) 'continuation_key': '$end'});
  }

  Map<String, dynamic> _balances(String uid) => {
    'balances': [
      {
        'balance_type': 'CLBD',
        'balance_amount': {'amount': '9999.00', 'currency': 'EUR'},
      },
      {
        'balance_type': 'ITAV',
        'balance_amount': {'amount': '${availableBalanceByAccount[uid] ?? 0}', 'currency': 'EUR'},
      },
    ],
  };

  static http.Response _json(Map<String, dynamic> body) =>
      http.Response.bytes(utf8.encode(jsonEncode(body)), 200, headers: {'content-type': 'application/json'});
}
