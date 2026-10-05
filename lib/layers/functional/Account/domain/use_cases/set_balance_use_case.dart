import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/technical/Calendar/calendar_day.dart';
import 'package:depenses/layers/technical/Calendar/clock.dart';

import '../gateways/account_gateway.dart';

class SetBalanceUseCase {
  SetBalanceUseCase(this._account, this._expenses, this._clock);

  final AccountGateway _account;
  final ExpenseGateway _expenses;
  final Clock _clock;

  Future<void> call(double amount) {
    final today = _clock.today();
    final alreadyCounted = [
      for (final e in _expenses.all())
        if (e.date.isSameDay(today)) e.id,
    ];
    return _account.save(_account.get().withBalance(amount, today, alreadyCounted));
  }
}
