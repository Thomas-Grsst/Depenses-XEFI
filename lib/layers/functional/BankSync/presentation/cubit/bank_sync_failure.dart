import 'package:depenses/layers/technical/OpenBanking/enable_banking_errors.dart';

enum BankSyncFailure {
  none,
  expired,
  unavailable,
  notConfigured,
  browserUnavailable;

  static BankSyncFailure of(BankApiException error) => switch (error) {
    BankAccessExpiredException() => BankSyncFailure.expired,
    BankSyncNotConfiguredException() => BankSyncFailure.notConfigured,
    BankRateLimitedException() ||
    BankUnavailableException() ||
    BankResponseFormatException() => BankSyncFailure.unavailable,
  };
}
