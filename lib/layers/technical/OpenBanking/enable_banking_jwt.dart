import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'enable_banking_config.dart';

const _issuer = 'enablebanking.com';
const _audience = 'api.enablebanking.com';
const _lifetime = Duration(hours: 1);
const _renewalMargin = Duration(minutes: 5);

class EnableBankingJwt {
  EnableBankingJwt(this._config, this._now);

  final EnableBankingConfig _config;
  final DateTime Function() _now;
  String? _token;
  DateTime? _expiresAt;

  String current() {
    final now = _now();
    final token = _token;
    final expiresAt = _expiresAt;
    if (token != null && expiresAt != null && now.isBefore(expiresAt.subtract(_renewalMargin))) return token;
    final issuedAt = now.millisecondsSinceEpoch ~/ 1000;
    final signed = JWT(
      {'iss': _issuer, 'aud': _audience, 'iat': issuedAt, 'exp': issuedAt + _lifetime.inSeconds},
      header: {'kid': _config.applicationId},
    ).sign(RSAPrivateKey(_config.privateKeyPem), algorithm: JWTAlgorithm.RS256, noIssueAt: true);
    _token = signed;
    _expiresAt = now.add(_lifetime);
    return signed;
  }
}
