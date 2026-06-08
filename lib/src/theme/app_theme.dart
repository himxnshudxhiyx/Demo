import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Color palette and gradients for the "liquid glass" notes aesthetic.
abstract class AppColors {
  static const Color ink = Color(0xFF1C1C22);
  static const Color inkSoft = Color(0xFF5B5B66);
  static const Color accentBlue = Color(0xFF2F7BFF);
  static const Color accentYellow = Color(0xFFF6EE7A);
  static const Color glassStroke = Color(0x66FFFFFF);
  static const Color glassFill = Color(0x40FFFFFF);

  /// Soft pastel sky used behind every screen.
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFBFD4F2),
      Color(0xFFD9C9EE),
      Color(0xFFCBD9EC),
    ],
  );

  /// Warm dreamy gradient used for the detail header.
  static const LinearGradient auroraGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFBBD3F0),
      Color(0xFFE8C7E6),
      Color(0xFFF4C9D6),
      Color(0xFFC9D6EE),
    ],
  );

  static const LinearGradient mintCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFBFE6D8), Color(0xFFB6D8E6)],
  );

  static const LinearGradient sandCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF3ECCF), Color(0xFFE9E2C4)],
  );

  static const LinearGradient lilacCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD9DCF0), Color(0xFFE7D6EC)],
  );
}

abstract class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accentBlue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.transparent,
    );

    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
    );
  }

  /// Pixel / dot-matrix display font used on card titles and labels.
  static TextStyle pixel({double size = 16, Color color = AppColors.ink}) {
    return GoogleFonts.vt323(
      fontSize: size,
      color: color,
      letterSpacing: 1.5,
      height: 1.05,
    );
  }

  /// Font-family name of the pixel font, for use in raw [TextStyle]s.
  static String get pixelFontFamily => GoogleFonts.vt323().fontFamily!;
}
