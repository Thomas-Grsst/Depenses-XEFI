import 'package:depenses/layers/functional/Expenses/domain/entities/expense_draft.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/add_expense_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/accept_suggestion_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/detect_recurring_expenses_use_case.dart';
import 'package:depenses/layers/functional/Recurrences/domain/use_cases/materialize_due_recurrences_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import 'synchronize_fakes/bank_sync_harness.dart';

Map<String, dynamic> _netflixDebit(String date) => {
  'entry_reference': 'netflix-$date',
  'transaction_amount': {'amount': '13.49', 'currency': 'EUR'},
  'credit_debit_indicator': 'DBIT',
  'status': 'BOOK',
  'booking_date': date,
  'remittance_information': ['PRLV SEPA NETFLIX'],
};

void main() {
  late BankSyncHarness harness;

  setUp(() => harness = BankSyncHarness());
  tearDown(() => harness.dispose());

  List<String> detected() => [
    for (final suggestion in harness.dependencies.get<DetectRecurringExpensesUseCase>()()) suggestion.key,
  ];

  test('an imported debit repeated every month is suggested as a recurrence', () async {
    harness.server.transactionsByAccount['acc-1'] = [
      for (final date in ['2026-08-03', '2026-09-04', '2026-10-03']) _netflixDebit(date),
    ];

    await harness.synchronize();

    final suggestion = harness.dependencies.get<DetectRecurringExpensesUseCase>()().single;
    expect(suggestion.key, 'netflix');
    expect(suggestion.months, 3);
    expect(suggestion.expenseIds, hasLength(3));
  });

  test('imported and manual expenses of the same merchant are detected together', () async {
    await harness.dependencies.get<AddExpenseUseCase>()(
      ExpenseDraft(name: 'Netflix', amount: 13.49, date: DateTime(2026, 8, 3), categoryKey: 'loi'),
    );
    harness.server.transactionsByAccount['acc-1'] = [_netflixDebit('2026-09-03'), _netflixDebit('2026-10-03')];

    await harness.synchronize();

    expect(harness.dependencies.get<DetectRecurringExpensesUseCase>()().single.months, 3);
  });

  test('an accepted imported subscription absorbs the debit of the next month', () async {
    harness.server.transactionsByAccount['acc-1'] = [_netflixDebit('2026-09-03'), _netflixDebit('2026-10-03')];
    await harness.synchronize();
    final recurrence = await harness.dependencies.get<AcceptSuggestionUseCase>()(
      harness.dependencies.get<DetectRecurringExpensesUseCase>()().single,
    );
    harness.dependencies.clock.current = DateTime(2026, 11, 15);
    harness.now = DateTime(2026, 11, 15, 9);
    await harness.dependencies.get<MaterializeDueRecurrencesUseCase>()();
    harness.server.transactionsByAccount['acc-1']!.add(_netflixDebit('2026-11-04'));

    final report = await harness.synchronize();

    expect(report.attachedToRecurrence, 1);
    expect(harness.expenses, hasLength(3));
    expect(harness.expenses.every((e) => e.recurrenceId == recurrence.id && e.isImported), isTrue);
    expect(detected(), isEmpty);
  });
}
