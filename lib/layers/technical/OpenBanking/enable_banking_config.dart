class EnableBankingConfig {
  const EnableBankingConfig({required this.applicationId, required this.privateKeyPem, this.baseUrl = defaultBaseUrl});

  factory EnableBankingConfig.fromEnvironment() => EnableBankingConfig(
    applicationId: const String.fromEnvironment(applicationIdKey),
    privateKeyPem: const String.fromEnvironment(privateKeyKey).replaceAll(r'\n', '\n'),
  );

  static const applicationIdKey = 'ENABLE_BANKING_APP_ID';
  static const privateKeyKey = 'ENABLE_BANKING_PRIVATE_KEY';
  static const defaultBaseUrl = 'https://api.enablebanking.com';

  final String applicationId;
  final String privateKeyPem;
  final String baseUrl;

  bool get isConfigured => applicationId.isNotEmpty && privateKeyPem.isNotEmpty;
}
