# Quickstart — vérifier la synchronisation bancaire

## Prérequis

1. Dans le Control Panel Enable Banking (enablebanking.com) :
   - créer une application et télécharger sa clé privée ;
   - ajouter les adresses de retour `http://localhost:8765/bank-callback`, `http://localhost:8080/#/bank-callback` et `depenses://bank-callback` ;
   - relier son propre compte (« Link accounts ») pour le mode restreint.
2. Copier `config/enable_banking.example.json` vers `config/enable_banking.json`, puis renseigner `ENABLE_BANKING_APP_ID` et `ENABLE_BANKING_PRIVATE_KEY`. Ce fichier est ignoré par git.

## Lancer

```bash
flutter run -d windows --dart-define-from-file=config/enable_banking.json
```

## Scénarios de validation (cf. spec)

| # | Action | Résultat attendu |
|---|---|---|
| 1 | Profil → Ma banque → Relier ma banque → choisir sa banque → s'authentifier | retour dans l'app, compte affiché avec sa date d'expiration (US1, SC-001) |
| 2 | Synchroniser maintenant | toast « N dépenses ajoutées », dépenses marquées « importée » avec catégorie (US2, SC-003) |
| 3 | Synchroniser 10 fois de suite | toujours « Déjà à jour », nombre de dépenses inchangé (SC-002) |
| 4 | Saisir à la main une dépense déjà passée en banque, puis synchroniser | pas de doublon : la dépense manuelle est rapprochée (FR-006) |
| 5 | Supprimer une dépense importée, puis synchroniser | elle ne revient pas (FR-007) |
| 6 | Créer la récurrence « Loyer » du montant d'un prélèvement réel, puis synchroniser | une seule dépense « Loyer » ce mois-ci (US3) |
| 7 | Accepter « Utiliser le solde de la banque » | le solde de l'accueil est égal au solde bancaire (US4, SC-005) |
| 8 | Lancer sans `config/enable_banking.json` | « Synchronisation bancaire non configurée », rien ne plante |

## Tests automatisés

```bash
flutter test test/layers/technical/OpenBanking test/layers/functional/BankSync
```

Ils s'appuient sur un `http.Client` factice (`MockClient` de `package:http/testing.dart`) qui rejoue des réponses JSON enregistrées dans `test/layers/technical/OpenBanking/fixtures/`. Aucun appel réseau n'est fait.
