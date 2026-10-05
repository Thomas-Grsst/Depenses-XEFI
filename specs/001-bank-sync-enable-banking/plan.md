# Implementation Plan: Synchronisation bancaire (Enable Banking)

**Branch**: `001-bank-sync-enable-banking` | **Date**: 2026-10-05 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-bank-sync-enable-banking/spec.md`

## Summary

L'utilisateur relie son compte bancaire via Enable Banking (mode restreint gratuit). L'app récupère ses opérations et les transforme en dépenses, sans doublon : rapprochement avec les saisies manuelles et les échéances de récurrences, mémoire des suppressions. Elle peut aussi recaler le solde sur celui de la banque.

Côté technique :
- une couche technique `OpenBanking` porte le client HTTP signé en RS256 ;
- une couche fonctionnelle `BankSync` porte la liaison, l'import et le rapprochement, sous forme de use cases purs et testés ;
- les autres couches ne reçoivent que des ajouts mineurs et additifs : l'origine d'une dépense, des routes et un bandeau de solde.

## Technical Context

**Language/Version**: Dart 3.13 / Flutter 3.47

**Primary Dependencies**:
- existantes : flutter_bloc, get_it, flutter_localization, intl, equatable, shared_preferences ;
- nouvelles : `http`, `dart_jsonwebtoken` (signature RS256), `url_launcher` (ouvrir la banque), `app_links` (lien profond Android).

**Storage**:
- ledger JSON `depenses_state_v1`, avec les nouvelles sections additives `bankAccounts`, `bankLinks`, `bankDismissed` et les champs additifs `origin` et `bankTxId` sur les dépenses ;
- stockage sécurisé pour les `session_id`.

**Testing**: flutter_test et bloc_test. `http/testing.dart` `MockClient` sert de fixtures JSON. Les fakes de `test/support/` sont étendus.

**Target Platform**: Android (lien profond), Windows (boucle locale), web (route de retour).

**Project Type**: application mobile et desktop Flutter, en couches OSDD.

**Performance Goals**: synchroniser 150 opérations en moins de 10 s (SC-004), avec une pagination `continuation_key` séquentielle et un rapprochement en O(n·m) borné (n ≤ 150, m = dépenses de la fenêtre).

**Constraints**:
- clé privée jamais commitée (dart-define-from-file) ;
- pas de serveur intermédiaire ;
- une erreur réseau ne bloque jamais l'app.

**Scale/Scope**: un utilisateur, 1 à 3 comptes, environ 150 opérations par synchronisation.

## Constitution Check

*GATE : évalué avant la phase 0 et réévalué après la phase 1.*

| Principe | Statut | Comment |
|---|---|---|
| I. Couches OSDD | ✅ | Nouvelle couche technique `OpenBanking` (client API, aucune règle métier) et nouvelle couche fonctionnelle `BankSync`. Pas de fourre-tout. |
| II. Clean architecture, pas d'import croisé de présentation | ✅ | BankSync consomme les contrats de domaine Expenses, Recurrences, Categories et Account. Ses écrans sont ouverts par `AppRoute`. Le bandeau de solde est assemblé dans `lib/app/home`. |
| III. View → Cubit → UseCase → Gateway | ✅ | `BankSyncCubit`, `BankPickerCubit`, `BankCallbackCubit` ; use cases `LinkBankAccount`, `CompleteBankAuthorization`, `SynchronizeBankAccounts`, `ReconcileBankTransaction`, `AlignBalanceOnBank`, `UnlinkBankAccount`. |
| IV. Comportement testé, ≥ 80 % du diff | ✅ | Tests unitaires du rapprochement (les 5 cas de R8), du nettoyage des libellés et de la pagination, tests de cubits, compatibilité JSON des nouveaux champs. |
| V. Lisibilité | ✅ | Zéro commentaire, fichiers < 200 lignes, DTO écrits à la main, exceptions nommées (cf. contrat). |
| Données sur l'appareil (v1.1.0) | ✅ | Seules les opérations transitent par Enable Banking et la banque, ce qui est autorisé par l'amendement 1.1.0. Les secrets ne sont pas commités. |
| i18n et thème | ✅ | `BankSyncLocale` ; widgets construits sur `App*` et `context.tokens`. |

**Re-check post-design** : ✅. Aucune violation, donc pas de « Complexity Tracking ».

## Project Structure

### Documentation (this feature)

```text
specs/001-bank-sync-enable-banking/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── enable-banking-client.md
│   └── ui-routes.md
├── checklists/requirements.md
└── tasks.md              # /speckit-tasks
```

### Source Code (repository root)

```text
config/
└── enable_banking.example.json            # modèle sans secret (config/enable_banking.json est ignoré)

lib/layers/technical/OpenBanking/
├── enable_banking_config.dart             # lecture des dart-define, isConfigured
├── enable_banking_jwt.dart                # signature RS256 + cache
├── enable_banking_client.dart             # une méthode par opération (cf. contrat)
├── enable_banking_errors.dart             # exceptions nommées
├── dto/ (aspsp_dto, session_dto, balance_dto, transaction_dto, transaction_page_dto)
├── authorization_callback_listener.dart   # boucle locale Windows / app_links Android
└── open_banking_dependencies.dart

lib/layers/functional/BankSync/
├── domain/
│   ├── entities/ (bank, linked_bank_account, bank_transaction, bank_link, sync_report, bank_label_cleaner)
│   ├── gateways/ (bank_directory_gateway, bank_authorization_gateway, bank_data_gateway,
│   │              linked_account_gateway, bank_link_gateway)
│   └── use_cases/ (get_banks, start_bank_authorization, complete_bank_authorization,
│                   synchronize_bank_accounts, reconcile_bank_transaction, should_synchronize,
│                   align_balance_on_bank, unlink_bank_account, dismiss_imported_expense)
├── data/
│   ├── models/ (linked_bank_account_model, bank_link_model, bank_transaction_mapper)
│   └── gateways/ (*_impl.dart sur EnableBankingClient, DocumentStore et le stockage sécurisé)
├── presentation/
│   ├── cubit/ (bank_sync_cubit, bank_picker_cubit, bank_callback_cubit + states)
│   ├── views/ (bank_sync_page, bank_picker_page, bank_callback_page)
│   ├── widgets/ (bank_account_tile, bank_sync_status, bank_balance_banner, …)
│   └── l10n/bank_sync_locale.dart
└── bank_sync_dependencies.dart

Modifications additives ailleurs :
lib/layers/technical/Storage/ledger_section.dart        # + bankAccounts, bankLinks, bankDismissed
lib/layers/technical/Navigation/app_route.dart          # + bankSync, bankPicker, bankCallback
lib/layers/functional/Expenses/domain/entities/expense.dart (+ origin, bankTransactionId) et expense_model.dart
lib/layers/functional/Expenses/presentation/widgets/expense_row.dart  # badge « importée »
lib/layers/functional/Expenses/domain/use_cases/delete_expense_use_case.dart  # → DismissImportedExpense via un contrat
lib/layers/functional/Profile/presentation/…            # ligne « Ma banque » → openRoute(AppRoute.bankSync)
lib/app/ (router, app_dependencies, app_localization, session resume → synchronisation, home → bandeau)
android/app/src/main/AndroidManifest.xml               # intent-filter depenses://bank-callback

test/layers/technical/OpenBanking/   (client + fixtures JSON, JWT)
test/layers/functional/BankSync/     (use cases, mappers, cubits)
```

**Structure Decision** : on reste dans un seul package Flutter (layout OSDD « single-package »), avec deux nouvelles couches. La suppression d'une dépense importée doit alimenter `bankDismissed` sans que Expenses dépende de BankSync. Expenses expose donc un contrat de domaine `ExpenseDeletionListener`, implémenté par BankSync et injecté par `get_it` dans `lib/app`. La dépendance reste dans le sens BankSync → Expenses.

## Risques

| Risque | Mitigation |
|---|---|
| Banque de l'utilisateur non couverte | vérifier la liste avant l'implémentation ; plan B : import CSV (hors périmètre) |
| Schéma `depenses://` refusé comme adresse de retour | plan B « coller l'adresse de retour » (R4) |
| Noms de champs de transaction différents | DTO isolé et fixture enregistrée au premier appel réel |
| Clé privée embarquée dans l'APK | acceptable pour un usage personnel et documenté ; ne pas distribuer l'APK |
