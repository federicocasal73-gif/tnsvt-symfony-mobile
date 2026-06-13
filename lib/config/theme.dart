import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF08040F);
  static const Color surface = Color(0xFF13081C);
  static const Color surfaceLight = Color(0xFF1A0E26);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldBright = Color(0xFFFFD700);
  static const Color violet = Color(0xFF8A3CFF);
  static const Color violetGlow = Color(0xCC8A3CFF);
  static const Color textPrimary = Color(0xFFE2DCF0);
  static const Color textSecondary = Color(0xFFA499B8);
  static const Color textMuted = Color(0xFF645A78);
  static const Color success = Color(0xFF34C759);
  static const Color danger = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);

  static const String displayFont = 'Cinzel';
  static const String labelFont = 'Orbitron';

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: labelFont,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: goldBright,
        secondary: violet,
        surface: surface,
        error: danger,
      ),
      textTheme: TextTheme(
        bodyLarge: const TextStyle(color: textPrimary, fontFamily: labelFont),
        bodyMedium: const TextStyle(color: textPrimary, fontFamily: labelFont),
        bodySmall: const TextStyle(color: textSecondary, fontFamily: labelFont),
        titleLarge: const TextStyle(color: goldBright, fontWeight: FontWeight.bold, fontFamily: displayFont),
        titleMedium: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontFamily: displayFont),
        labelSmall: const TextStyle(color: textMuted, fontFamily: labelFont, letterSpacing: 1.5),
        labelMedium: const TextStyle(color: textSecondary, fontFamily: labelFont, letterSpacing: 1),
        labelLarge: const TextStyle(color: goldBright, fontFamily: labelFont, fontWeight: FontWeight.bold, letterSpacing: 2),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: goldBright,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: goldBright, fontFamily: displayFont, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
      ),
      cardTheme: const CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: goldBright,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: gold.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: goldBright),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

