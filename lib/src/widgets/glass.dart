import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_text.dart';

/// A frosted "liquid glass" surface: a blurred, translucent panel with a
/// soft white stroke and a top-light highlight.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 28,
    this.blur = 18,
    this.padding = const EdgeInsets.all(16),
    this.gradient,
    this.opacity = 0.35,
  });

  final Widget child;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: opacity + 0.15),
                    Colors.white.withValues(alpha: opacity - 0.1),
                  ],
                ),
            border: Border.all(color: AppColors.glassStroke, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// A circular frosted button (the back / more / mic / add controls).
class GlassCircleButton extends StatelessWidget {
  const GlassCircleButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 48,
    this.iconColor = AppColors.ink,
    this.background,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color iconColor;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: background ?? Colors.white.withValues(alpha: 0.3),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(icon, color: iconColor, size: size * 0.42),
            ),
          ),
        ),
      ),
    );
  }
}

/// The pill-shaped filter chip used in the horizontal selector rows.
class FilterChipPill extends StatelessWidget {
  const FilterChipPill({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accentYellow
              : Colors.white.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.6),
          ),
        ),
        child: AppText(
          label,
          weight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
