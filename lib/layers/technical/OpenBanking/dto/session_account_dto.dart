import 'json_amount.dart';

class SessionAccountDto {
  const SessionAccountDto({required this.uid, this.iban, this.name, this.currency});

  factory SessionAccountDto.fromJson(Map<String, dynamic> json) => SessionAccountDto(
    uid: json['uid'] as String,
    iban: jsonObject(json['account_id'])['iban'] as String?,
    name: json['name'] as String?,
    currency: json['currency'] as String?,
  );

  final String uid;
  final String? iban;
  final String? name;
  final String? currency;
}
