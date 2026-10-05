import 'package:depenses/layers/functional/BankSync/domain/entities/bank_link.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/sync_report.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense_draft.dart';
import 'package:depenses/layers/functional/Expenses/domain/use_cases/add_expense_use_case.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_errors.dart';
import 'package:flutter_test/flutter_test.dart';

import 'synchronize_fakes/bank_server_stub.dart';
import 'synchronize_fakes/bank_sync_harness.dart';

void main() {
  late BankSyncHarness harness;

  setUp(() {
    harness = BankSyncHarness();
    harness.server.transactionsByAccount['acc-1'] = readTransactionFixture('october_transactions.json');
    harness.server.availableBalanceByAccount['acc-1'] = 1180.5;
  });
  tearDown(() => harness.dispose());

  Map<String, dynamic> pendingBakery() => harness.server.transactionsByAccount['acc-1']!.last;

  test('imports the debits of the last 90 days on the first synchronisation', () async {
    final report = await harness.synchronize();

    expect(report, const SyncReport(created: 4, skipped: 1, bankBalance: 1180.5));
    expect(harness.server.requestedWindows, ['acc-1:2026-07-17', 'acc-1:2026-07-17', 'acc-1:2026-07-17']);
    expect(harness.expenses.map((e) => e.name), ['Carrefour', 'Free Mobile', 'Sncf', 'Boulangerie Du Coin']);
    expect(harness.expenses.map((e) => e.amount), [42.3, 19.99, 25.0, 4.5]);
    expect(harness.expenses.every((e) => e.isImported && e.roundUp == 0), isTrue);
    expect(harness.links.all().where((link) => link.wasPending), hasLength(1));
    final account = harness.accounts.byUid('acc-1');
    expect(account.lastSyncedAt, DateTime(2026, 10, 15, 9));
    expect(account.lastBankBalance, 1180.5);
  });

  test('ten successive synchronisations never duplicate an expense', () async {
    await harness.synchronize();
    final reports = <SyncReport>[];

    for (var run = 1; run < 10; run++) {
      harness.now = harness.now.add(const Duration(hours: 2));
      reports.add(await harness.synchronize());
    }

    expect(harness.expenses, hasLength(4));
    expect(harness.links.all(), hasLength(4));
    expect(reports.every((report) => report.isUpToDate), isTrue);
  });

  test('looks back ten days before the last synchronisation afterwards', () async {
    harness.accounts.accounts[0] = linkedAccount('acc-1', lastSyncedAt: DateTime(2026, 10, 14, 22));

    await harness.synchronize();

    expect(harness.server.requestedWindows.first, 'acc-1:2026-10-04');
  });

  test('removes an imported pending expense whose transaction disappeared', () async {
    await harness.synchronize();
    harness.server.transactionsByAccount['acc-1']!.removeLast();

    final report = await harness.synchronize();

    expect(report.removed, 1);
    expect(harness.expenses.map((e) => e.name), isNot(contains('Boulangerie Du Coin')));
    expect(harness.links.all(), hasLength(3));
  });

  test('updates a pending expense when the bank books it with another amount', () async {
    pendingBakery()['entry_reference'] = 'oct-bakery';
    await harness.synchronize();
    pendingBakery()
      ..['status'] = 'BOOK'
      ..['booking_date'] = '2026-10-15'
      ..['transaction_amount'] = {'amount': '4.80', 'currency': 'EUR'};

    final report = await harness.synchronize();

    expect(report, const SyncReport(updated: 1, skipped: 1, bankBalance: 1180.5));
    final bakery = harness.expenses.singleWhere((e) => e.bankTransactionId == 'oct-bakery');
    expect(bakery.amount, 4.8);
    expect(bakery.date, DateTime(2026, 10, 15));
    expect(harness.links.all().where((link) => link.wasPending), isEmpty);
  });

  test('replaces an anonymous pending expense once the bank books it under a reference', () async {
    await harness.synchronize();
    pendingBakery()
      ..['entry_reference'] = 'oct-bakery'
      ..['status'] = 'BOOK';

    final report = await harness.synchronize();

    expect(report.created, 1);
    expect(report.removed, 1);
    expect(harness.expenses, hasLength(4));
    expect(harness.expenses.last.bankTransactionId, 'oct-bakery');
  });

  test('links a manual expense of the same amount instead of importing it again', () async {
    final manual = await harness.dependencies.get<AddExpenseUseCase>()(
      ExpenseDraft(name: 'Forfait', amount: 19.99, date: DateTime(2026, 10, 4), categoryKey: 'log'),
    );

    final report = await harness.synchronize();

    expect(report.matched, 1);
    expect(report.created, 3);
    expect(harness.expenses, hasLength(4));
    expect(harness.expenses.first.id, manual.id);
    expect(harness.expenses.first.bankTransactionId, 'oct-free');
    expect(harness.links.all().singleWhere((l) => l.expenseId == manual.id).kind, BankLinkKind.matched);
  });

  test('marks an account whose access expired and keeps synchronising the others', () async {
    harness.accounts.accounts.add(linkedAccount('acc-2'));
    harness.server.transactionsByAccount['acc-2'] = readTransactionFixture('october_transactions.json').sublist(0, 1);
    harness.server.expiredAccounts.add('acc-1');

    final report = await harness.synchronize();

    expect(harness.accounts.byUid('acc-1').isRevoked, isTrue);
    expect(harness.accounts.byUid('acc-1').lastSyncedAt, isNull);
    expect(harness.accounts.byUid('acc-2').lastSyncedAt, harness.now);
    expect(report.created, 1);
    expect(harness.expenses, hasLength(1));
  });

  test('sums the reports of every account', () async {
    harness.accounts.accounts.add(linkedAccount('acc-2'));
    harness.server.transactionsByAccount['acc-2'] = [
      {...readTransactionFixture('october_transactions.json').first, 'entry_reference': 'acc2-carrefour'},
    ];

    final report = await harness.synchronize();

    expect(report.created, 5);
    expect(report.skipped, 1);
  });

  test('ignores revoked and expired accounts', () async {
    harness.accounts.accounts
      ..[0] = linkedAccount('acc-1', isRevoked: true)
      ..add(linkedAccount('acc-2', validUntil: DateTime(2026, 10, 1)));

    final report = await harness.synchronize();

    expect(report, const SyncReport());
    expect(harness.server.requestedWindows, isEmpty);
  });

  test('lets an unreachable bank fail the synchronisation without saving anything', () async {
    harness.server.isDown = true;

    await expectLater(harness.synchronize(), throwsA(isA<BankUnavailableException>()));

    expect(harness.expenses, isEmpty);
    expect(harness.accounts.byUid('acc-1').lastSyncedAt, isNull);
  });

  test('runs one synchronisation at a time', () async {
    final first = harness.synchronize();
    final second = harness.synchronize();

    expect(await second, await first);
    expect(harness.expenses, hasLength(4));
    expect(harness.server.requestedWindows, hasLength(3));
  });
}
