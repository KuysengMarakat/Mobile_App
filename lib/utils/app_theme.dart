import 'package:flutter/material.dart';

/// App theme configuration for Phneak Teb.
/// Uses Material 3 with Royal Purple primary and Gold accent.
class AppTheme {
  // Brand Colors
  static const Color primaryPurple = Color(0xFF6B1F8A);
  static const Color accentGold = Color(0xFFFFD700);
  static const Color darkNavy = Color(0xFF1A1A2E);
  static const Color softGray = Color(0xFFF5F5F7);
  static const Color mediumGray = Color(0xFFE0E0E0);
  static const Color darkGray = Color(0xFF424242);

  // Status Colors
  static const Color safeGreen = Color(0xFF4CAF50);
  static const Color warningYellow = Color(0xFFFFC107);
  static const Color dangerRed = Color(0xFFE53935);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6B1F8A), Color(0xFF4A148C)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4A148C), Color(0xFF6B1F8A), Color(0xFF8E24AA)],
  );


  // Border Radius
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  /// Get the main Material 3 theme.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        primary: primaryPurple,
        secondary: accentGold,
        surface: Colors.white,
        background: softGray,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: softGray,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryPurple,
          side: const BorderSide(color: primaryPurple, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: mediumGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: mediumGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: dangerRed),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryPurple,
        unselectedItemColor: darkGray,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
    );
  }

  /// Get status color based on scan result.
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'safe':
        return safeGreen;
      case 'warning':
        return warningYellow;
      case 'dangerous':
        return dangerRed;
      default:
        return mediumGray;
    }
  }

  /// Get status icon based on scan result.
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'safe':
        return Icons.verified_user;
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'dangerous':
        return Icons.dangerous;
      default:
        return Icons.help_outline;
    }
  }
}
