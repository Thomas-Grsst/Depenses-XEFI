# Dépenses

Application Flutter de suivi des dépenses personnelles (Android, Windows, web), structurée selon les conventions Xefi (architecture OSDD, Cubits, use cases, i18n) et développée avec [Spec Kit](https://github.com/github/spec-kit).

## Fonctionnalités

- **Accueil** : solde du compte, estimation de fin de mois, dépenses du mois, budget, arrondis, prévision, prochaines échéances, dernières dépenses.
- **Dépenses** : saisie occasionnelle ou récurrente, recherche et filtres, libellés, arrondi à l'euro supérieur mis de côté.
- **Récurrences** : calendrier des échéances et détection automatique des abonnements.
- **Budget** : enveloppes par catégorie et par libellé, alertes de rythme.
- **Prévision et comparaison** avec le mois précédent.
- **Simulations** (« et si mon loyer passait à 900 € ? ») sans toucher au budget.
- **Épargne** : objectifs alimentés par les arrondis.
- **Catégories personnalisées.**
- **Synchronisation bancaire (Enable Banking)** : les opérations de la banque deviennent des dépenses, sans doublon et rattachées aux récurrences. Le solde peut être recalé sur celui de la banque. Voir [docs/bank-sync.md](docs/bank-sync.md).
- **Deux styles** : Menthe (palettes Menthe, Océan, Prune, Terracotta) et Graphite, en clair ou en sombre.

Les données sont stockées localement, dans `shared_preferences`. Seule la synchronisation bancaire, si elle est configurée, échange des données avec Enable Banking et la banque.

## Prérequis

| Outil | Version / remarque |
|---|---|
| Flutter | 3.47 (Dart 3.13), `flutter doctor` sans erreur |
| Windows | **Mode développeur activé** (Paramètres → Système → Espace développeurs), obligatoire pour compiler les plugins |
| Visual Studio Build Tools | charge de travail « Développement desktop en C++ » (cible Windows) |
| Android SDK | pour la cible Android |
| uv + `specify-cli` | uniquement pour utiliser Spec Kit (`winget install astral-sh.uv` puis `uv tool install specify-cli`) |

## Démarrer

```bash
flutter pub get
flutter run -d windows
```

Autres cibles : `flutter run -d chrome` (web) ou `flutter run` avec un téléphone Android branché.

Pour activer la synchronisation bancaire, il faut un fichier `config/enable_banking.json`. Il n'est pas versionné. Voir [docs/bank-sync.md](docs/bank-sync.md). Ensuite :

```bash
flutter run -d windows --dart-define-from-file=config/enable_banking.json
```

Sans ce fichier, l'app fonctionne normalement et l'écran « Ma banque » affiche « Synchronisation bancaire non configurée ».

## Vérifier

```bash
flutter analyze
dart format -l 120 lib test
flutter test
```

Les trois commandes doivent passer sans erreur avant chaque commit.

## Compiler

```bash
flutter build windows --release --dart-define-from-file=config/enable_banking.json
flutter build apk --release --dart-define-from-file=config/enable_banking.json
```

Les fichiers produits :
- l'exécutable Windows : `build/windows/x64/runner/Release/depenses.exe` ;
- l'APK : `build/app/outputs/flutter-apk/app-release.apk`.

La clé Enable Banking est intégrée à ces fichiers : ne les distribue pas.

## Documentation

| Fichier | Contenu |
|---|---|
| [docs/architecture.md](docs/architecture.md) | Couches OSDD, flux View → Cubit → UseCase → Gateway, stockage, navigation, i18n, thème, tests, ajout d'une fonctionnalité |
| [docs/bank-sync.md](docs/bank-sync.md) | Configuration Enable Banking (Sandbox / Production), fonctionnement de la synchronisation, dépannage |
| [.specify/memory/constitution.md](.specify/memory/constitution.md) | Règles du projet (non négociables) |
| [specs/](specs/) | Specs Spec Kit (spec, plan, recherche, modèle de données, contrats, tâches) |
| [CLAUDE.md](CLAUDE.md) | Consignes pour les agents IA (Claude Code) |

## Développer une nouvelle fonctionnalité (Spec Kit)

Les commandes `/speckit-*` sont installées dans `.claude/skills/` et s'utilisent depuis Claude Code :

1. `/speckit-specify <description>` : rédige la spec dans `specs/NNN-nom/spec.md`.
2. `/speckit-clarify` (facultatif) : lève les ambiguïtés de la spec.
3. `/speckit-plan` : produit le plan technique, la recherche, le modèle de données, les contrats et le quickstart.
4. `/speckit-tasks` : découpe le travail en tâches (`tasks.md`).
5. `/speckit-implement` : implémente les tâches, tests compris.

Chaque plan est vérifié par rapport à la constitution.

## Dépôts

- Ce dépôt : `Thomas-Grsst/Depenses-XEFI` (version aux conventions Xefi, remote `origin`).
- Version d'origine : `Thomas-Grsst/Depenses-App` (remote `upstream`).
