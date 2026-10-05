sealed class BankApiException implements Exception {
  const BankApiException(this.detail);

  final String detail;

  @override
  String toString() => '$runtimeType: $detail';
}

class BankAccessExpiredException extends BankApiException {
  const BankAccessExpiredException(super.detail);
}

class BankRateLimitedException extends BankApiException {
  const BankRateLimitedException(super.detail);
}

class BankUnavailableException extends BankApiException {
  const BankUnavailableException(super.detail);
}

class BankResponseFormatException extends BankApiException {
  const BankResponseFormatException(super.detail);
}

class BankSyncNotConfiguredException extends BankApiException {
  const BankSyncNotConfiguredException() : super('Enable Banking credentials are missing');
}
