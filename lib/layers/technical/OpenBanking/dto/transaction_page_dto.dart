import 'json_amount.dart';
import 'transaction_dto.dart';

class TransactionPageDto {
  const TransactionPageDto({required this.transactions, this.continuationKey});

  factory TransactionPageDto.fromJson(Map<String, dynamic> json) => TransactionPageDto(
    transactions: [for (final item in jsonObjects(json['transactions'])) TransactionDto.fromJson(item)],
    continuationKey: json['continuation_key'] as String?,
  );

  final List<TransactionDto> transactions;
  final String? continuationKey;
}
