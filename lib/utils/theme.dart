import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF1a0a2e);
  static const Color surface = Color(0xFF2d1b4e);
  static const Color neonGreen = Color(0xFF39ff14);
  static const Color neonYellow = Color(0xFFffff00);
  static const Color neonMagenta = Color(0xFFff00ff);
  static const Color neonBlue = Color(0xFF00cfff);
  static const Color cardWhite = Color(0xFFf5f5f5);
  static const Color cardRed = Color(0xFFcc0000);
  static const Color cardBlack = Color(0xFF111111);
  static const Color mutedPurple = Color(0xFF6b4fa0);
  static const Color textPrimary = Colors.white;
  static const Color textMuted = Color(0xFF9e9e9e);
  static const Color goldAccent = Color(0xFFffd700);
}

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonGreen,
        secondary: AppColors.neonYellow,
        surface: AppColors.surface,
        onPrimary: AppColors.cardBlack,
        onSecondary: AppColors.cardBlack,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.pressStart2p(
          fontSize: 32,
          color: AppColors.neonGreen,
          shadows: [_neonShadow(AppColors.neonGreen)],
        ),
        displayMedium: GoogleFonts.pressStart2p(
          fontSize: 24,
          color: AppColors.neonYellow,
          shadows: [_neonShadow(AppColors.neonYellow)],
        ),
        headlineLarge: GoogleFonts.pressStart2p(
          fontSize: 18,
          color: AppColors.neonYellow,
        ),
        headlineMedium: GoogleFonts.pressStart2p(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.robotoMono(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.robotoMono(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        bodySmall: GoogleFonts.robotoMono(
          fontSize: 12,
          color: AppColors.textMuted,
        ),
        labelLarge: GoogleFonts.pressStart2p(
          fontSize: 12,
          color: AppColors.cardBlack,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonGreen,
          foregroundColor: AppColors.cardBlack,
          textStyle: GoogleFonts.pressStart2p(fontSize: 12),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neonGreen,
          side: const BorderSide(color: AppColors.neonGreen, width: 2),
          textStyle: GoogleFonts.pressStart2p(fontSize: 12),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.mutedPurple, width: 1),
        ),
        elevation: 8,
      ),
    );
  }

  static Shadow _neonShadow(Color color) {
    return Shadow(
      color: color.withValues(alpha: 0.8),
      blurRadius: 12,
    );
  }
}
