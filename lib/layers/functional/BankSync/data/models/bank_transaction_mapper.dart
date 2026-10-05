import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/OpenBanking/dto/transaction_dto.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';
import 'package:depenses/layers/technical/TextMatching/normalize_for_matching.dart';

import '../../domain/entities/bank_transaction.dart';

const _debitIndicator = 'DBIT';
const _creditIndicator = 'CRDT';
const _pendingStatus = 'PDNG';

abstract final class BankTransactionMapper {
  static BankTransaction? fromDto(TransactionDto dto) {
    final date = (dto.bookingDate ?? dto.valueDate ?? dto.transactionDate)?.dateOnly;
    if (date == null) return null;
    final direction = _directionOf(dto);
    final amount = dto.amount.abs();
    final rawLabel = _rawLabelOf(dto, direction);
    return BankTransaction(
      id: _present(dto.entryReference) ?? _present(dto.transactionId) ?? _fingerprint(date, amount, rawLabel),
      date: date,
      amount: amount,
      direction: direction,
      isPending: dto.status == _pendingStatus,
      rawLabel: rawLabel,
    );
  }

  static BankTransactionDirection _directionOf(TransactionDto dto) => switch (dto.creditDebitIndicator) {
    _debitIndicator => BankTransactionDirection.debit,
    _creditIndicator => BankTransactionDirection.credit,
    _ => dto.amount < 0 ? BankTransactionDirection.debit : BankTransactionDirection.credit,
  };

  static String _rawLabelOf(TransactionDto dto, BankTransactionDirection direction) {
    final counterpart = direction == BankTransactionDirection.debit ? dto.creditorName : dto.debtorName;
    final firstRemittance = dto.remittanceInformation.map(_present).nonNulls.firstOrNull;
    return _present(counterpart) ?? firstRemittance ?? '';
  }

  static String _fingerprint(DateTime date, double amount, String rawLabel) =>
      '${encodeDay(date)}|${amount.toStringAsFixed(2)}|${normalizeForMatching(rawLabel)}';

  static String? _present(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
