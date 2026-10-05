# Dépenses Constitution

## Core Principles

### I. OSDD layers
The app is split into independent layers under `lib/layers/`. Functional layers (`Account`, `Appearance`, `Budget`, `Categories`, `Expenses`, `Forecast`, `Onboarding`, `Profile`, `Recurrences`, `Savings`, `Simulations`) each own one business domain. Technical layers (`Calendar`, `Localization`, `Navigation`, `Storage`, `TextMatching`, `Theme`) hold infrastructure shared by many layers and contain no business rules. A new domain means a new layer. No catch-all layer (`core`, `common`, `shared`, `utils`…) may exist.

### II. Clean architecture inside each functional layer
Every functional layer has `domain/` (entities, gateway contracts, use cases), `data/` (models, gateway implementations) and `presentation/` (cubits, views, widgets, l10n). Dependencies point inward: `domain` imports no Flutter widget, storage or `data` type. A layer never imports another layer's `presentation/` or `data/`. Layers collaborate through domain contracts, and screens of other layers are opened through `AppRoute` from the `Navigation` layer. The composition root (`lib/app/`, `lib/main.dart`) is the only place that wires layers together.

### III. View → Cubit → UseCase → Gateway
UI state lives in `flutter_bloc` cubits. Views stay stateless except for widget-owned controllers. Each business action is one use case with one `call()` method that receives gateway contracts through its constructor. Everything is registered in `get_it` from each layer's `<layer>_dependencies.dart`. Cubits never hold `BuildContext`, never navigate and never contain business rules.

### IV. Tested behaviour (NON-NEGOTIABLE)
New behaviour ships with tests in the same change. Use cases and entities get unit tests, cubits get `bloc_test` tests, and the stored JSON format gets compatibility tests. Tests use the hand-written fakes in `test/support/`, not a mocking library. At least 80% of the changed lines must be covered.

### V. Readable code without comments
No comments, TODOs or ticket references in the code: names carry the meaning. Code files stay under 200 lines, there is one public widget per file, and `build` methods read like an outline. Models are written by hand: no `freezed`, `json_serializable`, `build_runner` or `dartz`. Code throws named domain exceptions, never generic ones.

## Product constraints

- The ledger lives on the device. The only data leaving it is the bank synchronisation with Enable Banking (school project, personal use, restricted mode): bank operations transit through Enable Banking and the bank, and the app credentials are never committed. The whole ledger is one JSON document in `shared_preferences` under the key `depenses_state_v1`. Its format is a compatibility contract with installed versions: renaming or removing a key needs a migration.
- Every user-facing string goes through `flutter_localization` keys, declared in each layer's `presentation/l10n/<layer>_locale.dart`. Amounts and dates are formatted with `intl` through `context.money` and `context.dates`.
- Colours, text styles and spacing come from the `Theme` layer (`context.tokens`, `AppSpacing`). The two styles (Menthe and Graphite) and four palettes must work in both light and dark mode.
- Targets: Android (primary), Windows desktop and web.

## Development workflow

- Specs, plans and tasks are written with the `/speckit-*` commands in `specs/`.
- Before a change is done, these must be clean: `flutter analyze`, `dart format -l 120 lib test` and `flutter test`.
- Commits and pull requests carry no AI attribution.

## Governance

This constitution overrides other practices. Every plan produced by `/speckit-plan` must check its constitution gate against the principles above. Amending the constitution requires a version bump and an explanation of the change in the commit message.

**Version**: 1.1.0 | **Ratified**: 2026-10-05 | **Last Amended**: 2026-10-05
