import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_theme.dart';
import 'app_text.dart';
import 'glass.dart';

/// Dispatches a [Note] to the right card layout based on its [NoteKind].
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onToggleItem,
  });

  final Note note;
  final VoidCallback? onTap;
  final void Function(int index)? onToggleItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: switch (note.kind) {
        NoteKind.checklist => _ChecklistCard(note: note, onToggle: onToggleItem),
        NoteKind.thought => _ThoughtCard(note: note),
        NoteKind.audio => const _AudioCard(),
        NoteKind.files => const _FilesCard(),
        NoteKind.photos => _PhotosCard(note: note),
        NoteKind.snapshot => _SnapshotCard(note: note),
        NoteKind.pdf => const _PdfCard(),
      },
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.note, this.onToggle});

  final Note note;
  final void Function(int index)? onToggle;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      gradient: AppColors.mintCard,
      opacity: 0.4,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.pixel(note.title, size: 26),
          const SizedBox(height: 12),
          for (var i = 0; i < note.items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ChecklistRow(
                item: note.items[i],
                onTap: () => onToggle?.call(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.item, this.onTap});

  final ChecklistItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.done ? AppColors.ink : Colors.transparent,
                border: Border.all(color: AppColors.ink, width: 1.5),
              ),
              child: item.done
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: AppText(
                item.label,
                size: 13,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThoughtCard extends StatelessWidget {
  const _ThoughtCard({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      opacity: 0.45,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: AppText.heading(note.title)),
          if (note.date != null)
            Align(
              alignment: Alignment.bottomRight,
              child: AppText.caption(note.date!),
            ),
        ],
      ),
    );
  }
}

class _AudioCard extends StatelessWidget {
  const _AudioCard();

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      gradient: AppColors.lilacCard,
      opacity: 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: AppColors.ink, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(child: _Waveform()),
        ],
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  // A simple static waveform built from bars of varied heights.
  static const List<double> _heights = [
    8, 16, 24, 30, 22, 14, 26, 34, 20, 12, 24, 30, 18, 10, 22, 28, 16, 8,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final h in _heights)
          Container(
            width: 3,
            height: h,
            decoration: BoxDecoration(
              color: AppColors.ink.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}

class _FilesCard extends StatelessWidget {
  const _FilesCard();

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      gradient: AppColors.sandCard,
      opacity: 0.4,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.menu_book_rounded,
                color: AppColors.ink, size: 30),
          ),
          const Spacer(),
          AppText.pixel('Files', size: 30, color: const Color(0xFF8A6A3A)),
        ],
      ),
    );
  }
}

class _PhotosCard extends StatelessWidget {
  const _PhotosCard({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _NetworkOrFallback(url: note.imageUrls.firstOrNull),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.45),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title(note.title, color: Colors.white),
                if (note.date != null)
                  AppText.caption(note.date!,
                      color: Colors.white.withValues(alpha: 0.85)),
                const Spacer(),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _Pill(label: '+${note.extraCount}'),
                    const _Pill(label: 'Photos', icon: Icons.photo_outlined),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SnapshotCard extends StatelessWidget {
  const _SnapshotCard({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _NetworkOrFallback(url: note.imageUrls.firstOrNull),
          Container(color: Colors.black.withValues(alpha: 0.25)),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title(note.title, size: 15, color: Colors.white),
                if (note.date != null)
                  AppText.caption(note.date!,
                      color: Colors.white.withValues(alpha: 0.85)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PdfCard extends StatelessWidget {
  const _PdfCard();

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF3D6EC), Color(0xFFE9C4E0)],
      ),
      opacity: 0.4,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.menu_book_rounded,
                color: AppColors.ink, size: 28),
          ),
          const Spacer(),
          AppText.pixel('Pdf',
              size: 38, color: const Color(0xFFB13B8C), weight: FontWeight.w700),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: Colors.white),
            const SizedBox(width: 4),
          ],
          AppText(label, size: 11, color: Colors.white),
        ],
      ),
    );
  }
}

/// Loads a network image, showing a soft gradient placeholder on failure
/// so the layout never breaks when offline.
class _NetworkOrFallback extends StatelessWidget {
  const _NetworkOrFallback({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    const fallback = DecoratedBox(
      decoration: BoxDecoration(gradient: AppColors.auroraGradient),
    );
    if (url == null) return fallback;
    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => fallback,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : fallback,
    );
  }
}
