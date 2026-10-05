import 'package:equatable/equatable.dart';

class SyncReport extends Equatable {
  const SyncReport({
    this.created = 0,
    this.updated = 0,
    this.matched = 0,
    this.attachedToRecurrence = 0,
    this.removed = 0,
    this.skipped = 0,
    this.bankBalance,
  });

  final int created;
  final int updated;
  final int matched;
  final int attachedToRecurrence;
  final int removed;
  final int skipped;
  final double? bankBalance;

  bool get isUpToDate => created + updated + matched + attachedToRecurrence + removed == 0;

  SyncReport operator +(SyncReport other) => SyncReport(
    created: created + other.created,
    updated: updated + other.updated,
    matched: matched + other.matched,
    attachedToRecurrence: attachedToRecurrence + other.attachedToRecurrence,
    removed: removed + other.removed,
    skipped: skipped + other.skipped,
    bankBalance: other.bankBalance ?? bankBalance,
  );

  @override
  List<Object?> get props => [created, updated, matched, attachedToRecurrence, removed, skipped, bankBalance];
}
