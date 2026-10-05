import 'package:depenses/layers/functional/Account/domain/gateways/account_gateway.dart';
import 'package:depenses/layers/functional/Appearance/domain/entities/visual_style.dart';
import 'package:depenses/layers/functional/Appearance/domain/gateways/appearance_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/functional/Profile/domain/gateways/profile_gateway.dart';
import 'package:depenses/layers/functional/Profile/domain/use_cases/export_expenses_csv_use_case.dart';
import 'package:depenses/layers/functional/Profile/domain/use_cases/reset_all_data_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;

  setUp(() {
    dependencies = TestDependencies(
      data: {
        'settings': {
          'name': 'Camille',
          'income': 2400,
          'payDay': 28,
          'balance': 1200,
          'balanceDate': '2026-10-01',
          'style': 'graphite',
          'alerts': false,
          'roundUpUsed': 4.5,
        },
        'expenses': [
          {
            'id': 'e',
            'name': 'Café "Le Zinc"',
            'amount': 2.5,
            'date': '2026-10-02',
            'cat': 'ali',
            'labels': ['Sortie', 'Amis'],
          },
        ],
      },
    );
  });
  tearDown(() => dependencies.dispose());

  test('export writes one quoted csv row per expense', () {
    final csv = dependencies.get<ExportExpensesCsvUseCase>()();

    expect(csv.split('\n')[1], '2026-10-02;"Café ""Le Zinc""";2,50;"Alimentation";"Sortie, Amis";non');
  });

  test('reset clears the data but keeps the profile, salary and appearance', () async {
    await dependencies.get<ResetAllDataUseCase>()();

    expect(dependencies.get<ExpenseGateway>().all(), isEmpty);
    expect(dependencies.get<ProfileGateway>().name(), 'Camille');
    final account = dependencies.get<AccountGateway>().get();
    expect(account.income, 2400);
    expect(account.payDay, 28);
    expect(account.hasBalance, isFalse);
    expect(dependencies.get<AppearanceGateway>().get().style, VisualStyle.graphite);
    expect(dependencies.store.readSettings()['alerts'], isTrue);
    expect(dependencies.store.readSettings()['roundUpUsed'], 0);
  });
}
