import 'package:depenses/layers/functional/BankSync/domain/entities/bank_link.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence_draft.dart';
import 'package:depenses/layers/functional/Recurrences/domain/gateways/recurrence_gateway.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/add_recurrence_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/materialize_due_recurrences_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import 'synchronize_fakes/bank_server_stub.dart';
import 'synchronize_fakes/bank_sync_harness.dart';

Map<String, dynamic> _rentDebit(String date) => {
  'entry_reference': 'rent-$date',
  'transaction_amount': {'amount': '800.00', 'currency': 'EUR'},
  'credit_debit_indicator': 'DBIT',
  'status': 'BOOK',
  'booking_date': date,
  'remittance_information': ['VIR SEPA LOYER OCTOBRE'],
};

void main() {
  late BankSyncHarness harness;

  setUp(() {
    harness = BankSyncHarness();
    harness.server.transactionsByAccount['acc-1'] = readTransactionFixture('october_transactions.json');
  });
  tearDown(() => harness.dispose());

  Future<Recurrence> addRent(DateTime start) => harness.dependencies.get<AddRecurrenceUseCase>()(
    RecurrenceDraft(name: 'Loyer', amount: 800, categoryKey: 'log', frequency: Frequency.month, start: start),
  );

  List<Expense> octoberRents() =>
      harness.expenses.where((e) => e.name == 'Loyer' && e.date.month == 10 && e.date.year == 2026).toList();

  test('the real rent replaces its generated expense, even over ten synchronisations', () async {
    final rent = await addRent(DateTime(2026, 8, 5));
    harness.server.transactionsByAccount['acc-1']!.add(_rentDebit('2026-10-06'));

    final report = await harness.synchronize();
    for (var run = 1; run < 10; run++) {
      harness.now = harness.now.add(const Duration(hours: 2));
      expect((await harness.synchronize()).isUpToDate, isTrue);
    }

    expect(report.attachedToRecurrence, 1);
    expect(report.created, 4);
    final october = octoberRents().single;
    expect(october.recurrenceId, rent.id);
    expect(october.bankTransactionId, 'rent-2026-10-06');
    expect(october.date, DateTime(2026, 10, 6));
    expect(harness.expenses, hasLength(7));
    expect(harness.links.all().singleWhere((l) => l.expenseId == october.id).kind, BankLinkKind.recurrence);
  });

  test('an early rent stops the generation of its upcoming occurrence', () async {
    final rent = await addRent(DateTime(2026, 8, 17));
    harness.server.transactionsByAccount['acc-1']!.add(_rentDebit('2026-10-14'));

    final report = await harness.synchronize();
    harness.dependencies.clock.current = DateTime(2026, 10, 20);
    await harness.dependencies.get<MaterializeDueRecurrencesUseCase>()();

    expect(report.attachedToRecurrence, 1);
    expect(octoberRents().single.recurrenceId, rent.id);
    expect(octoberRents().single.isImported, isTrue);
    expect(harness.dependencies.get<RecurrenceGateway>().byId(rent.id)!.lastGeneratedOn, DateTime(2026, 10, 20));
  });
}
