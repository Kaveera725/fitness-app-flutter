import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors - High-Energy Athletic System
  // Background: Deep charcoal-green near-black (#0D0F0D)
  static const Color backgroundDark = Color(0xFF0D0F0D);
  static const Color backgroundLight = Color(0xFF0D0F0D); // Unified to athletic dark

  // Secondary Surface: Dark card background (#1A1D1A), visually distinct without heavy borders
  static const Color surfaceDark = Color(0xFF1A1D1A);
  static const Color surfaceLight = Color(0xFF1A1D1A);
  static const Color surfaceLighter = Color(0xFF222622);
  static const Color surfaceBorder = Color(0xFF282D28); // Subtle 1px boundary

  // Primary Accent: Neon / Lime Green (#B4F81C / #C6FF00) for CTAs, active states, rings, highlights
  static const Color primary = Color(0xFFB4F81C);
  static const Color primaryDark = Color(0xFF96D615);
  static const Color primaryLight = Color(0xFFC6FF00);

  // Direct alias for backward-compatible references
  static const Color accentGreen = Color(0xFFB4F81C);
  static const Color accentOrange = Color(0xFFFF9100);

  // Purple reserved strictly as secondary accent for premium/pro badges
  static const Color accentPurple = Color(0xFF7C4DFF);
  static const Color primaryPurple = Color(0xFF7C4DFF);

  // Text Hierarchy
  static const Color textDark = Color(0xFFF5F7F5); // Crisp off-white for headings & primary text
  static const Color textLight = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF8A8F8A); // Muted athletic grey
  static const Color textMuted = Color(0xFF555A55);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primary,
        surface: surfaceDark,
        onPrimary: Color(0xFF0D0F0D), // High contrast dark text on neon lime
        onSecondary: Color(0xFF0D0F0D),
        onSurface: textDark,
        outline: surfaceBorder,
      ),
      scaffoldBackgroundColor: backgroundDark,
      canvasColor: backgroundDark,
      dividerColor: surfaceBorder,
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textDark,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: textDark,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0D0F0D), // High-contrast on neon lime
          letterSpacing: 0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF0D0F0D),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: surfaceBorder, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF141714),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: surfaceBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: surfaceBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
        hintStyle: GoogleFonts.manrope(
          fontSize: 14,
          color: textSecondary,
        ),
      ),
    );
  }

  // Light theme points to the unified athletic dark design system
  static ThemeData get lightTheme => darkTheme;
}
