import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF6366F1); // Indigo 500
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color info = Color(0xFF0EA5E9); // Sky 500
  static const Color danger = Color(0xFFEF4444); // Red 500

  // Dark Mode Colors
  static const Color bgDark = Color(0xFF0F172A); // Slate 900
  static const Color cardDark = Color(0xFF1E293B); // Slate 800
  static const Color borderDark = Color(0xFF334155); // Slate 700
  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Slate 50
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate 400

  // Light Mode Colors
  static const Color bgLight = Color(0xFFF8FAFC); // Slate 50
  static const Color cardLight = Colors.white;
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200
  static const Color textPrimaryLight = Color(0xFF0F172A); // Slate 900
  static const Color textSecondaryLight = Color(0xFF64748B); // Slate 500

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warning, Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient infoGradient = LinearGradient(
    colors: [info, Color(0xFF0284C7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: success,
        background: bgDark,
        surface: cardDark,
        onBackground: textPrimaryDark,
        onSurface: textPrimaryDark,
      ),
      textTheme: GoogleFonts.promptTextTheme(ThemeData.dark().textTheme).copyWith(
        titleLarge: GoogleFonts.prompt(fontWeight: FontWeight.bold, color: textPrimaryDark),
        headlineMedium: GoogleFonts.prompt(fontWeight: FontWeight.bold, color: textPrimaryDark),
        bodyLarge: GoogleFonts.prompt(color: textPrimaryDark),
        bodyMedium: GoogleFonts.prompt(color: textSecondaryDark),
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: borderDark, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: primary,
        thumbColor: primary,
        inactiveTrackColor: borderDark,
        valueIndicatorColor: primary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimaryDark,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: textPrimaryDark,
        unselectedLabelColor: textSecondaryDark,
        indicatorColor: primary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgLight,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: success,
        background: bgLight,
        surface: cardLight,
        onBackground: textPrimaryLight,
        onSurface: textPrimaryLight,
      ),
      textTheme: GoogleFonts.promptTextTheme(ThemeData.light().textTheme).copyWith(
        titleLarge: GoogleFonts.prompt(fontWeight: FontWeight.bold, color: textPrimaryLight),
        headlineMedium: GoogleFonts.prompt(fontWeight: FontWeight.bold, color: textPrimaryLight),
        bodyLarge: GoogleFonts.prompt(color: textPrimaryLight),
        bodyMedium: GoogleFonts.prompt(color: textSecondaryLight),
      ),
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 2,
        shadowColor: const Color(0x0F0F172A),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: borderLight, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: primary,
        thumbColor: primary,
        inactiveTrackColor: borderLight,
        valueIndicatorColor: primary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimaryLight,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: textPrimaryLight,
        unselectedLabelColor: textSecondaryLight,
        indicatorColor: primary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),
    );
  }
}
