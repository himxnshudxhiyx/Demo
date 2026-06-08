import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/notes_repository.dart';
import '../models/note.dart';

part 'notes_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  return Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
}

@riverpod
NotesRepository notesRepository(Ref ref) {
  return NotesRepository(ref.watch(dioProvider));
}

/// The currently selected filter chip on the notes screen.
@riverpod
class SelectedFilter extends _$SelectedFilter {
  @override
  NoteFilter build() => NoteFilter.all;

  void select(NoteFilter filter) => state = filter;
}

/// Loads the notes and exposes checklist toggling.
@riverpod
class Notes extends _$Notes {
  @override
  Future<List<Note>> build() {
    return ref.watch(notesRepositoryProvider).fetchNotes();
  }

  void toggleItem(String noteId, int itemIndex) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData([
      for (final note in current)
        if (note.id == noteId)
          note.copyWith(items: [
            for (var i = 0; i < note.items.length; i++)
              if (i == itemIndex)
                note.items[i].copyWith(done: !note.items[i].done)
              else
                note.items[i],
          ])
        else
          note,
    ]);
  }
}

/// Notes filtered by the active chip.
@riverpod
List<Note> filteredNotes(Ref ref) {
  final filter = ref.watch(selectedFilterProvider);
  final notes = ref.watch(notesProvider).value ?? const [];
  if (filter == NoteFilter.all) return notes;
  return notes.where((n) => n.filters.contains(filter)).toList();
}
