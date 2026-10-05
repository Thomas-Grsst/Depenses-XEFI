class BankAuthorizationRejectedException implements Exception {
  const BankAuthorizationRejectedException(this.reason);

  final String reason;

  @override
  String toString() => 'BankAuthorizationRejectedException: $reason';
}
