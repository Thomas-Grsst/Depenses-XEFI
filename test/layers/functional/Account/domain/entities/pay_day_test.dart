import 'package:depenses/layers/functional/Account/domain/entities/pay_day.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('shifting wraps around the 31 days of a month', () {
    expect(PayDay.shift(15, 1), 16);
    expect(PayDay.shift(31, 1), 1);
    expect(PayDay.shift(1, -1), 31);
  });

  test('only days after the 28th fall back in short months', () {
    expect(PayDay.fallsBackInShortMonths(28), isFalse);
    expect(PayDay.fallsBackInShortMonths(29), isTrue);
  });
}
