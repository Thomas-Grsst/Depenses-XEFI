# Architecture

L'app suit l'architecture **OSDD** de Xefi : le code est découpé en **couches** indépendantes, chacune responsable d'un seul sujet. Les règles complètes sont dans la [constitution](../.specify/memory/constitution.md).

```text
lib/
├── main.dart                  # bootstrap : dépendances, localisation, runApp
├── app/                       # racine de composition (seul endroit qui assemble les couches)
│   ├── app_dependencies.dart  # enregistre toutes les couches dans get_it
│   ├── app_localization.dart  # agrège les traductions de toutes les couches
│   ├── app_router.dart        # AppRoute → écrans (pages et feuilles du bas)
│   ├── depenses_app.dart      # cycle de vie, thème clair/sombre, AppearanceCubit
│   ├── session/               # AppSessionCubit : onboarding, échéances et synchro au retour dans l'app
│   ├── shell/                 # barre d'onglets (Accueil, Dépenses, Récurrences, Profil)
│   └── home/                  # tableau de bord : assemble des widgets publics de plusieurs couches
└── layers/
    ├── technical/<Couche>/    # infrastructure réutilisable, sans règle métier
    └── functional/<Couche>/   # un domaine métier par couche
```

## Couches techniques

| Couche | Rôle |
|---|---|
| `Storage` | `DocumentStore`, le ledger JSON dans `shared_preferences` ; `LedgerChanges`, le flux émis après chaque écriture ; `IdGenerator` ; `SecretStore` |
| `Calendar` | `Clock` (date du jour, injectable), extensions de dates (`dateOnly`, `daysInItsMonth`…) |
| `Localization` | `context.money` (montants via `intl`), `context.dates` (dates), `context.tr` / `context.trWith` (traductions), formulations d'échéances |
| `Navigation` | `AppRoute` (routes nommées), `openRoute` (vers une autre couche), `pushPage` (dans la même couche) |
| `Theme` | design system : `AppTokens` (une `ThemeExtension`, lue par `context.tokens`), `AppSpacing`, widgets `App*`, icônes, graphiques |
| `TextMatching` | `normalizeForMatching`, pour les comparaisons de texte sans accents ni casse |
| `OpenBanking` | client Enable Banking : JWT RS256, DTO, erreurs nommées, réception du retour d'autorisation |

## Couches fonctionnelles

| Couche | Domaine |
|---|---|
| `Expenses` | dépenses, libellés, arrondis, éditeur (dépense et récurrence), origine saisie ou importée |
| `Recurrences` | récurrences, échéances, matérialisation des échéances passées, détection d'abonnements |
| `Categories` | catégories par défaut et personnalisées, reconnaissance du marchand, catégorie devinée |
| `Budget` | enveloppes par catégorie et par libellé |
| `Forecast` | statistiques du mois, prévision, alertes de budget, comparaison de mois |
| `Account` | solde saisi, salaire, jour de paie, solde de fin de mois |
| `Savings` | objectifs d'épargne, arrondis versés |
| `Simulations` | scénarios « et si… » sur les récurrences |
| `Profile` | prénom, réglages, export CSV, réinitialisation |
| `Appearance` | style, palette, mode clair/sombre |
| `Onboarding` | premier lancement |
| `BankSync` | liaison bancaire, import, rapprochement, recalage du solde |

Chaque couche fonctionnelle a la même structure :

```text
<Couche>/
├── domain/
│   ├── entities/      # objets métier immuables (Equatable, copyWith), règles pures
│   ├── gateways/      # contrats abstraits d'accès aux données
│   └── use_cases/     # une action = une classe avec une seule méthode call()
├── data/
│   ├── models/        # conversion JSON ↔ entité, écrite à la main
│   └── gateways/      # implémentations des contrats (*Impl)
├── presentation/
│   ├── cubit/         # <Nom>Cubit + <Nom>State
│   ├── views/         # pages (<Nom>Page fournit le cubit, <Nom>View affiche)
│   ├── widgets/       # morceaux d'écran, un widget public par fichier
│   └── l10n/          # <Couche>Locale : clés de traduction et textes FR
└── <couche>_dependencies.dart   # enregistrement get_it
```

## Règles de dépendance

- `domain` n'importe ni Flutter, ni `data`, ni `presentation`.
- Une couche peut importer le **domaine** d'une autre couche (ses entités, contrats et use cases). Elle ne doit **jamais** importer son `presentation/` ou son `data/`.
- Pour ouvrir l'écran d'une autre couche, on passe par `openRoute(context, AppRoute.x, arguments: …)`. C'est `lib/app/app_router.dart` qui associe chaque route à son écran.
- Seul `lib/app/` peut importer la présentation de plusieurs couches. Le tableau de bord d'accueil et le shell y vivent pour cette raison.
- Pour qu'une couche réagisse à un événement d'une autre sans en dépendre, on définit un contrat dans la couche émettrice et on le fait implémenter par la couche réceptrice. Exemple : `ExpenseDeletionListener` est défini dans Expenses, implémenté par BankSync et branché dans `app_dependencies.dart`.
- **Exception connue :** les domaines `Expenses` et `Recurrences` dépendent l'un de l'autre, parce que l'éditeur unique gère à la fois les dépenses et les récurrences.

## Flux d'une action

```text
View ──(intention)──▶ Cubit ──▶ UseCase ──▶ Gateway (contrat) ──▶ GatewayImpl ──▶ DocumentStore
  ▲                    │                                                              │
  └──── BlocBuilder ◀──┘◀──────────── LedgerChanges (après chaque écriture) ◀─────────┘
```

- Les cubits reçoivent leurs use cases et `LedgerChanges` par le constructeur. Ils se rechargent à chaque changement et sont enregistrés avec `registerFactory`.
- Les effets de bord (navigation, toasts, feuilles du bas) se font dans la vue, avec `BlocListener`, jamais dans le cubit.
- Les erreurs sont des exceptions nommées (`BankAccessExpiredException`…), que le cubit transforme en état d'échec.

## Stockage (le ledger)

Tout le ledger est un seul document JSON, stocké dans `shared_preferences` sous la clé `depenses_state_v1`. Son format est un **contrat de compatibilité** avec les versions déjà installées : on peut ajouter des champs, mais pas en renommer ni en supprimer sans migration.

| Section (`LedgerSection`) | Clé JSON | Contenu |
|---|---|---|
| settings | `settings` | prénom, salaire, jour de paie, solde saisi, apparence, interrupteurs, arrondis utilisés, abonnements ignorés |
| expenses | `expenses` | dépenses (`origin` et `bankTxId` présents seulement pour les dépenses importées) |
| recurrences | `recs` | récurrences (`lastGen` = date jusqu'à laquelle les échéances sont générées) |
| envelopes / labelEnvelopes | `envelopes` / `labelEnvs` | budgets par catégorie et par libellé |
| goals / scenarios | `goals` / `sims` | objectifs d'épargne et simulations |
| labels / categories | `labels` / `cats` | libellés connus et catégories personnalisées |
| bankAccounts / bankLinks / bankDismissed / bankSettings | idem | comptes reliés, liens opération ↔ dépense, opérations écartées, autorisation en cours |

Le `session_id` Enable Banking est stocké à part, dans le `SecretStore` (`shared_preferences`, clés préfixées `depenses_secret_`).

## Navigation

`AppRoute` (dans `lib/layers/technical/Navigation/app_route.dart`) est la liste des écrans qu'on peut ouvrir depuis une autre couche : édition de dépense ou de récurrence, budget, prévision, comparaison, compte, arrondis, simulations, catégories, enveloppe, Ma banque, choix de la banque, retour d'autorisation. Les onglets (Accueil, Dépenses, Récurrences, Profil) sont gérés par `ShellTabCubit` dans `lib/app/shell/`.

## Textes et formats

- Aucun texte affiché n'est écrit en dur dans un widget. Chaque couche déclare ses clés dans `presentation/l10n/<couche>_locale.dart` (le mixin `<Couche>Locale`, avec des clés préfixées et une map `fr`). `lib/app/app_localization.dart` les agrège toutes.
- Pour afficher un texte : `context.tr(BudgetLocale.title)`, ou `context.trWith(clé, [valeurs])` pour une phrase avec des `%a`.
- Les montants passent par `context.money.euros(…)` et les dates par `context.dates.longDate(…)`, tous deux basés sur `intl` en `fr_FR`.

## Thème

- Couleurs, styles de texte et espacements viennent de `context.tokens` et `AppSpacing`. Aucune couleur n'est écrite en dur dans un widget, sauf quelques constantes nommées documentées dans leur fichier.
- La couleur d'une catégorie est `tokens.swatch(category.colorIndex)`.
- Le style est choisi par `AppearanceCubit` (couche Appearance) et appliqué par `lib/app/depenses_material_app.dart`.

## Tests

- `test/` reproduit l'arborescence de `lib/`.
- `test/support/TestDependencies` branche toutes les couches sur un `InMemoryDocumentStore`, avec une horloge fixe, des ids séquentiels, un `MockClient` HTTP et un `InMemorySecretStore`.
- Les fakes sont écrits à la main : pas de bibliothèque de mocks. Les cubits sont testés avec `bloc_test`.
- Les réponses Enable Banking de test sont dans `test/layers/technical/OpenBanking/fixtures/` (avec une clé RSA de test jetable) et `test/layers/functional/BankSync/fixtures/`.

## Conventions de code

- Zéro commentaire : les noms portent le sens.
- Fichiers de moins de 200 lignes, un widget public par fichier, `build` court.
- Modèles écrits à la main : pas de `freezed`, `json_serializable` ni `build_runner`.
- Pas de dossiers fourre-tout (`utils`, `helpers`, `common`, `core`…).
- Formatage `dart format -l 120`, lints dans `analysis_options.yaml`.

## Ajouter une fonctionnalité

1. Passer par Spec Kit (`/speckit-specify` → `/speckit-plan` → `/speckit-tasks` → `/speckit-implement`).
2. Placer le code dans la couche du domaine concerné, ou créer une nouvelle couche si c'est un nouveau domaine.
3. Écrire les entités, les contrats et les use cases dans `domain/`, avec leurs tests.
4. Écrire les modèles JSON et les implémentations dans `data/`. Si la fonctionnalité stocke des données, ajouter une `LedgerSection`.
5. Écrire le cubit, la vue, les widgets et les clés de traduction dans `presentation/`.
6. Enregistrer le tout dans `<couche>_dependencies.dart`, puis dans `lib/app/app_dependencies.dart` (et dans `test/support/test_dependencies.dart`) si c'est une nouvelle couche.
7. Si l'écran s'ouvre depuis une autre couche, ajouter une `AppRoute` et sa correspondance dans `app_router.dart`.
8. Vérifier `flutter analyze`, `dart format -l 120 lib test` et `flutter test`.
