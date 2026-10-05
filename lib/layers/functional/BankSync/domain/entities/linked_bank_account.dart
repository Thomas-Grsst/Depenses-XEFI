import 'package:equatable/equatable.dart';

enum LinkedAccountStatus { linked, expired }

class LinkedBankAccount extends Equatable {
  const LinkedBankAccount({
    required this.uid,
    required this.bankName,
    required this.country,
    required this.label,
    required this.accessValidUntil,
    this.lastSyncedAt,
    this.lastBankBalance,
    this.isRevoked = false,
  });

  final String uid;
  final String bankName;
  final String country;
  final String label;
  final DateTime accessValidUntil;
  final DateTime? lastSyncedAt;
  final double? lastBankBalance;
  final bool isRevoked;

  LinkedAccountStatus statusAt(DateTime now) =>
      isRevoked || !now.isBefore(accessValidUntil) ? LinkedAccountStatus.expired : LinkedAccountStatus.linked;

  LinkedBankAccount copyWith({
    DateTime? accessValidUntil,
    DateTime? lastSyncedAt,
    double? lastBankBalance,
    bool? isRevoked,
  }) => LinkedBankAccount(
    uid: uid,
    bankName: bankName,
    country: country,
    label: label,
    accessValidUntil: accessValidUntil ?? this.accessValidUntil,
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    lastBankBalance: lastBankBalance ?? this.lastBankBalance,
    isRevoked: isRevoked ?? this.isRevoked,
  );

  @override
  List<Object?> get props => [
    uid,
    bankName,
    country,
    label,
    accessValidUntil,
    lastSyncedAt,
    lastBankBalance,
    isRevoked,
  ];
}
