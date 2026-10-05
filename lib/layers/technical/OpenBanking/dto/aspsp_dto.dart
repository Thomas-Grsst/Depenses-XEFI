import 'json_amount.dart';

class AspspDto {
  const AspspDto({required this.name, required this.country, this.logoUrl, this.maximumConsentValidity});

  factory AspspDto.fromJson(Map<String, dynamic> json) => AspspDto(
    name: json['name'] as String,
    country: json['country'] as String,
    logoUrl: json['logo'] as String?,
    maximumConsentValidity: (json['maximum_consent_validity'] as num?)?.toInt(),
  );

  static List<AspspDto> listFromJson(Map<String, dynamic> json) => [
    for (final item in jsonObjects(json['aspsps'])) AspspDto.fromJson(item),
  ];

  final String name;
  final String country;
  final String? logoUrl;
  final int? maximumConsentValidity;
}
