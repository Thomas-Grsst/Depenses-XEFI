import 'package:depenses/layers/functional/Account/domain/entities/account_settings.dart';
import 'package:depenses/layers/functional/Account/domain/entities/balance_projection.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:flutter_test/flutter_test.dart';

Expense _expense(String id, double amount, DateTime date, {double roundUp = 0}) =>
    Expense(id: id, name: id, amount: amount, date: date, categoryKey: 'ali', roundUp: roundUp);

void main() {
  final settings = AccountSettings(
    income: 2000,
    payDay: 31,
    balance: 1000,
    balanceDate: DateTime(2026, 10, 10),
    balanceSkip: const ['sameDayCounted'],
  );

  test('pay day is moved to the last day of shorter months', () {
    final projection = BalanceProjection(settings, const []);

    expect(projection.payDates(DateTime(2026, 11, 1), DateTime(2027, 2, 28)), [
      DateTime(2026, 11, 30),
      DateTime(2026, 12, 31),
      DateTime(2027, 1, 31),
      DateTime(2027, 2, 28),
    ]);
  });

  test('balance subtracts later expenses with their round-up and adds salaries', () {
    final projection = BalanceProjection(settings, [
      _expense('sameDayCounted', 50, DateTime(2026, 10, 10)),
      _expense('sameDayNew', 20, DateTime(2026, 10, 10)),
      _expense('later', 9.4, DateTime(2026, 10, 20), roundUp: 0.6),
      _expense('before', 500, DateTime(2026, 10, 1)),
    ]);

    expect(projection.balanceAt(DateTime(2026, 10, 30)), 1000 - 20 - 10);
    expect(projection.balanceAt(DateTime(2026, 10, 31)), 1000 - 20 - 10 + 2000);
  });

  test('without an entered balance the balance is zero', () {
    const projection = BalanceProjection(AccountSettings(income: 2000), []);

    expect(projection.balanceAt(DateTime(2026, 10, 31)), 0);
  });
}
