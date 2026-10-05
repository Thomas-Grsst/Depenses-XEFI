# Dépenses

This is a Flutter app (Android, Windows and web) for tracking personal expenses, structured with Xefi conventions.
- **Data:** stored locally in `shared_preferences`. The only external exchange is the optional bank sync with Enable Banking.
- **Rules:** the binding rules are in `.specify/memory/constitution.md`. Read it before changing code.
- **Docs:** `docs/architecture.md` and `docs/bank-sync.md`.

## Commands

```bash
flutter pub get
flutter analyze
dart format -l 120 lib test
flutter test
flutter run -d windows --dart-define-from-file=config/enable_banking.json
flutter build apk --release --dart-define-from-file=config/enable_banking.json
```

`flutter analyze`, the format check and `flutter test` must all be clean before any commit.

## Layout

- `lib/main.dart` and `lib/app/` form the composition root. It is the only place that imports several layers' presentation. It holds:
  - DI (`app_dependencies.dart`), aggregated locales (`app_localization.dart`) and the `AppRoute` → view mapping (`app_router.dart`);
  - the tab shell, the home dashboard, and `AppSessionCubit`, which handles onboarding, recurrence materialization and bank sync on resume.
- `lib/layers/technical/<Layer>/` holds infrastructure with no business rules:
  - Calendar, Localization, Navigation, Storage, TextMatching, Theme;
  - OpenBanking, the Enable Banking client.
- `lib/layers/functional/<Layer>/` holds one domain per layer: Account, Appearance, BankSync, Budget, Categories, Expenses, Forecast, Onboarding, Profile, Recurrences, Savings, Simulations.
  - Each is split into `domain/` (entities, gateway contracts, use cases), `data/` (hand-written JSON models, `*Impl` gateways) and `presentation/` (cubit, views, widgets, l10n).
  - Wiring lives in `<layer>_dependencies.dart`.
- `test/` mirrors `lib/`. `test/support/TestDependencies` wires every layer on an in-memory store, with a fixed clock, sequential ids, an HTTP `MockClient` and an in-memory secret store.
- `specs/NNN-feature/` holds the Spec Kit artifacts. `config/enable_banking.json` holds the bank credentials and is gitignored.

## Rules that bite

- **Dependency flow:** View → Cubit → UseCase → Gateway contract.
  - Cubits get use cases and `LedgerChanges` through the constructor and are registered with `registerFactory`.
  - No `BuildContext`, navigation or business rule in a cubit.
- **Layer boundaries:** never import another functional layer's `presentation/` or `data/`.
  - Open other layers' screens with `openRoute(context, AppRoute.x)`.
  - React to another layer's events through a contract the emitter defines. Example: `ExpenseDeletionListener`, implemented by BankSync and bound in `lib/app`.
- **Text and formats:** no hardcoded user-facing string. Add keys to the layer's `<Layer>Locale` (`fr` map) and use `context.tr` / `context.trWith`. Format money and dates only with `context.money` / `context.dates`.
- **Theme:** no colour literals in widgets. Use `context.tokens`, `AppSpacing` and the `App*` widgets from the Theme layer.
- **Code style:**
  - zero comments, files under 200 lines, one public widget per file;
  - named exceptions only;
  - no `freezed` / `json_serializable` / `build_runner`;
  - no bag folders (`utils`, `helpers`, `common`, `core`).
- **Stored format:** the ledger JSON (`depenses_state_v1`, sections in `LedgerSection`) is a compatibility contract. Only additive changes are allowed. New optional fields must be omitted when they hold their default value.
- **Tests:** new behaviour ships with tests, hand-written fakes and no mocking library. At least 80% of the changed lines must be covered.

## Known pitfalls

- **Windows:** building needs Developer Mode, because plugins require symlinks. `flutter_secure_storage` is avoided because its Windows plugin needs Visual Studio ATL. Secrets go through `SecretStore` / `PreferencesSecretStore`.
- **Config file:** `config/enable_banking.json` must be UTF-8 without BOM, with the PEM key on one line using `\n` escapes. Otherwise the Dart compiler crashes.
- **Domain cycle:** the `Expenses` and `Recurrences` domains depend on each other, because one editor handles both. This is a known exception.
- **Bank sync limits:**
  - The automatic browser return of the bank authorization is not reliable yet on Windows. The paste-the-return-URL fallback exists.
  - Android cold-start deep links are not handled at the app root yet.

## Spec-driven work

Spec Kit is installed (`.claude/skills/speckit-*`). Use `/speckit-specify`, then `/speckit-plan`, `/speckit-tasks` and `/speckit-implement`. Specs go in `specs/`. Every plan must pass the constitution check.

## Commits

Write short imperative messages, with no AI attribution trailer.
