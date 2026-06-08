import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_theme.dart';
import '../widgets/app_text.dart';
import '../widgets/glass.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({super.key, required this.note});

  final Note note;

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  static const _tabs = ['Text', 'Images', 'Audios'];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.auroraGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                children: [
                  _TopBar(onBack: () => Navigator.of(context).pop()),
                  const SizedBox(height: 16),
                  AppText.display('Thought of\nthe day', size: 46),
                  const SizedBox(height: 22),
                  _TabRow(
                    tabs: _tabs,
                    selected: _selected,
                    onSelect: (i) => setState(() => _selected = i),
                  ),
                  const SizedBox(height: 22),
                  const _ReflectionStack(),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: Center(child: _CreateNewButton()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GlassCircleButton(
          icon: Icons.arrow_back_ios_new_rounded,
          size: 50,
          onTap: onBack,
        ),
        const GlassCircleButton(icon: Icons.more_horiz_rounded, size: 50),
      ],
    );
  }
}

class _TabRow extends StatelessWidget {
  const _TabRow({
    required this.tabs,
    required this.selected,
    required this.onSelect,
  });

  final List<String> tabs;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          FilterChipPill(
            label: tabs[i],
            selected: i == selected,
            onTap: () => onSelect(i),
          ),
          const SizedBox(width: 10),
        ],
      ],
    );
  }
}

/// The stacked "Something New" cards with the front Morning Reflection note.
class _ReflectionStack extends StatelessWidget {
  const _ReflectionStack();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Peeking cards behind the main note.
        Positioned(
          top: -14,
          left: 24,
          right: 24,
          child: _PeekCard(color: const Color(0xFFFDF6D8)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: _PeekCard(
            color: Colors.white.withValues(alpha: 0.9),
            label: 'Something New',
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 34),
          child: _MorningReflectionCard(),
        ),
      ],
    );
  }
}

class _PeekCard extends StatelessWidget {
  const _PeekCard({required this.color, this.label});

  final Color color;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      child: label == null ? null : AppText(label!, size: 13),
    );
  }
}

class _MorningReflectionCard extends StatelessWidget {
  const _MorningReflectionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.title('Morning Reflection'),
                    SizedBox(height: 2),
                    AppText.caption('1 Jun 2026, 10:10 AM'),
                  ],
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit_outlined,
                    size: 17, color: AppColors.ink),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const AppText.heading(
            'Embrace the moment and let your spirit soar.',
            size: 19,
            height: 1.25,
          ),
          const SizedBox(height: 12),
          const AppText(
            'Every day is a fresh start—embrace it with hope and courage. '
            'Let each moment inspire you to grow and shine brighter than '
            'before.',
            weight: FontWeight.w400,
            height: 1.5,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _ReflectionImage(gradientIndex: 0)),
              const SizedBox(width: 12),
              Expanded(child: _ReflectionImage(gradientIndex: 1)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReflectionImage extends StatelessWidget {
  const _ReflectionImage({required this.gradientIndex});

  final int gradientIndex;

  static const _gradients = [
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFC36B), Color(0xFFFF7E5F)],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFB199), Color(0xFFFF6B6B)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        gradient: _gradients[gradientIndex],
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _CreateNewButton extends StatelessWidget {
  const _CreateNewButton();

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 30,
      blur: 14,
      opacity: 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.add, color: AppColors.ink, size: 22),
          SizedBox(width: 8),
          AppText.title('Create new'),
        ],
      ),
    );
  }
}
