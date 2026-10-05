import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/test_dependencies.dart';

void main() {
  test('expenses written by the previous version are read and written back unchanged', () async {
    final legacy = {
      'id': 'a1',
      'name': 'Netflix',
      'amount': 13.49,
      'date': '2026-09-03',
      'cat': 'loi',
      'labels': ['Abonnement'],
      'recId': 'r1',
      'roundUp': 0.0,
    };
    final dependencies = TestDependencies(
      data: {
        'expenses': [legacy],
      },
    );
    addTearDown(dependencies.dispose);
    final gateway = dependencies.get<ExpenseGateway>();

    final expense = gateway.all().single;
    await gateway.update(expense);

    expect(expense.date, DateTime(2026, 9, 3));
    expect(expense.recurrenceId, 'r1');
    expect((dependencies.store.read(LedgerSection.expenses)! as List).single, legacy);
  });
}
