# Demo

A minimal notes app with a **"liquid glass"** UI — frosted, translucent cards
over soft pastel gradients. Built with Flutter, Riverpod (codegen), Dio, and
Google Fonts.

## Features

- **Your Notes** home — a two-column masonry grid of glass cards (checklist,
  thought, audio, files, photos, snapshots, PDF) with filter chips.
- **Thought of the day** detail — text/images/audios tabs and a reflection card.
- Tappable checklist items backed by Riverpod state.

## Tech stack

| Concern          | Choice                                                |
| ---------------- | ----------------------------------------------------- |
| Framework        | Flutter (Material 3), Dart SDK `^3.12.1`              |
| State management | `flutter_riverpod` + `riverpod_annotation` (codegen)  |
| Code generation  | `build_runner` + `riverpod_generator`                 |
| Networking       | `dio`                                                 |
| Typography       | `google_fonts` (Poppins UI · VT323 pixel labels)      |

## Getting started

```bash
flutter pub get                 # install dependencies
dart run build_runner build     # generate Riverpod *.g.dart files
flutter run                     # launch the app
```

While developing, you can watch for codegen changes instead:

```bash
dart run build_runner watch
```

> Re-run `build_runner` whenever you add or change a `@riverpod` annotation.

## Quality gates

```bash
flutter analyze     # must report "No issues found!"
flutter test        # widget tests (render at phone size; fail on overflow)
```

## Project layout

```
lib/
  main.dart                 ProviderScope + MaterialApp
  src/
    theme/                  colors, gradients, ThemeData, fonts
    models/                 Note, NoteKind, NoteFilter
    data/                   Dio-backed repository (seed data for now)
    providers/              @riverpod state (+ generated .g.dart)
    screens/                Your Notes home · Thought of the day detail
    widgets/                AppText, glass surfaces, cards, logo
```

## Contributing

See **[DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)** for architecture, conventions
(typography via `AppText`, theme tokens, glass widgets), and step-by-step
recipes for adding providers and note-card kinds.
