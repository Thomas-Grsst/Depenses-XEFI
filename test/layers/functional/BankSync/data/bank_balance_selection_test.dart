import 'package:depenses/layers/functional/BankSync/data/gateways/bank_data_gateway_impl.dart';
import 'package:depenses/layers/technical/OpenBanking/dto/balance_dto.dart';
import 'package:flutter_test/flutter_test.dart';

BalanceDto _balance(String type, double amount) => BalanceDto(type: type, amount: amount, currency: 'EUR');

void main() {
  test('the interim available balance wins over every other type', () {
    final balances = [_balance('CLBD', 1), _balance('ITBD', 2), _balance('CLAV', 3), _balance('ITAV', 4)];

    expect(BankDataGatewayImpl.preferredBalance(balances), 4);
  });

  test('without ITAV the closing available balance is used', () {
    expect(BankDataGatewayImpl.preferredBalance([_balance('CLBD', 1), _balance('ITBD', 2), _balance('CLAV', 3)]), 3);
  });

  test('without available balances the interim booked balance is used', () {
    expect(BankDataGatewayImpl.preferredBalance([_balance('CLBD', 1), _balance('ITBD', 2)]), 2);
  });

  test('the closing booked balance comes last among the known types', () {
    expect(BankDataGatewayImpl.preferredBalance([_balance('XPCD', 5), _balance('CLBD', 1)]), 1);
  });

  test('the preference does not depend on the order sent by the bank', () {
    expect(BankDataGatewayImpl.preferredBalance([_balance('ITAV', 4), _balance('CLAV', 3)]), 4);
    expect(BankDataGatewayImpl.preferredBalance([_balance('CLAV', 3), _balance('ITAV', 4)]), 4);
  });

  test('an unknown type is used only when nothing else is sent', () {
    expect(BankDataGatewayImpl.preferredBalance([_balance('XPCD', 5)]), 5);
  });

  test('no balance at all gives no amount', () {
    expect(BankDataGatewayImpl.preferredBalance(const []), isNull);
  });
}
