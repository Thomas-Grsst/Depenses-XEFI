# Data model — Synchronisation bancaire

Toutes les nouvelles données sont additives : un ledger `depenses_state_v1` existant se relit sans migration.

## Expense (existante, étendue)

| Champ | Type | JSON | Règle |
|---|---|---|---|
| `origin` | `ExpenseOrigin` (`manual`, `bank`) | `origin` (absent = `manual`) | `bank` si créée par import |
| `bankTransactionId` | `String?` | `bankTxId` | renseigné pour les dépenses importées ou rapprochées |

Une dépense importée a toujours `roundUp = 0` (FR-016).

## LinkedBankAccount (nouvelle, couche BankSync)

| Champ | Type | JSON (`bankAccounts[]`) | Règle |
|---|---|---|---|
| `uid` | `String` | `uid` | identifiant Enable Banking du compte |
| `bankName` | `String` | `bank` | |
| `country` | `String` | `country` | ISO 3166, `FR` par défaut |
| `label` | `String` | `label` | IBAN masqué ou nom du compte |
| `accessValidUntil` | `DateTime` | `validUntil` | date dépassée = statut `expired` |
| `lastSyncedAt` | `DateTime?` | `lastSync` | |
| `lastBankBalance` | `double?` | `balance` | dernier solde lu |

Le `session_id` va dans le stockage sécurisé, sous la clé `bank_session_<uid>`.

**États** : `linked`, puis `expired` (date dépassée ou erreur 401/403 de l'API), puis `linked` après réautorisation. L'état `unlinked` supprime l'entrée.

## BankTransaction (nouvelle, non persistée)

| Champ | Type | Source |
|---|---|---|
| `id` | `String` | `entry_reference`, sinon `transaction_id`, sinon empreinte |
| `date` | `DateTime` | `booking_date`, sinon `value_date`, sinon `transaction_date` |
| `amount` | `double` | valeur absolue de `transaction_amount.amount` |
| `direction` | `debit` / `credit` | `credit_debit_indicator` |
| `isPending` | `bool` | `status == PDNG` |
| `rawLabel` | `String` | `creditor.name`, sinon le premier élément de `remittance_information` |

## BankLink (nouvelle)

| Champ | Type | JSON (`bankLinks[]`) | Règle |
|---|---|---|---|
| `transactionId` | `String` | `tx` | unique |
| `expenseId` | `String` | `expense` | |
| `accountUid` | `String` | `account` | |
| `kind` | `created` / `matched` / `recurrence` | `kind` | |
| `wasPending` | `bool` | `pending` | autorise une mise à jour ultérieure |

## DismissedBankTransaction (nouvelle)

La section JSON `bankDismissed` est une liste de `transactionId`. Une entrée y est ajoutée quand l'utilisateur supprime une dépense qui a un `BankLink` de type `created`.

## SyncReport (nouvelle, non persistée)

`created`, `updated`, `matched`, `attachedToRecurrence`, `skipped` (des entiers), et `bankBalance` (`double?`), affichés en fin de synchronisation (FR-011).
