import 'package:depenses/layers/functional/Account/domain/gateways/account_gateway.dart';
import 'package:depenses/layers/functional/Account/domain/use_cases/get_balance_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/gateways/linked_account_gateway.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/align_balance_on_bank_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/get_balance_gap_use_case.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';
import '../../support/bank_link_fakes.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      today: DateTime(2026, 10, 15),
      data: {
        'settings': {'balance': 1237, 'balanceDate': '2026-10-01'},
      },
    );
  });
  tearDown(() => dependencies.dispose());

  Future<void> bankSays(double balance) =>
      dependencies.get<LinkedAccountGateway>().save(linkedAccount(lastBankBalance: balance));

  test('aligning sets the app balance to the bank balance to the cent', () async {
    await bankSays(1180.50);

    await dependencies.get<AlignBalanceOnBankUseCase>()();

    expect(dependencies.get<GetBalanceUseCase>()(), 1180.50);
    expect(dependencies.get<AccountGateway>().get().balanceDate, DateTime(2026, 10, 15));
    expect(dependencies.get<GetBalanceGapUseCase>()()!.isWorthAligning, isFalse);
  });

  test('expenses of the day are already part of the bank balance', () async {
    await dependencies.get<ExpenseGateway>().addAll([
      Expense(id: 'e1', amount: 12.30, name: 'Boulangerie', categoryKey: 'courses', date: DateTime(2026, 10, 15)),
    ]);
    await bankSays(1180.50);

    await dependencies.get<AlignBalanceOnBankUseCase>()();

    expect(dependencies.get<GetBalanceUseCase>()(), 1180.50);
  });

  test('a gap of one euro or less leaves the app balance untouched', () async {
    await bankSays(1236.20);

    await dependencies.get<AlignBalanceOnBankUseCase>()();

    expect(dependencies.get<AccountGateway>().get().balanceDate, DateTime(2026, 10, 1));
  });

  test('without bank balance nothing changes', () async {
    await dependencies.get<LinkedAccountGateway>().save(linkedAccount());

    await dependencies.get<AlignBalanceOnBankUseCase>()();

    expect(dependencies.get<AccountGateway>().get().balance, 1237);
  });
}
