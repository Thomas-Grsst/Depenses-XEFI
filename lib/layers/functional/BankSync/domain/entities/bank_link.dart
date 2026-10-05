import 'package:equatable/equatable.dart';

enum BankLinkKind {
  created('created'),
  matched('matched'),
  recurrence('recurrence');

  const BankLinkKind(this.storageKey);

  final String storageKey;

  static BankLinkKind fromStorageKey(String? key) =>
      BankLinkKind.values.firstWhere((kind) => kind.storageKey == key, orElse: () => BankLinkKind.created);
}

class BankLink extends Equatable {
  const BankLink({
    required this.transactionId,
    required this.expenseId,
    required this.accountUid,
    required this.kind,
    required this.wasPending,
  });

  final String transactionId;
  final String expenseId;
  final String accountUid;
  final BankLinkKind kind;
  final bool wasPending;

  BankLink copyWith({bool? wasPending}) => BankLink(
    transactionId: transactionId,
    expenseId: expenseId,
    accountUid: accountUid,
    kind: kind,
    wasPending: wasPending ?? this.wasPending,
  );

  @override
  List<Object?> get props => [transactionId, expenseId, accountUid, kind, wasPending];
}
