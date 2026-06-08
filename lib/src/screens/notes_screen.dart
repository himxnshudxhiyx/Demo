import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_text.dart';
import '../widgets/burst_logo.dart';
import '../widgets/glass.dart';
import '../widgets/note_card.dart';
import 'note_detail_screen.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  // Fixed heights give the masonry grid its varied, scrapbook rhythm.
  static const Map<NoteKind, double> _heights = {
    NoteKind.checklist: 256,
    NoteKind.thought: 200,
    NoteKind.audio: 92,
    NoteKind.files: 150,
    NoteKind.photos: 170,
    NoteKind.snapshot: 150,
    NoteKind.pdf: 130,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.skyGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: notesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Could not load notes\n$e')),
            data: (_) => const _NotesBody(),
          ),
        ),
      ),
    );
  }
}

class _NotesBody extends ConsumerWidget {
  const _NotesBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(selectedFilterProvider);
    final notes = ref.watch(filteredNotesProvider);

    // Split notes across two columns for a masonry look.
    final left = <Note>[];
    final right = <Note>[];
    for (var i = 0; i < notes.length; i++) {
      (i.isEven ? left : right).add(notes[i]);
    }

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          children: [
            const _Header(),
            const SizedBox(height: 20),
            _FilterRow(selected: filter),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _Column(notes: left)),
                const SizedBox(width: 14),
                Expanded(child: _Column(notes: right)),
              ],
            ),
          ],
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 28,
          child: Center(child: _BottomDock()),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BurstLogo(size: 52),
              const SizedBox(height: 8),
              AppText.display('Your Notes'),
            ],
          ),
        ),
        const GlassCircleButton(icon: Icons.apps_rounded, size: 50),
      ],
    );
  }
}

class _FilterRow extends ConsumerWidget {
  const _FilterRow({required this.selected});

  final NoteFilter selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: NoteFilter.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final f = NoteFilter.values[i];
          return FilterChipPill(
            label: f.label,
            selected: f == selected,
            onTap: () => ref.read(selectedFilterProvider.notifier).select(f),
          );
        },
      ),
    );
  }
}

class _Column extends ConsumerWidget {
  const _Column({required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for (final note in notes)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: SizedBox(
              height: NotesScreen._heights[note.kind],
              child: NoteCard(
                note: note,
                onToggleItem: (i) =>
                    ref.read(notesProvider.notifier).toggleItem(note.id, i),
                onTap: () {
                  if (note.kind == NoteKind.thought) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NoteDetailScreen(note: note),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
      ],
    );
  }
}

/// The floating dock with the add (+) and mic buttons, overlapping circles.
class _BottomDock extends StatelessWidget {
  const _BottomDock();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 12,
            child: _DockButton(
              icon: Icons.add,
              background: Colors.white,
              iconColor: AppColors.ink,
            ),
          ),
          Positioned(
            right: 12,
            child: _DockButton(
              icon: Icons.mic_none_rounded,
              background: Colors.white.withValues(alpha: 0.4),
              iconColor: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _DockButton extends StatelessWidget {
  const _DockButton({
    required this.icon,
    required this.background,
    required this.iconColor,
  });

  final IconData icon;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: iconColor, size: 30),
    );
  }
}
