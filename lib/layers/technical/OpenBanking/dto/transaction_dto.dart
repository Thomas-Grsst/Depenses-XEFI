import 'json_amount.dart';

class TransactionDto {
  const TransactionDto({
    required this.amount,
    required this.currency,
    required this.creditDebitIndicator,
    required this.status,
    this.entryReference,
    this.transactionId,
    this.bookingDate,
    this.valueDate,
    this.transactionDate,
    this.remittanceInformation = const [],
    this.creditorName,
    this.debtorName,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    final amount = jsonObject(json['transaction_amount']);
    return TransactionDto(
      amount: parseJsonAmount(amount['amount']),
      currency: amount['currency'] as String? ?? '',
      creditDebitIndicator: json['credit_debit_indicator'] as String? ?? '',
      status: json['status'] as String? ?? '',
      entryReference: json['entry_reference'] as String?,
      transactionId: json['transaction_id'] as String?,
      bookingDate: parseJsonDate(json['booking_date']),
      valueDate: parseJsonDate(json['value_date']),
      transactionDate: parseJsonDate(json['transaction_date']),
      remittanceInformation: List<String>.from(json['remittance_information'] as List? ?? const []),
      creditorName: jsonObject(json['creditor'])['name'] as String?,
      debtorName: jsonObject(json['debtor'])['name'] as String?,
    );
  }

  final double amount;
  final String currency;
  final String creditDebitIndicator;
  final String status;
  final String? entryReference;
  final String? transactionId;
  final DateTime? bookingDate;
  final DateTime? valueDate;
  final DateTime? transactionDate;
  final List<String> remittanceInformation;
  final String? creditorName;
  final String? debtorName;
}
