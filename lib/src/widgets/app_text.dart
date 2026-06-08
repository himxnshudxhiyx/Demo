import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A single text widget for the whole app.
///
/// The default constructor renders the most common style — 14pt, medium
/// weight, ink colour — so most call sites are just `AppText('Hello')`.
/// Override only what differs via the named parameters, or reach for one of
/// the named constructors ([AppText.heading], [AppText.title], etc.) for the
/// recurring roles in the design.
class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.size = 14,
    this.weight = FontWeight.w500,
    this.color = AppColors.ink,
    this.height,
    this.letterSpacing,
    this.maxLines,
    this.overflow,
    this.align,
    this.shadows,
    this.fontFamily,
  });

  /// Big accent-blue headline — e.g. the thought / reflection titles.
  const AppText.heading(
    this.data, {
    super.key,
    this.size = 24,
    this.weight = FontWeight.w700,
    this.color = AppColors.accentBlue,
    this.height = 1.05,
    this.letterSpacing,
    this.maxLines,
    this.overflow,
    this.align,
    this.shadows,
    this.fontFamily,
  });

  /// Section / card title — 16pt semibold ink.
  const AppText.title(
    this.data, {
    super.key,
    this.size = 16,
    this.weight = FontWeight.w600,
    this.color = AppColors.ink,
    this.height,
    this.letterSpacing,
    this.maxLines,
    this.overflow,
    this.align,
    this.shadows,
    this.fontFamily,
  });

  /// Muted metadata — dates, timestamps. 11pt soft ink.
  const AppText.caption(
    this.data, {
    super.key,
    this.size = 11,
    this.weight = FontWeight.w400,
    this.color = AppColors.inkSoft,
    this.height,
    this.letterSpacing,
    this.maxLines,
    this.overflow,
    this.align,
    this.shadows,
    this.fontFamily,
  });

  /// Large glowing display title on a light/photo background (white + halo).
  AppText.display(
    this.data, {
    super.key,
    this.size = 40,
    this.weight = FontWeight.w600,
    this.color = Colors.white,
    this.height = 1.05,
    this.letterSpacing,
    this.maxLines,
    this.overflow,
    this.align,
    this.fontFamily,
  }) : shadows = [
          Shadow(color: Colors.white.withValues(alpha: 0.55), blurRadius: 18),
        ];

  /// VT323 pixel / dot-matrix label used on the scrapbook cards.
  AppText.pixel(
    this.data, {
    super.key,
    this.size = 26,
    this.color = AppColors.ink,
    this.weight = FontWeight.w400,
    this.height = 1.05,
    this.letterSpacing = 1.5,
    this.maxLines,
    this.overflow,
    this.align,
    this.shadows,
  }) : fontFamily = AppTheme.pixelFontFamily;

  final String data;
  final double size;
  final FontWeight weight;
  final Color color;
  final double? height;
  final double? letterSpacing;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? align;
  final List<Shadow>? shadows;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: align,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        shadows: shadows,
        fontFamily: fontFamily,
      ),
    );
  }
}
