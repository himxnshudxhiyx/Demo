// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dio)
final dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'20253500eb63dc16e6236012878fb9f5baa16de1';

@ProviderFor(notesRepository)
final notesRepositoryProvider = NotesRepositoryProvider._();

final class NotesRepositoryProvider
    extends
        $FunctionalProvider<NotesRepository, NotesRepository, NotesRepository>
    with $Provider<NotesRepository> {
  NotesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotesRepository create(Ref ref) {
    return notesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotesRepository>(value),
    );
  }
}

String _$notesRepositoryHash() => r'cb923f250ee16ca24b6265e642fb454189ba5976';

/// The currently selected filter chip on the notes screen.

@ProviderFor(SelectedFilter)
final selectedFilterProvider = SelectedFilterProvider._();

/// The currently selected filter chip on the notes screen.
final class SelectedFilterProvider
    extends $NotifierProvider<SelectedFilter, NoteFilter> {
  /// The currently selected filter chip on the notes screen.
  SelectedFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedFilterHash();

  @$internal
  @override
  SelectedFilter create() => SelectedFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NoteFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NoteFilter>(value),
    );
  }
}

String _$selectedFilterHash() => r'5c21c35feb712db621bdbed6cc66ea694071745a';

/// The currently selected filter chip on the notes screen.

abstract class _$SelectedFilter extends $Notifier<NoteFilter> {
  NoteFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NoteFilter, NoteFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NoteFilter, NoteFilter>,
              NoteFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Loads the notes and exposes checklist toggling.

@ProviderFor(Notes)
final notesProvider = NotesProvider._();

/// Loads the notes and exposes checklist toggling.
final class NotesProvider extends $AsyncNotifierProvider<Notes, List<Note>> {
  /// Loads the notes and exposes checklist toggling.
  NotesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesHash();

  @$internal
  @override
  Notes create() => Notes();
}

String _$notesHash() => r'95b7847f4f3222b450becd3cdfa534443385618a';

/// Loads the notes and exposes checklist toggling.

abstract class _$Notes extends $AsyncNotifier<List<Note>> {
  FutureOr<List<Note>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Note>>, List<Note>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Note>>, List<Note>>,
              AsyncValue<List<Note>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Notes filtered by the active chip.

@ProviderFor(filteredNotes)
final filteredNotesProvider = FilteredNotesProvider._();

/// Notes filtered by the active chip.

final class FilteredNotesProvider
    extends $FunctionalProvider<List<Note>, List<Note>, List<Note>>
    with $Provider<List<Note>> {
  /// Notes filtered by the active chip.
  FilteredNotesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredNotesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredNotesHash();

  @$internal
  @override
  $ProviderElement<List<Note>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Note> create(Ref ref) {
    return filteredNotes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Note> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Note>>(value),
    );
  }
}

String _$filteredNotesHash() => r'dc56243132c2112aa5ceca28a25f908a151f0d8e';
