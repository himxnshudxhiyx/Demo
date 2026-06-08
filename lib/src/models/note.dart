import 'package:flutter/material.dart';

/// The visual category of a note, which drives how its card is rendered.
enum NoteKind { checklist, thought, audio, files, photos, snapshot, pdf }

enum NoteFilter { all, todo, images, important }

extension NoteFilterLabel on NoteFilter {
  String get label => switch (this) {
        NoteFilter.all => 'All Notes',
        NoteFilter.todo => 'To-Do',
        NoteFilter.images => 'Images',
        NoteFilter.important => 'Important',
      };
}

@immutable
class ChecklistItem {
  const ChecklistItem({required this.label, this.done = false});

  final String label;
  final bool done;

  ChecklistItem copyWith({bool? done}) =>
      ChecklistItem(label: label, done: done ?? this.done);

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
        label: json['label'] as String,
        done: json['done'] as bool? ?? false,
      );
}

@immutable
class Note {
  const Note({
    required this.id,
    required this.title,
    required this.kind,
    this.body,
    this.date,
    this.items = const [],
    this.imageUrls = const [],
    this.extraCount = 0,
    this.filters = const {NoteFilter.all},
  });

  final String id;
  final String title;
  final NoteKind kind;
  final String? body;
  final String? date;
  final List<ChecklistItem> items;
  final List<String> imageUrls;
  final int extraCount;
  final Set<NoteFilter> filters;

  Note copyWith({List<ChecklistItem>? items}) => Note(
        id: id,
        title: title,
        kind: kind,
        body: body,
        date: date,
        items: items ?? this.items,
        imageUrls: imageUrls,
        extraCount: extraCount,
        filters: filters,
      );

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        title: json['title'] as String,
        kind: NoteKind.values.byName(json['kind'] as String),
        body: json['body'] as String?,
        date: json['date'] as String?,
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        imageUrls: (json['imageUrls'] as List<dynamic>? ?? [])
            .map((e) => e as String)
            .toList(),
        extraCount: json['extraCount'] as int? ?? 0,
        filters: (json['filters'] as List<dynamic>? ?? ['all'])
            .map((e) => NoteFilter.values.byName(e as String))
            .toSet(),
      );
}
