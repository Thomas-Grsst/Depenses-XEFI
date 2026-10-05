# Dépenses

This is a Flutter app (Android, Windows and web) for tracking personal expenses. All data stays on the device. Its rules are in `.specify/memory/constitution.md`; read it before changing code.

## Commands

```bash
flutter pub get
flutter analyze
dart format -l 120 lib test
flutter test
flutter run -d windows --dart-define-from-file=config/enable_banking.json
flutter build apk --release
```

Bank sync needs `config/enable_banking.json`, which is gitignored (see the README). Without it, the feature shows a "not configured" notice.

## Layout

- `lib/main.dart` and `lib/app/` form the composition root: dependency registration, theme, locales, routes, the tab shell and the home dashboard.
- `lib/layers/technical/<Layer>/` holds infrastructure: Calendar, Localization, Navigation, Storage, TextMatching and Theme.
- `lib/layers/functional/<Layer>/` holds one business domain per layer, split into `domain/`, `data/` and `presentation/`, with its wiring in `<layer>_dependencies.dart`.
- `test/` mirrors `lib/`. `test/support/TestDependencies` wires every layer on an in-memory store with a fixed clock.

## Spec-driven work

Spec Kit is installed. Use `/speckit-specify`, then `/speckit-plan`, `/speckit-tasks` and `/speckit-implement`. Specs go in `specs/`.

## Commits

Write short imperative messages, with no AI attribution trailer.
