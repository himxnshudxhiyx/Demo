import 'package:dio/dio.dart';

import '../models/note.dart';

/// Repository for fetching notes.
///
/// It is wired with [Dio] so it can talk to a real backend, but until one
/// exists it serves a local seed so the UI is fully populated. Swap
/// [_seed] for `_dio.get(...)` once an endpoint is available.
class NotesRepository {
  NotesRepository(this._dio);

  // ignore: unused_field
  final Dio _dio;

  Future<List<Note>> fetchNotes() async {
    // Simulate network latency for a realistic loading state.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _seed.map(Note.fromJson).toList();
  }

  static const List<Map<String, dynamic>> _seed = [
    {
      'id': 'shopping',
      'title': 'Shopping\nList',
      'kind': 'checklist',
      'filters': ['all', 'todo', 'important'],
      'items': [
        {'label': 'Vegetables', 'done': true},
        {'label': 'Fruits', 'done': false},
        {'label': 'Grocery', 'done': false},
      ],
    },
    {
      'id': 'thought',
      'title': 'Thought\nof the\nday',
      'kind': 'thought',
      'date': '1 Jun 2026',
      'filters': ['all', 'important'],
      'body':
          'Embrace the moment and let your spirit soar. Every day is a fresh '
              'start—embrace it with hope and courage. Let each moment inspire '
              'you to grow and shine brighter than before.',
    },
    {
      'id': 'audio',
      'title': 'Voice memo',
      'kind': 'audio',
      'filters': ['all'],
    },
    {
      'id': 'files',
      'title': 'Files',
      'kind': 'files',
      'filters': ['all', 'important'],
    },
    {
      'id': 'highlights',
      'title': 'Highlights',
      'kind': 'photos',
      'date': '25 May 2026',
      'filters': ['all', 'images'],
      'extraCount': 5,
      'imageUrls': [
        'https://images.unsplash.com/photo-1492288991661-058aa541ff43?w=400'
      ],
    },
    {
      'id': 'snapshots',
      'title': 'Snapshots',
      'kind': 'snapshot',
      'date': '25 May 2026',
      'filters': ['all', 'images'],
      'extraCount': 5,
      'imageUrls': [
        'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?w=400'
      ],
    },
    {
      'id': 'pdf',
      'title': 'Pdf',
      'kind': 'pdf',
      'filters': ['all'],
    },
  ];
}
