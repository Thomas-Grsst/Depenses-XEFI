import 'json_amount.dart';
import 'session_account_dto.dart';

class SessionDto {
  const SessionDto({
    required this.sessionId,
    required this.accounts,
    required this.validUntil,
    this.bankName,
    this.bankCountry,
  });

  factory SessionDto.fromJson(Map<String, dynamic> json) {
    final aspsp = jsonObject(json['aspsp']);
    return SessionDto(
      sessionId: json['session_id'] as String,
      accounts: [for (final item in jsonObjects(json['accounts'])) SessionAccountDto.fromJson(item)],
      validUntil: parseJsonDate(jsonObject(json['access'])['valid_until']),
      bankName: aspsp['name'] as String?,
      bankCountry: aspsp['country'] as String?,
    );
  }

  final String sessionId;
  final List<SessionAccountDto> accounts;
  final DateTime? validUntil;
  final String? bankName;
  final String? bankCountry;
}
