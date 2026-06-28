import 'package:flutter/material.dart';

/// Premium design system for Phneak Teb.
/// Material 3 with a refined Royal Purple + Gold identity, layered soft
/// shadows, tonal surfaces, and a consistent spacing/typography scale.
class AppTheme {
  // ---------------------------------------------------------------------------
  // BRAND PALETTE
  // ---------------------------------------------------------------------------
  static const Color primaryPurple = Color(0xFF6B1F8A);
  static const Color primaryPurpleDark = Color(0xFF4A148C);
  static const Color primaryPurpleLight = Color(0xFF9C3FBF);
  static const Color primaryPurpleSoft = Color(0xFFF3EAF8); // tinted surface

  static const Color accentGold = Color(0xFFFFD700);
  static const Color accentGoldDeep = Color(0xFFE6B800);

  static const Color darkNavy = Color(0xFF14132A);
  static const Color ink = Color(0xFF1C1B2E); // primary text
  static const Color inkMuted = Color(0xFF6B6880); // secondary text
  static const Color inkFaint = Color(0xFFA09DB3); // tertiary text

  // Neutral surfaces
  static const Color canvas = Color(0xFFF6F4FB); // app background (purple tint)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFFAF8FE);
  static const Color hairline = Color(0xFFEAE7F2); // subtle borders
  static const Color softGray = Color(0xFFF6F4FB);
  static const Color mediumGray = Color(0xFFEAE7F2);
  static const Color darkGray = Color(0xFF6B6880);

  // ---------------------------------------------------------------------------
  // STATUS PALETTE (color + soft tint background)
  // ---------------------------------------------------------------------------
  static const Color safeGreen = Color(0xFF1FB573);
  static const Color safeGreenSoft = Color(0xFFE6F7EF);
  static const Color warningYellow = Color(0xFFF5A300);
  static const Color warningYellowSoft = Color(0xFFFFF4E0);
  static const Color dangerRed = Color(0xFFEF3E4A);
  static const Color dangerRedSoft = Color(0xFFFDEAEC);


  // ---------------------------------------------------------------------------
  // GRADIENTS
  // ---------------------------------------------------------------------------
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7B26A0), Color(0xFF4A148C)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8E2DB5), Color(0xFF5C1A86), Color(0xFF3D1170)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF3D1170), Color(0xFF5C1A86), Color(0xFF8E2DB5)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFE066), Color(0xFFF5C518)],
  );

  // ---------------------------------------------------------------------------
  // ELEVATION / SHADOWS (soft, layered, purple-tinted)
  // ---------------------------------------------------------------------------
  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: const Color(0xFF6B1F8A).withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: const Color(0xFF2A1240).withOpacity(0.07),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: const Color(0xFF2A1240).withOpacity(0.12),
          blurRadius: 36,
          spreadRadius: -4,
          offset: const Offset(0, 18),
        ),
      ];

  static List<BoxShadow> glow(Color color, {double opacity = 0.35}) => [
        BoxShadow(
          color: color.withOpacity(opacity),
          blurRadius: 28,
          spreadRadius: 2,
        ),
      ];


  // ---------------------------------------------------------------------------
  // RADIUS & SPACING SCALE
  // ---------------------------------------------------------------------------
  static const double radiusXs = 10.0;
  static const double radiusSmall = 14.0;
  static const double radiusMedium = 20.0;
  static const double radiusLarge = 28.0;
  static const double radiusXl = 36.0;

  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // ---------------------------------------------------------------------------
  // THEME
  // ---------------------------------------------------------------------------
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        primary: primaryPurple,
        secondary: accentGoldDeep,
        surface: surface,
        background: canvas,
        error: dangerRed,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: canvas,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryPurple,
          side: const BorderSide(color: hairline, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceAlt,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        hintStyle: const TextStyle(color: inkFaint, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primaryPurple, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: dangerRed, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: dangerRed, width: 1.8),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryPurple,
        unselectedItemColor: inkFaint,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
      ),
      dividerTheme: const DividerThemeData(
        color: hairline,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
    );
  }

  /// Refined typography scale with tightened tracking.
  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displaySmall: const TextStyle(
          fontWeight: FontWeight.w800, color: ink, letterSpacing: -0.5),
      headlineMedium: const TextStyle(
          fontWeight: FontWeight.w800, color: ink, letterSpacing: -0.5),
      headlineSmall: const TextStyle(
          fontWeight: FontWeight.w700, color: ink, letterSpacing: -0.3),
      titleLarge: const TextStyle(
          fontWeight: FontWeight.w700, color: ink, letterSpacing: -0.2),
      titleMedium: const TextStyle(fontWeight: FontWeight.w600, color: ink),
      bodyLarge: const TextStyle(color: ink, height: 1.45),
      bodyMedium: const TextStyle(color: inkMuted, height: 1.45),
      labelLarge: const TextStyle(fontWeight: FontWeight.w700, color: ink),
    );
  }


  // ---------------------------------------------------------------------------
  // STATUS HELPERS
  // ---------------------------------------------------------------------------
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'safe':
        return safeGreen;
      case 'warning':
        return warningYellow;
      case 'dangerous':
        return dangerRed;
      default:
        return inkFaint;
    }
  }

  static Color getStatusSoftColor(String status) {
    switch (status.toLowerCase()) {
      case 'safe':
        return safeGreenSoft;
      case 'warning':
        return warningYellowSoft;
      case 'dangerous':
        return dangerRedSoft;
      default:
        return mediumGray;
    }
  }

  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'safe':
        return Icons.verified_user_rounded;
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'dangerous':
        return Icons.gpp_bad_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}
