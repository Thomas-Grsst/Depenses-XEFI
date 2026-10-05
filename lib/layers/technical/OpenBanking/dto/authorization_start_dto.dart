class AuthorizationStartDto {
  const AuthorizationStartDto({required this.url, this.authorizationId});

  factory AuthorizationStartDto.fromJson(Map<String, dynamic> json) => AuthorizationStartDto(
    url: Uri.parse(json['url'] as String),
    authorizationId: json['authorization_id'] as String?,
  );

  final Uri url;
  final String? authorizationId;
}
