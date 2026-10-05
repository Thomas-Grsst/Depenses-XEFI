import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'dto/aspsp_dto.dart';
import 'dto/authorization_start_dto.dart';
import 'dto/balance_dto.dart';
import 'dto/session_dto.dart';
import 'dto/transaction_page_dto.dart';
import 'enable_banking_config.dart';
import 'enable_banking_errors.dart';
import 'enable_banking_jwt.dart';

const _timeout = Duration(seconds: 20);
const _personal = 'personal';

class EnableBankingClient {
  EnableBankingClient(this._config, this._transport, this._jwt);

  final EnableBankingConfig _config;
  final http.Client _transport;
  final EnableBankingJwt _jwt;

  bool get isConfigured => _config.isConfigured;

  Future<List<AspspDto>> listBanks({required String country}) async =>
      AspspDto.listFromJson(await _send('GET', '/aspsps', query: {'country': country}));

  Future<AuthorizationStartDto> startAuthorization({
    required String bankName,
    required String country,
    required DateTime validUntil,
    required String state,
    required String redirectUrl,
  }) async => AuthorizationStartDto.fromJson(
    await _send(
      'POST',
      '/auth',
      body: {
        'access': {'valid_until': validUntil.toUtc().toIso8601String()},
        'aspsp': {'name': bankName, 'country': country},
        'state': state,
        'redirect_url': redirectUrl,
        'psu_type': _personal,
      },
    ),
  );

  Future<SessionDto> createSession({required String code}) async =>
      SessionDto.fromJson(await _send('POST', '/sessions', body: {'code': code}));

  Future<List<BalanceDto>> balances(String accountUid) async =>
      BalanceDto.listFromJson(await _send('GET', '/accounts/$accountUid/balances'));

  Future<TransactionPageDto> transactions(String accountUid, {required DateTime from, String? continuationKey}) async =>
      TransactionPageDto.fromJson(
        await _send(
          'GET',
          '/accounts/$accountUid/transactions',
          query: {'date_from': _day(from), 'continuation_key': ?continuationKey},
        ),
      );

  Future<void> deleteSession(String sessionId) => _send('DELETE', '/sessions/$sessionId');

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    if (!isConfigured) throw const BankSyncNotConfiguredException();
    final request = http.Request(method, Uri.parse('${_config.baseUrl}$path').replace(queryParameters: query))
      ..headers['Authorization'] = 'Bearer ${_jwt.current()}'
      ..headers['Content-Type'] = 'application/json';
    if (body != null) request.body = jsonEncode(body);
    final response = await _execute(request);
    _throwOnError(response);
    return _decode(utf8.decode(response.bodyBytes));
  }

  Future<http.Response> _execute(http.Request request) async {
    try {
      return await http.Response.fromStream(await _transport.send(request).timeout(_timeout));
    } on TimeoutException {
      throw BankUnavailableException('${request.method} ${request.url.path} timed out');
    } on http.ClientException catch (error) {
      throw BankUnavailableException(error.message);
    }
  }

  void _throwOnError(http.Response response) {
    final status = response.statusCode;
    if (status < 400) return;
    final detail = '$status ${utf8.decode(response.bodyBytes, allowMalformed: true)}';
    if (status == 401 || status == 403) throw BankAccessExpiredException(detail);
    if (status == 429) throw BankRateLimitedException(detail);
    throw BankUnavailableException(detail);
  }

  static Map<String, dynamic> _decode(String body) {
    if (body.trim().isEmpty) return const {};
    try {
      return Map<String, dynamic>.from(jsonDecode(body) as Map);
    } on FormatException catch (error) {
      throw BankResponseFormatException(error.message);
    } on TypeError catch (error) {
      throw BankResponseFormatException(error.toString());
    }
  }

  static String _day(DateTime date) => date.toIso8601String().substring(0, 10);
}
