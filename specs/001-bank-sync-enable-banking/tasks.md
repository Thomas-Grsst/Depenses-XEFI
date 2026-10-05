---

description: "Task list for 001-bank-sync-enable-banking"
---

# Tasks: Synchronisation bancaire (Enable Banking)

**Input**: Design documents from `/specs/001-bank-sync-enable-banking/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Les tests sont obligatoires (constitution, principe IV). Dans chaque phase, les tâches de test précèdent l'implémentation et doivent échouer avant d'être rendues vertes.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1…US4)
- Chemins : layout OSDD single-package (`lib/layers/...`, `test/layers/...`, `lib/app/`)

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: dépendances, configuration et squelette des deux nouvelles couches

- [X] T001 Ajouter `http`, `dart_jsonwebtoken`, `url_launcher` et `app_links` dans `pubspec.yaml` (`flutter pub add …`), puis vérifier `flutter pub get`
- [X] T002 [P] Créer `config/enable_banking.example.json` (`ENABLE_BANKING_APP_ID: ""`, `ENABLE_BANKING_PRIVATE_KEY: ""`) et ajouter `config/enable_banking.json` à `.gitignore`
- [X] T003 [P] Créer les dossiers `lib/layers/technical/OpenBanking/{dto}` et `lib/layers/functional/BankSync/{domain/{entities,gateways,use_cases},data/{models,gateways},presentation/{cubit,views,widgets,l10n}}`, ainsi que les miroirs sous `test/layers/`
- [X] T004 [P] Déclarer l'`intent-filter` du schéma `depenses://bank-callback` dans `android/app/src/main/AndroidManifest.xml`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: client Enable Banking, stockage et champs additifs utilisés par tous les parcours

**⚠️ CRITICAL**: aucune phase US ne commence avant la fin de celle-ci

### Tests (foundational)

- [X] T005 [P] Test de signature JWT dans `test/layers/technical/OpenBanking/enable_banking_jwt_test.dart` : en-tête `kid` = app id, `alg` RS256, claims `iss = "enablebanking.com"`, `aud = "api.enablebanking.com"`, `exp = iat + 3600`, régénération 5 minutes avant expiration (horloge `FixedClock`)
- [X] T006 [P] Enregistrer les fixtures JSON (aspsps, auth, sessions, balances, transactions page 1 avec `continuation_key`, page 2 finale, erreur 401) dans `test/layers/technical/OpenBanking/fixtures/`
- [X] T007 [P] Tests du client dans `test/layers/technical/OpenBanking/enable_banking_client_test.dart` avec `MockClient` :
  - chemin, méthode et corps de chaque opération du contrat `contracts/enable-banking-client.md` ;
  - pagination `continuation_key` suivie jusqu'au bout ;
  - mapping des erreurs : 401/403 → `BankAccessExpiredException`, 429 → `BankRateLimitedException`, 5xx ou timeout de 20 s → `BankUnavailableException`, JSON invalide → `BankResponseFormatException`.
- [X] T008 [P] Test de compatibilité JSON dans `test/layers/functional/Expenses/data/expense_origin_compatibility_test.dart` : une dépense sans `origin` est lue comme `manual`, et une dépense `bank` fait l'aller-retour avec `bankTxId` inchangé

### Implementation (foundational)

- [X] T009 [P] `EnableBankingConfig` (lecture `String.fromEnvironment`, `isConfigured`) dans `lib/layers/technical/OpenBanking/enable_banking_config.dart`
- [X] T010 [P] Exceptions nommées (`BankAccessExpiredException`, `BankRateLimitedException`, `BankUnavailableException`, `BankResponseFormatException`, `BankSyncNotConfiguredException`) dans `lib/layers/technical/OpenBanking/enable_banking_errors.dart`
- [X] T011 [P] DTO écrits à la main (`AspspDto`, `AuthorizationStartDto`, `SessionDto`, `BalanceDto`, `TransactionDto`, `TransactionPageDto`), un fichier chacun, dans `lib/layers/technical/OpenBanking/dto/`
- [X] T012 `EnableBankingJwt` (RS256, cache, rafraîchi à `exp − 5 min`) dans `lib/layers/technical/OpenBanking/enable_banking_jwt.dart` (dépend de T009)
- [X] T013 `EnableBankingClient` (`listBanks`, `startAuthorization`, `createSession`, `balances`, `transactions`, `deleteSession`) dans `lib/layers/technical/OpenBanking/enable_banking_client.dart` (dépend de T010 à T012)
- [X] T014 `registerOpenBankingDependencies` dans `lib/layers/technical/OpenBanking/open_banking_dependencies.dart` (`http.Client`, config, JWT, client, `FlutterSecureStorage`)
- [X] T015 Ajouter `bankAccounts('bankAccounts')`, `bankLinks('bankLinks')` et `bankDismissed('bankDismissed')` à `lib/layers/technical/Storage/ledger_section.dart`
- [X] T016 Étendre `Expense` avec `origin: ExpenseOrigin` (`manual` | `bank`, absent = `manual`) et `bankTransactionId: String?` dans `lib/layers/functional/Expenses/domain/entities/expense.dart`, ajouter `expense_origin.dart`, puis mapper `origin` et `bankTxId` dans `lib/layers/functional/Expenses/data/models/expense_model.dart` (rend T008 vert)
- [X] T017 [P] Entités BankSync `Bank`, `LinkedBankAccount` (états `linked` / `expired`), `BankTransaction` (`id`, `date`, `amount` > 0, `direction` debit/credit, `isPending`, `rawLabel`), `BankLink` (`kind`: created/matched/recurrence, `wasPending`) et `SyncReport` dans `lib/layers/functional/BankSync/domain/entities/`
- [X] T018 [P] Contrats `BankDirectoryGateway`, `BankAuthorizationGateway`, `BankDataGateway`, `LinkedAccountGateway` et `BankLinkGateway` (cf. contrat) dans `lib/layers/functional/BankSync/domain/gateways/`
- [X] T019 Squelettes `bank_sync_dependencies.dart` et `presentation/l10n/bank_sync_locale.dart` (`BankSyncLocale.fr`), branchés dans `lib/app/app_dependencies.dart` et `lib/app/app_localization.dart`, et dans `test/support/test_dependencies.dart` avec un `MockClient`

**Checkpoint**: `flutter analyze` propre, T005 à T008 verts. Les parcours peuvent démarrer.

---

## Phase 3: User Story 1 - Relier son compte bancaire (Priority: P1) 🎯 MVP

**Goal**: relier, afficher et délier un compte bancaire (FR-001 à FR-003, FR-013, FR-017)

**Independent Test**: Profil → Ma banque → Relier → banque de test → retour : le compte et sa date d'expiration s'affichent. Délier : le compte disparaît et les dépenses restent.

### Tests for User Story 1

- [X] T020 [P] [US1] Tests de `StartBankAuthorizationUseCase` (state UUID mémorisé, `valid_until` = maintenant + validité maximale de la banque) et de `CompleteBankAuthorizationUseCase` (state différent → `BankAuthorizationRejectedException`, comptes enregistrés, session dans le stockage sécurisé) dans `test/layers/functional/BankSync/domain/use_cases/bank_authorization_use_cases_test.dart`
- [X] T021 [P] [US1] Test d'`UnlinkBankAccountUseCase` (session révoquée, compte retiré, dépenses intactes) dans `test/layers/functional/BankSync/domain/use_cases/unlink_bank_account_use_case_test.dart`
- [X] T022 [P] [US1] Tests de `BankSyncCubit` (comptes, statut expiré) et de `BankCallbackCubit` (succès, annulation, state invalide) avec bloc_test dans `test/layers/functional/BankSync/presentation/cubit/`

### Implementation for User Story 1

- [X] T023 [P] [US1] `LinkedBankAccountModel` et `LinkedAccountGatewayImpl` (section `bankAccounts`, session via `FlutterSecureStorage` sous la clé `bank_session_<uid>`) dans `lib/layers/functional/BankSync/data/`
- [X] T024 [P] [US1] `BankDirectoryGatewayImpl` et `BankAuthorizationGatewayImpl` sur `EnableBankingClient` dans `lib/layers/functional/BankSync/data/gateways/`
- [X] T025 [US1] Use cases `GetBanksUseCase`, `StartBankAuthorizationUseCase`, `CompleteBankAuthorizationUseCase`, `UnlinkBankAccountUseCase` et `GetLinkedAccountsUseCase` dans `lib/layers/functional/BankSync/domain/use_cases/` (rend T020 et T021 verts)
- [X] T026 [US1] `AuthorizationCallbackListener` : boucle locale `http://localhost:8765/bank-callback` sur Windows, `app_links` sur Android, route sur le web, plus le parseur « coller l'adresse de retour » ; dans `lib/layers/technical/OpenBanking/authorization_callback_listener.dart`
- [X] T027 [US1] Cubits `BankSyncCubit`, `BankPickerCubit` et `BankCallbackCubit` avec leurs states dans `lib/layers/functional/BankSync/presentation/cubit/` (rend T022 vert)
- [X] T028 [US1] Vues `BankSyncPage`, `BankPickerPage` et `BankCallbackPage`, plus les widgets `BankAccountTile`, `BankLinkPrompt` et `BankNotConfiguredNotice`, dans `lib/layers/functional/BankSync/presentation/` (textes dans `BankSyncLocale`, `App*` widgets)
- [X] T029 [US1] Routes `AppRoute.bankSync` (`/bank`), `bankPicker` (`/bank/pick`) et `bankCallback` (`/bank-callback`) dans `lib/layers/technical/Navigation/app_route.dart` et `lib/app/app_router.dart`
- [X] T030 [US1] Ligne « Ma banque » (`openRoute(AppRoute.bankSync)`) dans la vue Profil, sous `lib/layers/functional/Profile/presentation/`

**Checkpoint**: US1 démontrable seule (scénario 1 et 8 du quickstart).

---

## Phase 4: User Story 2 - Importer les opérations en dépenses (Priority: P1)

**Goal**: import sans doublon des débits en dépenses catégorisées (FR-004 à FR-007, FR-009 à FR-011, FR-014 à FR-016)

**Independent Test**: synchroniser donne N dépenses « importée » avec une catégorie. Resynchroniser 10 fois donne « Déjà à jour ». Une dépense supprimée ne revient pas.

### Tests for User Story 2

- [X] T031 [P] [US2] Tests du nettoyage des libellés (`CB CARREFOUR 03/10 PARIS 12` → `Carrefour`, `PRLV SEPA FREE MOBILE` → `Free Mobile`, casse de titre) dans `test/layers/functional/BankSync/domain/entities/bank_label_cleaner_test.dart`
- [X] T032 [P] [US2] Tests de `ReconcileBankTransactionUseCase` sur les cas R8 : déjà liée (mise à jour seulement si `wasPending`), écartée, dépense manuelle même montant ±3 jours → `matched`, nouvelle → `created` avec `roundUp == 0`, crédit ignoré ; dans `test/layers/functional/BankSync/domain/use_cases/reconcile_bank_transaction_use_case_test.dart`
- [X] T033 [P] [US2] Tests de `SynchronizeBankAccountsUseCase` : fenêtre de 90 jours au premier passage et `lastSync − 10 j` ensuite, 10 passages successifs → 0 doublon (SC-002), opération en attente disparue → dépense retirée, `SyncReport` exact ; dans `test/layers/functional/BankSync/domain/use_cases/synchronize_bank_accounts_use_case_test.dart`
- [X] T034 [P] [US2] Test de `DismissImportedExpenseUseCase` et de l'appel de `ExpenseDeletionListener` à la suppression, dans `test/layers/functional/BankSync/domain/use_cases/dismiss_imported_expense_use_case_test.dart`

### Implementation for User Story 2

- [X] T035 [P] [US2] `BankLabelCleaner` dans `lib/layers/functional/BankSync/domain/entities/bank_label_cleaner.dart` (rend T031 vert)
- [X] T036 [P] [US2] `BankTransactionMapper` (DTO → entité : identifiant = `entry_reference`, sinon `transaction_id`, sinon empreinte `date|montant|libellé normalisé` ; date = `booking_date`, sinon `value_date`, sinon `transaction_date`) et `BankDataGatewayImpl` dans `lib/layers/functional/BankSync/data/`
- [X] T037 [P] [US2] `BankLinkModel` et `BankLinkGatewayImpl` (sections `bankLinks` et `bankDismissed`) dans `lib/layers/functional/BankSync/data/`
- [X] T038 [US2] `ReconcileBankTransactionUseCase` (utilise `GuessCategoryUseCase` et `ExpenseGateway`) dans `lib/layers/functional/BankSync/domain/use_cases/` (rend T032 vert)
- [X] T039 [US2] `SynchronizeBankAccountsUseCase` et `ShouldSynchronizeUseCase` (dernière synchronisation de plus d'une heure) dans `lib/layers/functional/BankSync/domain/use_cases/` (rend T033 vert, `BankAccessExpiredException` → compte `expired`)
- [X] T040 [US2] Contrat `ExpenseDeletionListener` dans `lib/layers/functional/Expenses/domain/gateways/`, appelé par `DeleteExpenseUseCase` et `DeleteExpenseEntryUseCase` ; implémenté par `DismissImportedExpenseUseCase` (BankSync) et injecté dans `lib/app/app_dependencies.dart` (rend T034 vert)
- [X] T041 [US2] Bouton « Synchroniser maintenant » et toast `SyncReport` (« N dépenses ajoutées, M rapprochées » / « Déjà à jour ») dans `BankSyncCubit` et `BankSyncPage`
- [X] T042 [US2] Synchronisation à l'ouverture : `AppSessionCubit.resume()` appelle `SynchronizeBankAccountsUseCase` quand `ShouldSynchronizeUseCase` est vrai, et ignore les erreurs, dans `lib/app/session/app_session_cubit.dart`
- [X] T043 [P] [US2] Badge « importée » dans `ExpenseRow` et dans l'éditeur, basé sur `expense.origin`, dans `lib/layers/functional/Expenses/presentation/widgets/` (FR-015, clé `ExpensesLocale.imported`)

**Checkpoint**: US1 et US2 forment le MVP (scénarios 2 à 5 du quickstart).

---

## Phase 5: User Story 3 - Rattacher les opérations aux récurrences (Priority: P2)

**Goal**: une opération réelle remplace l'échéance générée de sa récurrence (FR-008)

**Independent Test**: récurrence « Loyer 800 € le 5 » et débit réel de 800 € le 5 donnent une seule dépense « Loyer » rattachée à la récurrence.

### Tests for User Story 3

- [X] T044 [P] [US3] Tests du cas `recurrence` de `ReconcileBankTransactionUseCase` : montant ±3 %, date ±5 jours, nom proche → l'échéance générée est remplacée et garde `recurrenceId` ; hors tolérance → `created` ; dans `test/layers/functional/BankSync/domain/use_cases/reconcile_recurrence_test.dart`
- [X] T045 [P] [US3] Test : une opération importée répétée chaque mois est proposée par `DetectRecurringExpensesUseCase`, dans `test/layers/functional/BankSync/domain/use_cases/imported_expense_detection_test.dart`

### Implementation for User Story 3

- [X] T046 [US3] Étape « récurrence » (avant le rapprochement manuel) dans `lib/layers/functional/BankSync/domain/use_cases/reconcile_bank_transaction_use_case.dart`, avec `RecurrenceGateway` et le critère « nom proche » (`normalizeForMatching`, premier mot commun ou inclusion) (rend T044 vert)
- [X] T047 [US3] Vérifier que `DetectRecurringExpensesUseCase` traite les dépenses `origin == bank` comme les autres et corriger si besoin, dans `lib/layers/functional/Recurrences/domain/use_cases/detect_recurring_expenses_use_case.dart` (rend T045 vert)

**Checkpoint**: scénario 6 du quickstart.

---

## Phase 6: User Story 4 - Recaler le solde sur la banque (Priority: P2)

**Goal**: proposer, sans imposer, d'aligner le solde de l'app sur le solde bancaire (FR-012)

**Independent Test**: solde banque de 1 180,50 € et solde app de 1 237 € : « Utiliser ce solde » met l'accueil à 1 180,50 €.

### Tests for User Story 4

- [X] T048 [P] [US4] Tests du choix de solde (`ITAV` > `CLAV` > `ITBD` > `CLBD`) dans `test/layers/functional/BankSync/data/bank_balance_selection_test.dart`
- [X] T049 [P] [US4] Tests d'`AlignBalanceOnBankUseCase` (appelle `SetBalanceUseCase` avec le solde bancaire ; écart ≤ 1 € → rien n'est proposé) dans `test/layers/functional/BankSync/domain/use_cases/align_balance_on_bank_use_case_test.dart`

### Implementation for User Story 4

- [X] T050 [US4] Lecture du solde dans `BankDataGatewayImpl.balance` et mémorisation dans `LinkedBankAccount.lastBankBalance` pendant la synchronisation (rend T048 vert)
- [X] T051 [US4] `GetBalanceGapUseCase` et `AlignBalanceOnBankUseCase` dans `lib/layers/functional/BankSync/domain/use_cases/` (rend T049 vert)
- [X] T052 [US4] Widget public `BankBalanceBanner` (« Solde bancaire : X — Utiliser ce solde ») avec son `BankBalanceCubit` dans `lib/layers/functional/BankSync/presentation/`, assemblé sous `AccountBalanceCard` dans `lib/app/home/home_view.dart`

**Checkpoint**: scénario 7 du quickstart. Les quatre parcours fonctionnent.

---

## Phase 7: Polish & Cross-Cutting Concerns

- [ ] T053 [P] Mettre à jour `README.md` (synchronisation bancaire, `--dart-define-from-file`) et la section Commands de `CLAUDE.md`
- [ ] T054 Exécuter tout `quickstart.md` sur Windows avec un vrai compte, puis remplacer les fixtures par des réponses réelles anonymisées si des champs diffèrent (R5)
- [ ] T055 Vérifier la couverture du diff (≥ 80 %) avec `flutter test --coverage`, en ne comptant que les lignes modifiées
- [ ] T056 `flutter analyze` et `dart format -l 120 lib test` propres, aucun commentaire, aucun fichier de plus de 200 lignes dans les couches `OpenBanking` et `BankSync`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)** : aucune dépendance.
- **Foundational (Phase 2)** : dépend du Setup et bloque tous les parcours.
- **US1 (Phase 3)** : dépend de la Phase 2.
- **US2 (Phase 4)** : dépend de la Phase 2. Elle a besoin d'un compte relié pour la démo réelle (US1), mais ses use cases se testent seuls avec des fakes.
- **US3 (Phase 5)** : dépend de US2 (elle étend `ReconcileBankTransactionUseCase`).
- **US4 (Phase 6)** : dépend de la Phase 2 et de la lecture du solde pendant la synchronisation (T039). Elle est indépendante de US3.
- **Polish (Phase 7)** : après les parcours retenus.

### User Story Dependencies

```text
Setup → Foundational ─┬─> US1 ──────────────┐
                      ├─> US2 ──> US3 ──────┼─> Polish
                      └─> US4 (après T039) ─┘
```

### Within Each User Story

Tests (rouges), puis data/modèles, puis use cases (verts), puis cubits, puis vues et intégration à `lib/app`.

### Parallel Opportunities

- Setup : T002, T003 et T004 en parallèle.
- Foundational : T005 à T008 (tests) en parallèle, puis T009, T010, T011, T017 et T018 en parallèle.
- US1 : T020 à T022 en parallèle, puis T023 et T024 en parallèle.
- US2 : T031 à T034 en parallèle, puis T035, T036, T037 et T043 en parallèle.
- US3 et US4 peuvent avancer en parallèle une fois US2 terminé.

## Parallel Example: User Story 2

```bash
Task: "T031 bank_label_cleaner_test.dart"
Task: "T032 reconcile_bank_transaction_use_case_test.dart"
Task: "T033 synchronize_bank_accounts_use_case_test.dart"
Task: "T034 dismiss_imported_expense_use_case_test.dart"

Task: "T035 BankLabelCleaner"
Task: "T036 BankTransactionMapper + BankDataGatewayImpl"
Task: "T037 BankLinkGatewayImpl"
```

## Implementation Strategy

### MVP First (US1 + US2)

1. Phases 1 et 2 : client, stockage, champs additifs.
2. Phase 3 (US1) : relier un vrai compte, puis valider le scénario 1.
3. Phase 4 (US2) : import sans doublon, puis valider les scénarios 2 à 5. **Stop & demo.**

### Incremental Delivery

4. US3 : fin du double comptage des charges fixes.
5. US4 : recalage du solde.
6. Polish : quickstart complet avec un vrai compte, puis fixtures réelles et couverture.

## Notes

- Avant T054, il faut créer l'application dans le Control Panel Enable Banking, déclarer les adresses de retour et relier son compte (cf. `quickstart.md`).
- Commit après chaque tâche ou groupe logique, sans attribution IA.
