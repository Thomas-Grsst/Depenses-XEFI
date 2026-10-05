import 'package:depenses/layers/functional/BankSync/data/models/bank_transaction_mapper.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/bank_transaction.dart';
import 'package:depenses/layers/technical/OpenBanking/dto/transaction_dto.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionDto _dto({
  double amount = 12.4,
  String indicator = 'DBIT',
  String status = 'BOOK',
  String? entryReference,
  String? transactionId,
  DateTime? bookingDate,
  DateTime? valueDate,
  DateTime? transactionDate,
  List<String> remittance = const ['CB CARREFOUR 03/10'],
  String? creditorName,
  String? debtorName,
}) => TransactionDto(
  amount: amount,
  currency: 'EUR',
  creditDebitIndicator: indicator,
  status: status,
  entryReference: entryReference,
  transactionId: transactionId,
  bookingDate: bookingDate,
  valueDate: valueDate,
  transactionDate: transactionDate,
  remittanceInformation: remittance,
  creditorName: creditorName,
  debtorName: debtorName,
);

void main() {
  test('identifies a transaction by its entry reference first', () {
    final transaction = BankTransactionMapper.fromDto(
      _dto(entryReference: 'ref-1', transactionId: 'tx-1', bookingDate: DateTime(2026, 10, 3)),
    );

    expect(transaction?.id, 'ref-1');
  });

  test('falls back on the transaction id, then on a fingerprint', () {
    final withTransactionId = BankTransactionMapper.fromDto(
      _dto(entryReference: ' ', transactionId: 'tx-1', bookingDate: DateTime(2026, 10, 3)),
    );
    final anonymous = BankTransactionMapper.fromDto(
      _dto(amount: 4.5, bookingDate: DateTime(2026, 10, 3), remittance: const ['CB  Boulangerie Élise']),
    );

    expect(withTransactionId?.id, 'tx-1');
    expect(anonymous?.id, '2026-10-03|4.50|cb boulangerie elise');
  });

  test('dates the transaction by booking, then value, then transaction date', () {
    final booked = _dto(
      entryReference: 'a',
      bookingDate: DateTime(2026, 10, 3),
      valueDate: DateTime(2026, 10, 4),
      transactionDate: DateTime(2026, 10, 2),
    );
    final valued = _dto(
      entryReference: 'b',
      valueDate: DateTime(2026, 10, 4, 13),
      transactionDate: DateTime(2026, 10, 2),
    );
    final initiated = _dto(entryReference: 'c', transactionDate: DateTime(2026, 10, 2));

    expect(BankTransactionMapper.fromDto(booked)?.date, DateTime(2026, 10, 3));
    expect(BankTransactionMapper.fromDto(valued)?.date, DateTime(2026, 10, 4));
    expect(BankTransactionMapper.fromDto(initiated)?.date, DateTime(2026, 10, 2));
    expect(BankTransactionMapper.fromDto(_dto(entryReference: 'd')), isNull);
  });

  test('reads the direction, the absolute amount and the pending status', () {
    final debit = BankTransactionMapper.fromDto(
      _dto(entryReference: 'a', amount: -19.99, status: 'PDNG', bookingDate: DateTime(2026, 10, 3)),
    )!;
    final credit = BankTransactionMapper.fromDto(
      _dto(entryReference: 'b', indicator: 'CRDT', amount: 2400, bookingDate: DateTime(2026, 10, 1)),
    )!;
    final unsigned = BankTransactionMapper.fromDto(
      _dto(entryReference: 'c', indicator: '', amount: -3, bookingDate: DateTime(2026, 10, 1)),
    )!;

    expect(debit.amount, 19.99);
    expect(debit.direction, BankTransactionDirection.debit);
    expect(debit.isPending, isTrue);
    expect(credit.direction, BankTransactionDirection.credit);
    expect(credit.isPending, isFalse);
    expect(unsigned.direction, BankTransactionDirection.debit);
  });

  test('labels a debit by its creditor and a credit by its debtor, else by the first remittance line', () {
    final debit = _dto(entryReference: 'a', bookingDate: DateTime(2026, 10, 3), creditorName: 'CARREFOUR');
    final credit = _dto(
      entryReference: 'b',
      indicator: 'CRDT',
      bookingDate: DateTime(2026, 10, 3),
      creditorName: 'IGNORED',
      debtorName: 'EMPLOYEUR SA',
    );
    final anonymous = _dto(
      entryReference: 'c',
      bookingDate: DateTime(2026, 10, 3),
      remittance: const ['', 'PRLV FREE'],
    );
    final blank = _dto(entryReference: 'd', bookingDate: DateTime(2026, 10, 3), remittance: const []);

    expect(BankTransactionMapper.fromDto(debit)?.rawLabel, 'CARREFOUR');
    expect(BankTransactionMapper.fromDto(credit)?.rawLabel, 'EMPLOYEUR SA');
    expect(BankTransactionMapper.fromDto(anonymous)?.rawLabel, 'PRLV FREE');
    expect(BankTransactionMapper.fromDto(blank)?.rawLabel, '');
  });
}
