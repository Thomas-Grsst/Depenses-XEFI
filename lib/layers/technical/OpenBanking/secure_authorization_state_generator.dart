import 'dart:math';

import 'authorization_state_generator.dart';

const _byteCount = 16;
const _versionByte = 6;
const _variantByte = 8;

class SecureAuthorizationStateGenerator implements AuthorizationStateGenerator {
  SecureAuthorizationStateGenerator([Random? random]) : _random = random ?? Random.secure();

  final Random _random;

  @override
  String next() {
    final bytes = [for (var i = 0; i < _byteCount; i++) _random.nextInt(256)];
    bytes[_versionByte] = (bytes[_versionByte] & 0x0f) | 0x40;
    bytes[_variantByte] = (bytes[_variantByte] & 0x3f) | 0x80;
    final hex = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
