# Contrat — navigation et écrans

| Route `AppRoute` | Argument | Écran | Ouvert depuis |
|---|---|---|---|
| `bankSync` (`/bank`) | — | `BankSyncPage` : comptes reliés, statut, dernière synchro, bouton « Synchroniser maintenant », « Relier ma banque », « Délier » | ligne « Ma banque » du Profil |
| `bankPicker` (`/bank/pick`) | — | `BankPickerPage` : recherche dans la liste des banques (pays FR), puis lancement de l'autorisation | `BankSyncPage` |
| `bankCallback` (`/bank-callback`) | `Uri` | `BankCallbackPage` : lit `code` et `state`, finalise et redirige vers `bankSync` | lien profond, boucle locale ou web |

## Éléments visibles ailleurs

- **Expenses** : badge « importée » sur `ExpenseRow` et dans l'éditeur (FR-015), via le champ `origin` du domaine, sans import de BankSync.
- **Home et Account** : bandeau « Solde bancaire : 1 180,50 € — Utiliser ce solde » quand l'écart dépasse 1 € (FR-012). Le bandeau est fourni par BankSync et assemblé par `lib/app/home`.
- **Toast de fin de synchronisation** : « 12 dépenses ajoutées, 2 rapprochées » ou « Déjà à jour ».
