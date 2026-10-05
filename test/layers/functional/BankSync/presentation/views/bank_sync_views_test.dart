import 'package:depenses/layers/functional/BankSync/domain/entities/bank.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/sync_report.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/complete_bank_authorization_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/get_banks_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/get_linked_accounts_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/is_bank_sync_available_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/search_banks_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/start_bank_authorization_use_case.dart';
import 'package:depenses/layers/functional/BankSync/domain/use_cases/unlink_bank_account_use_case.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_callback_cubit.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_picker_cubit.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_sync_cubit.dart';
import 'package:depenses/layers/functional/BankSync/presentation/views/bank_sync_page.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_errors.dart';
import 'package:depenses/layers/technical/Theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../../../support/fixed_clock.dart';
import '../../../../../support/in_memory_document_store.dart';
import '../../support/bank_link_fakes.dart';
import 'bank_sync_test_app.dart';

void main() {
  late FakeBankDirectoryGateway directory;
  late FakeLinkedAccountGateway accounts;
  late FakeBankAuthorizationGateway authorization;
  late FakeAuthorizationStateGateway pendingState;
  late FakeSynchronizeBankAccounts synchronize;
  late InMemoryDocumentStore changes;
  final clock = FixedClock(DateTime(2026, 10, 5));

  setUpAll(prepareBankSyncLocalization);
  setUp(() {
    directory = FakeBankDirectoryGateway(
      knownBanks: const [Bank(name: 'Banque de Test', country: 'FR')],
    );
    accounts = FakeLinkedAccountGateway();
    authorization = FakeBankAuthorizationGateway();
    pendingState = FakeAuthorizationStateGateway();
    synchronize = FakeSynchronizeBankAccounts(report: const SyncReport(created: 3, matched: 1));
    changes = InMemoryDocumentStore();
    GetIt.I
      ..registerFactory(
        () => BankSyncCubit(
          IsBankSyncAvailableUseCase(directory),
          GetLinkedAccountsUseCase(accounts, clock),
          UnlinkBankAccountUseCase(authorization, accounts),
          synchronize,
          changes,
        ),
      )
      ..registerFactory(
        () => BankPickerCubit(
          GetBanksUseCase(directory),
          const SearchBanksUseCase(),
          StartBankAuthorizationUseCase(authorization, pendingState, FixedStateGenerator(), clock),
          FakeCallbackListener(),
        ),
      )
      ..registerFactory(
        () => BankCallbackCubit(CompleteBankAuthorizationUseCase(authorization, pendingState, accounts)),
      );
  });
  tearDown(() async {
    await GetIt.I.reset();
    await changes.dispose();
  });

  Future<void> open(WidgetTester tester, AppStyle style) async {
    await tester.pumpWidget(bankSyncTestApp(style, const BankSyncPage()));
    await tester.pumpAndSettle();
  }

  testWidgets('without configuration the page explains how to provide it', (tester) async {
    directory.isConfigured = false;
    await open(tester, AppStyle.menthe);

    expect(find.textContaining('Synchronisation bancaire non configurée', findRichText: true), findsOneWidget);
    expect(find.textContaining('--dart-define-from-file', findRichText: true), findsOneWidget);
    expect(find.text('Relier ma banque'), findsNothing);
  });

  for (final style in AppStyle.values) {
    testWidgets('linking a bank from the picker to the callback in ${style.name}', (tester) async {
      await open(tester, style);
      await tester.tap(find.text('Relier ma banque'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banque de Test'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Autorise l’accès', findRichText: true), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'pas une adresse');
      await tester.tap(find.text('Valider'));
      await tester.pump();
      expect(find.text('Cette adresse ne contient pas de code d’autorisation.'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'http://localhost:8765/bank-callback?code=c1&state=state-1');
      await tester.tap(find.text('Valider'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(authorization.completedCodes, ['c1']);
      expect(find.text('1 compte relié'), findsOneWidget);
      expect(find.text('Compte courant'), findsOneWidget);
      expect(find.text('Synchroniser maintenant'), findsOneWidget);
    });

    testWidgets('synchronizing shows the report in ${style.name}', (tester) async {
      accounts.accounts.add(linkedAccount(lastSyncedAt: DateTime(2026, 10, 4)));
      await open(tester, style);

      await tester.tap(find.text('Synchroniser maintenant'));
      await tester.pump();
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('3 dépenses ajoutées, 1 dépense rapprochée'), findsOneWidget);
      expect(find.text('Dernière synchro : 4 octobre 2026'), findsOneWidget);
    });
  }

  testWidgets('an up-to-date synchronization says so', (tester) async {
    accounts.accounts.add(linkedAccount());
    synchronize.report = const SyncReport();
    await open(tester, AppStyle.menthe);

    await tester.tap(find.text('Synchroniser maintenant'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Déjà à jour'), findsOneWidget);
    expect(find.text('Jamais synchronisé'), findsOneWidget);
  });

  testWidgets('an unreachable bank shows a retry message', (tester) async {
    accounts.accounts.add(linkedAccount());
    synchronize.error = const BankUnavailableException('offline');
    await open(tester, AppStyle.menthe);

    await tester.tap(find.text('Synchroniser maintenant'));
    await tester.pumpAndSettle();

    expect(find.textContaining('ne répond pas', findRichText: true), findsOneWidget);
  });

  testWidgets('an expired access offers to renew it from the picker', (tester) async {
    accounts.accounts.add(linkedAccount(isRevoked: true));
    await open(tester, AppStyle.menthe);
    expect(find.text('Accès à ta banque expiré'), findsOneWidget);

    await tester.tap(find.text('Renouveler l’accès'));
    await tester.pumpAndSettle();

    expect(find.text('Choisis ta banque'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Banque de Test'), findsOneWidget);
  });

  testWidgets('unlinking asks for confirmation then removes the account', (tester) async {
    accounts.accounts.add(linkedAccount());
    await open(tester, AppStyle.menthe);

    await tester.tap(find.text('Délier'));
    await tester.pumpAndSettle();
    expect(find.text('Délier ce compte ?'), findsOneWidget);
    await tester.tap(find.text('Délier').last);
    await tester.pumpAndSettle();

    expect(authorization.revoked, hasLength(1));
    expect(find.text('Relier ma banque'), findsOneWidget);
  });

  testWidgets('a cancelled authorization explains that nothing was linked', (tester) async {
    pendingState.value = 'state-1';
    await open(tester, AppStyle.menthe);
    Navigator.of(tester.element(find.byType(BankSyncPage)))
        .pushNamed('/bank-callback', arguments: Uri.parse('depenses://bank-callback?error=access_denied'));
    await tester.pumpAndSettle();

    expect(find.textContaining('La liaison a été annulée', findRichText: true), findsOneWidget);
    await tester.tap(find.text('Retour à Ma banque'));
    await tester.pumpAndSettle();
    expect(find.text('Relier ma banque'), findsOneWidget);
  });
}
