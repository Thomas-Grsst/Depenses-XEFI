import 'json_amount.dart';

class BalanceDto {
  const BalanceDto({required this.type, required this.amount, required this.currency});

  factory BalanceDto.fromJson(Map<String, dynamic> json) {
    final amount = jsonObject(json['balance_amount']);
    return BalanceDto(
      type: json['balance_type'] as String? ?? '',
      amount: parseJsonAmount(amount['amount']),
      currency: amount['currency'] as String? ?? '',
    );
  }

  static List<BalanceDto> listFromJson(Map<String, dynamic> json) => [
    for (final item in jsonObjects(json['balances'])) BalanceDto.fromJson(item),
  ];

  final String type;
  final double amount;
  final String currency;
}
