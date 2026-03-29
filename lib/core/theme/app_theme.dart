import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF8B5CF6);

  // Surfaces and Backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Semantic & Feedback
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  // Dark Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkTextPrimary = Color.fromARGB(255, 185, 186, 188);
  static const Color darkTextSecondary = Color.fromARGB(255, 63, 83, 110);

  // Colorful Colors
  static const Color colorfulPrimary = Color(0xFFFF6B6B);
  static const Color colorfulSecondary = Color(0xFF4ECDC4);
  static const Color colorfulBackground = Color(0xFFFFF9E6);
  static const Color colorfulSurface = Color(0xFFFFFFFF);
  static const Color colorfulTextPrimary = Color(0xFF2D3436);
  static const Color colorfulTextSecondary = Color(0xFF636E72);

  // Minimalist Colors
  static const Color minimalistBackground = Color(0xFFFAFAFA);
  static const Color minimalistSurface = Color(0xFFFFFFFF);
  static const Color minimalistTextPrimary = Color(0xFF212121);
  static const Color minimalistTextSecondary = Color(0xFF757575);

  // Glass Colors (semi-transparent blues)
  static const Color glassPrimary = Color(0xFF3B82F6);
  static const Color glassBackground = Color(0xFFE0F2FE);
  static const Color glassSurface = Color(0x80FFFFFF); // semi-transparent white
  static const Color glassTextPrimary = Color(0xFF1E293B);
  static const Color glassTextSecondary = Color(0xFF64748B);

  // Gradient helper
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primaryLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryLight,
        background: background,
        surface: surface,
        primary: primaryLight,
        error: error,
      ),
      textTheme: TextTheme(
        displaySmall: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: surfaceVariant, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              primaryLight, // Ideally gradient, handled via custom button
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryLight, width: 1.5),
        ),
        labelStyle: GoogleFonts.outfit(color: textSecondary),
        hintStyle: GoogleFonts.outfit(color: textSecondary),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryLight,
        brightness: Brightness.dark,
        background: darkBackground,
        surface: darkSurface,
        primary: primaryLight,
        error: error,
      ),
      textTheme: TextTheme(
        displaySmall: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: darkTextPrimary,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: darkTextPrimary,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: darkTextPrimary,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: darkTextSecondary,
        ),
        labelLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: darkTextPrimary),
        titleTextStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: darkTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: darkSurfaceVariant, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryLight, width: 1.5),
        ),
        labelStyle: GoogleFonts.outfit(color: darkTextSecondary),
        hintStyle: GoogleFonts.outfit(color: darkTextSecondary),
      ),
    );
  }

  static ThemeData get colorfulTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colorfulBackground,
      primaryColor: colorfulPrimary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorfulPrimary,
        background: colorfulBackground,
        surface: colorfulSurface,
        primary: colorfulPrimary,
        error: error,
      ),
      textTheme: TextTheme(
        displaySmall: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: colorfulTextPrimary,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: colorfulTextPrimary,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: colorfulTextPrimary,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: colorfulTextSecondary,
        ),
        labelLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorfulBackground,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: colorfulTextPrimary),
        titleTextStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: colorfulTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorfulSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colorfulSecondary.withOpacity(0.2), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorfulPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorfulPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorfulSecondary.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorfulPrimary, width: 1.5),
        ),
        labelStyle: GoogleFonts.outfit(color: colorfulTextSecondary),
        hintStyle: GoogleFonts.outfit(color: colorfulTextSecondary),
      ),
    );
  }

  static ThemeData get minimalistTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: minimalistBackground,
      primaryColor: primaryLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryLight,
        background: minimalistBackground,
        surface: minimalistSurface,
        primary: primaryLight,
        error: error,
      ),
      textTheme: TextTheme(
        displaySmall: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: minimalistTextPrimary,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: minimalistTextPrimary,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: minimalistTextPrimary,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: minimalistTextSecondary,
        ),
        labelLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: minimalistBackground,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: minimalistTextPrimary),
        titleTextStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: minimalistTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: minimalistSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: minimalistTextSecondary.withOpacity(0.2), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: minimalistTextSecondary.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryLight, width: 1.5),
        ),
        labelStyle: GoogleFonts.outfit(color: minimalistTextSecondary),
        hintStyle: GoogleFonts.outfit(color: minimalistTextSecondary),
      ),
    );
  }

  static ThemeData get glassTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: glassBackground,
      primaryColor: glassPrimary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: glassPrimary,
        background: glassBackground,
        surface: glassSurface,
        primary: glassPrimary,
        error: error,
      ),
      textTheme: TextTheme(
        displaySmall: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: glassTextPrimary,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: glassTextPrimary,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: glassTextPrimary,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: glassTextSecondary,
        ),
        labelLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: glassSurface,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: glassTextPrimary),
        titleTextStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: glassTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: glassSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: glassPrimary.withOpacity(0.2), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: glassPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: glassPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glassSurface,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: glassPrimary, width: 1.5),
        ),
        labelStyle: GoogleFonts.outfit(color: glassTextSecondary),
        hintStyle: GoogleFonts.outfit(color: glassTextSecondary),
      ),
    );
  }

  static ThemeData customTheme({
    required Color primary,
    required Color secondary,
    required Color background,
    required Color surface,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        background: background,
        surface: surface,
        primary: primary,
        secondary: secondary,
        error: error,
      ),
      textTheme: TextTheme(
        displaySmall: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: textSecondary.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: textSecondary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        labelStyle: GoogleFonts.outfit(color: textSecondary),
        hintStyle: GoogleFonts.outfit(color: textSecondary),
      ),
    );
  }
}
