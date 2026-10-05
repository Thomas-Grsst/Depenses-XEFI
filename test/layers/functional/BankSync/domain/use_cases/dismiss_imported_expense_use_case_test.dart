import 'package:depenses/layers/functional/BankSync/domain/use_cases/dismiss_imported_expense_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_draft.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_deletion_listener.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/add_expense_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/delete_expense_entry_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/delete_expense_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import 'synchronize_fakes/bank_server_stub.dart';
import 'synchronize_fakes/bank_sync_harness.dart';

void main() {
  late BankSyncHarness harness;

  setUp(() {
    harness = BankSyncHarness();
    harness.dependencies.getIt.registerLazySingleton<ExpenseDeletionListener>(
      () => harness.dependencies.get<DismissImportedExpenseUseCase>(),
    );
    harness.server.transactionsByAccount['acc-1'] = readTransactionFixture('october_transactions.json');
  });
  tearDown(() => harness.dispose());

  test('an imported expense deleted by the user is never imported again', () async {
    await harness.synchronize();
    final carrefour = harness.expenses.firstWhere((e) => e.name == 'Carrefour');

    await harness.dependencies.get<DeleteExpenseUseCase>()(carrefour.id);
    final report = await harness.synchronize();

    expect(harness.links.dismissed(), {'oct-carrefour'});
    expect(harness.links.all().map((link) => link.transactionId), isNot(contains('oct-carrefour')));
    expect(report.isUpToDate, isTrue);
    expect(harness.expenses.map((e) => e.name), isNot(contains('Carrefour')));
  });

  test('deleting from the expense editor dismisses the imported transaction too', () async {
    await harness.synchronize();
    final free = harness.expenses.firstWhere((e) => e.name == 'Free Mobile');

    await harness.dependencies.get<DeleteExpenseEntryUseCase>()(expense: free);

    expect(harness.links.dismissed(), {'oct-free'});
  });

  test('a deleted manual expense linked to a transaction is not dismissed nor re-imported', () async {
    final manual = await harness.dependencies.get<AddExpenseUseCase>()(
      ExpenseDraft(name: 'Forfait', amount: 19.99, date: DateTime(2026, 10, 4), categoryKey: 'log'),
    );
    await harness.synchronize();

    await harness.dependencies.get<DeleteExpenseUseCase>()(manual.id);
    final report = await harness.synchronize();

    expect(harness.links.dismissed(), isEmpty);
    expect(report.isUpToDate, isTrue);
    expect(harness.expenses, hasLength(3));
  });

  test('deleting an expense unknown to the bank changes nothing on the bank side', () async {
    final manual = await harness.dependencies.get<AddExpenseUseCase>()(
      ExpenseDraft(name: 'Pain', amount: 1.2, date: DateTime(2026, 10, 14), categoryKey: 'ali'),
    );

    await harness.dependencies.get<DismissImportedExpenseUseCase>()(manual);

    expect(harness.links.dismissed(), isEmpty);
    expect(harness.links.all(), isEmpty);
  });
}
