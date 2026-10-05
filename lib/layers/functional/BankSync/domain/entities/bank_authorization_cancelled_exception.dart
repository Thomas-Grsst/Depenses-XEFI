class BankAuthorizationCancelledException implements Exception {
  const BankAuthorizationCancelledException([this.reason]);

  final String? reason;

  @override
  String toString() => 'BankAuthorizationCancelledException: ${reason ?? 'no authorization code'}';
}
