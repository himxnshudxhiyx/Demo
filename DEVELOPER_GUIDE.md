# Demo — Developer Guide

A minimal notes app showcasing a **"liquid glass"** UI (frosted, translucent
cards over soft pastel gradients). This guide explains how the project is laid
out, the conventions to follow, and how to extend it.

---

## 1. Tech stack

| Concern            | Choice                                            |
| ------------------ | ------------------------------------------------- |
| Framework          | Flutter (Material 3), Dart SDK `^3.12.1`          |
| State management   | `flutter_riverpod` + `riverpod_annotation` (codegen) |
| Code generation    | `build_runner` + `riverpod_generator`             |
| Networking         | `dio`                                             |
| Typography         | `google_fonts` (Poppins for UI, VT323 for pixel labels) |

> **Note on linting:** `riverpod_lint`/`custom_lint` are intentionally **not**
> in `dev_dependencies`. They pin an older `analyzer` that conflicts with the
> `riverpod_annotation 4.x` / `riverpod_generator 4.x` codegen stack. The
> generator itself works fine without them.

---

## 2. Getting started

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate Riverpod code (creates *.g.dart files)
dart run build_runner build

#    …or watch for changes while developing
dart run build_runner watch

# 3. Run the app
flutter run

# 4. Quality gates
flutter analyze      # must report "No issues found!"
flutter test         # widget tests
```

Whenever you add or change a `@riverpod` annotation, **re-run build_runner**.
If you hit "conflicting outputs", append `--delete-conflicting-outputs`.

---

## 3. Project structure

```
lib/
  main.dart                       ProviderScope + MaterialApp entry point
  src/
    theme/
      app_theme.dart              Colors, gradients, ThemeData, fonts
    models/
      note.dart                   Note, NoteKind, NoteFilter, ChecklistItem
    data/
      notes_repository.dart       Dio-backed repository (serves seed data)
    providers/
      notes_provider.dart         @riverpod providers (state)
      notes_provider.g.dart       GENERATED — do not edit
    screens/
      notes_screen.dart           "Your Notes" home (masonry grid)
      note_detail_screen.dart     "Thought of the day" detail
    widgets/
      app_text.dart               Single shared text widget (see §6)
      glass.dart                  GlassContainer, GlassCircleButton, FilterChipPill
      burst_logo.dart             CustomPainter starburst logo
      note_card.dart              Renders a Note based on its NoteKind
test/
  widget_test.dart                Smoke test + fake HTTP for network images
```

**Layering rule (dependencies point downward only):**

```
screens ──▶ widgets ──▶ theme
   │           │
   └──▶ providers ──▶ data ──▶ models
```

Widgets never read providers directly unless they are screen-level
`ConsumerWidget`s; leaf widgets receive data via constructor parameters.

---

## 4. State management (Riverpod + codegen)

All providers live in `lib/src/providers/notes_provider.dart` and use the
**code-generation** syntax (`@riverpod`). The generated `_$…` base classes and
the public `…Provider` objects come from `notes_provider.g.dart`.

| Provider                  | Type                          | Responsibility                                  |
| ------------------------- | ----------------------------- | ----------------------------------------------- |
| `dioProvider`             | `Dio`                         | Configured HTTP client (timeouts).              |
| `notesRepositoryProvider` | `NotesRepository`             | Wraps the Dio client.                           |
| `notesProvider`           | `AsyncNotifier<List<Note>>`   | Loads notes; exposes `toggleItem(...)`.         |
| `selectedFilterProvider`  | `Notifier<NoteFilter>`        | Active filter chip; exposes `select(...)`.      |
| `filteredNotesProvider`   | `List<Note>` (derived)        | `notes` filtered by `selectedFilter`.           |

### Patterns to follow

- **Reading async data:** use `ref.watch(notesProvider).value` (nullable in
  Riverpod 3.x) or `.when(loading:, error:, data:)` in the UI.
- **Mutating state:** add a method to the notifier class and reassign `state`
  immutably (see `Notes.toggleItem` — it rebuilds the list, never mutates in
  place). Models are `@immutable`; use `copyWith` to derive new instances.
- **Derived state:** prefer a small `@riverpod` function provider
  (like `filteredNotes`) over computing in widgets, so it's cached and testable.

### Adding a new provider

```dart
// in notes_provider.dart
@riverpod
class Tags extends _$Tags {
  @override
  List<String> build() => const [];

  void add(String tag) => state = [...state, tag];
}
```

Then run `dart run build_runner build`. Consume it with
`ref.watch(tagsProvider)`.

---

## 5. Data layer

`NotesRepository` is constructed with a `Dio` instance so it can talk to a real
backend. Until an endpoint exists it returns a local `_seed` list (with a small
simulated delay). To wire a real API:

```dart
Future<List<Note>> fetchNotes() async {
  final res = await _dio.get('/notes');
  return (res.data as List).map((e) => Note.fromJson(e)).toList();
}
```

`Note.fromJson` already exists, so only the fetch call changes. Configure base
URL / interceptors in `dioProvider`.

---

## 6. UI conventions

### Typography — always use `AppText`

Do **not** write raw `Text(..., style: TextStyle(...))`. Use the shared
`AppText` widget (`widgets/app_text.dart`). Its default is the most common
style (14pt · w500 · ink); override only what differs.

```dart
AppText('Body copy')                          // default body
AppText('Label', size: 13, color: Colors.white)
AppText.heading('Embrace the moment')         // 24 · w700 · accentBlue
AppText.title('Morning Reflection')           // 16 · w600 · ink
AppText.caption('1 Jun 2026')                 // 11 · inkSoft (dates)
AppText.display('Your Notes')                 // 40 · white + glow
AppText.pixel('Files', size: 30)              // VT323 dot-matrix font
```

- `AppText`, `.heading`, `.title`, `.caption` are **`const`** — usable in const
  widget trees.
- `.display` and `.pixel` are **not const** (they compute a glow shadow /
  resolve the Google font at runtime). Don't prefix them with `const`.

### Colors, gradients, theme

All design tokens live in `theme/app_theme.dart`:

- `AppColors` — `ink`, `inkSoft`, `accentBlue`, `accentYellow`, plus the named
  gradients (`skyGradient`, `auroraGradient`, `mintCard`, `sandCard`,
  `lilacCard`). Reference these instead of hardcoding hex values.
- `AppTheme.light` — the `ThemeData` applied in `main.dart`.
- `AppTheme.pixelFontFamily` — VT323 family name (used internally by
  `AppText.pixel`).

Each screen paints a gradient background and sets its `Scaffold` to
`backgroundColor: Colors.transparent`.

### Glass surfaces

Reuse the building blocks in `widgets/glass.dart` rather than re-creating blur:

- `GlassContainer` — frosted panel (`BackdropFilter` + translucent fill +
  white stroke). Tune via `borderRadius`, `blur`, `gradient`, `opacity`.
- `GlassCircleButton` — circular frosted icon button (back / more / mic).
- `FilterChipPill` — pill chip with a yellow selected state.

---

## 7. Notes & cards

A `Note` carries a `NoteKind` enum that decides how it renders. `NoteCard`
(`widgets/note_card.dart`) is a single dispatcher:

```dart
switch (note.kind) {
  NoteKind.checklist => _ChecklistCard(...),
  NoteKind.thought   => _ThoughtCard(...),
  NoteKind.audio     => _AudioCard(),
  NoteKind.files     => _FilesCard(),
  NoteKind.photos    => _PhotosCard(...),
  NoteKind.snapshot  => _SnapshotCard(...),
  NoteKind.pdf       => _PdfCard(),
}
```

### Adding a new card kind

1. Add a value to `NoteKind` in `models/note.dart`.
2. Add a private `_XxxCard` widget in `note_card.dart` and a `switch` arm.
3. Add a fixed height in `NotesScreen._heights` (the masonry grid uses fixed
   per-kind heights for its scrapbook rhythm).
4. Add a seed entry in `notes_repository.dart` to see it render.

> **Watch for overflow.** The home grid is a two-column masonry at phone width
> (~165px per column). Wrap flexible text in `Flexible` + `overflow:
> TextOverflow.ellipsis`, anchor bottom content with a `Spacer`, and verify
> against the widget test (which renders at iPhone size and **fails on any
> overflow**).

---

## 8. Navigation

Plain `Navigator.push` with `MaterialPageRoute`. Tapping the *Thought of the
day* card opens `NoteDetailScreen`; the detail screen's back button pops. There
is no router package — add `go_router` only if deep-linking/named routes become
necessary.

---

## 9. Testing

`test/widget_test.dart`:

- Sets a realistic iPhone surface (`tester.view.physicalSize`) so layout
  matches production and overflows are caught.
- Installs a fake `HttpOverrides` returning a 1×1 PNG, because `Image.network`
  throws in the test sandbox. **Reuse this pattern** for any test that pumps a
  screen containing network images.
- Pumps `~500ms` to let the mock repository resolve before asserting.

Run with `flutter test`. Keep `flutter analyze` at zero issues before pushing.

---

## 10. Conventions checklist

- [ ] Re-ran `build_runner` after touching any `@riverpod` annotation.
- [ ] Used `AppText` (never raw `Text` + `TextStyle`).
- [ ] Referenced `AppColors` / theme tokens, not raw hex.
- [ ] Reused `GlassContainer` / glass widgets for frosted surfaces.
- [ ] Models stay `@immutable`; state changes go through notifier methods.
- [ ] `flutter analyze` clean and `flutter test` green.
- [ ] No layout overflow at phone width.
```
