import 'package:depenses/layers/technical/Localization/money_format.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

String _plainSpaces(String value) => value.replaceAll(RegExp('[  ]'), ' ');

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  final money = MoneyFormat('fr_FR');

  test('amounts use french grouping, decimal comma and a trailing euro sign', () {
    expect(_plainSpaces(money.euros(1308.12)), '1 308,12 €');
    expect(_plainSpaces(money.wholeEuros(1308.4)), '1 308 €');
    expect(_plainSpaces(money.autoEuros(12)), '12 €');
    expect(_plainSpaces(money.autoEuros(12.5)), '12,50 €');
  });

  test('negative amounts use the minus sign', () {
    expect(_plainSpaces(money.euros(-3.2)), '−3,20 €');
    expect(_plainSpaces(money.withSign(-5, money.wholeEuros)), '−5 €');
    expect(_plainSpaces(money.withSign(0.001, money.wholeEuros)), '±0 €');
  });

  test('user input accepts comma, dot, spaces and the euro sign', () {
    expect(money.parse('12,5'), 12.5);
    expect(money.parse(' 1 200.40 €'), 1200.4);
    expect(money.parse(''), isNull);
    expect(money.inputText(45.6), '45,60');
  });

  test('percentages are rounded and signed', () {
    expect(_plainSpaces(money.percent(0.42)), '42 %');
    expect(_plainSpaces(money.signedPercent(-0.124)), '−12 %');
    expect(_plainSpaces(money.signedPercent(0.001)), '0 %');
  });
}
