import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

class TutorialTheme {
  // Tutorial-specific colors
  static const Color tutorialPrimary = Color(0xFF1A73E8);
  static const Color tutorialSecondary = Color(0xFF4285F4);
  static const Color tutorialAccent = Color(0xFF34A853);
  static const Color tutorialWarning = Color(0xFFFBBC04);
  static const Color tutorialError = Color(0xFFEA4335);
  static const Color tutorialSuccess = Color(0xFF34A853);
  static const Color tutorialInfo = Color(0xFF1A73E8);
  
  // Dark theme colors
  static const Color darkTutorialPrimary = Color(0xFF4285F4);
  static const Color darkTutorialSecondary = Color(0xFF5A9DFF);
  static const Color darkTutorialAccent = Color(0xFF4CAF50);
  static const Color darkTutorialBackground = Color(0xFF0D1117);
  static const Color darkTutorialSurface = Color(0xFF161B22);
  static const Color darkTutorialCard = Color(0xFF21262D);
  
  // Light theme colors
  static const Color lightTutorialBackground = Color(0xFFF8F9FA);
  static const Color lightTutorialSurface = Color(0xFFFFFFFF);
  static const Color lightTutorialCard = Color(0xFFFFFFFF);
  
  // Code editor colors
  static const Color codeBackground = Color(0xFF0D1117);
  static const Color codeSurface = Color(0xFF161B22);
  static const Color codeKeyword = Color(0xFFD73A49);
  static const Color codeString = Color(0xFF032F62);
  static const Color codeComment = Color(0xFF6A737D);
  static const Color codeNumber = Color(0xFF005CC5);
  static const Color codeFunction = Color(0xFF6F42C1);
  
  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [tutorialPrimary, tutorialSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [tutorialAccent, Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkTutorialPrimary, darkTutorialSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text styles
  static TextStyle get tutorialTitle => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static TextStyle get tutorialSubtitle => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
  );
  
  static TextStyle get sectionTitle => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: tutorialPrimary,
  );
  
  static TextStyle get sectionSubtitle => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: tutorialSecondary,
  );
  
  static TextStyle get contentText => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );
  
  static TextStyle get codeText => GoogleFonts.firaCode(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  
  static TextStyle get buttonText => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Card themes
  static BoxDecoration get infoCardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: tutorialPrimary.withOpacity(0.2),
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: tutorialPrimary.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  static BoxDecoration get darkInfoCardDecoration => BoxDecoration(
    color: darkTutorialCard,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: darkTutorialPrimary.withOpacity(0.3),
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: darkTutorialPrimary.withOpacity(0.2),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  static BoxDecoration get codeCardDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: tutorialPrimary.withOpacity(0.2),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
  );
  
  static BoxDecoration get darkCodeCardDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: darkTutorialPrimary.withOpacity(0.3),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
  );

  // Button themes
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: tutorialPrimary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: buttonText,
    elevation: 4,
  );
  
  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: tutorialPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: tutorialPrimary, width: 2),
    ),
    textStyle: buttonText,
    elevation: 0,
  );
  
  static ButtonStyle get accentButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: tutorialAccent,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: buttonText,
    elevation: 4,
  );

  // Tab bar theme
  static TabBarTheme get tabBarTheme => TabBarTheme(
    labelColor: tutorialPrimary,
    unselectedLabelColor: Colors.grey[600],
    labelStyle: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: tutorialPrimary, width: 3),
      insets: const EdgeInsets.symmetric(horizontal: 16),
    ),
  );
  
  static TabBarTheme get darkTabBarTheme => TabBarTheme(
    labelColor: darkTutorialPrimary,
    unselectedLabelColor: Colors.grey[400],
    labelStyle: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: darkTutorialPrimary, width: 3),
      insets: const EdgeInsets.symmetric(horizontal: 16),
    ),
  );

  // Progress indicator theme
  static LinearProgressIndicatorThemeData get progressTheme => LinearProgressIndicatorThemeData(
    backgroundColor: Colors.grey[300],
    valueColor: AlwaysStoppedAnimation<Color>(tutorialPrimary),
    minHeight: 6,
  );
  
  static LinearProgressIndicatorThemeData get darkProgressTheme => LinearProgressIndicatorThemeData(
    backgroundColor: Colors.grey[700],
    valueColor: AlwaysStoppedAnimation<Color>(darkTutorialPrimary),
    minHeight: 6,
  );

  // App bar theme
  static AppBarTheme get tutorialAppBarTheme => AppBarTheme(
    backgroundColor: tutorialPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
  
  static AppBarTheme get darkTutorialAppBarTheme => AppBarTheme(
    backgroundColor: darkTutorialPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );

  // Navigation item theme
  static BoxDecoration get navigationItemDecoration => BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(8),
  );
  
  static BoxDecoration get activeNavigationItemDecoration => BoxDecoration(
    color: tutorialPrimary.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: tutorialPrimary.withOpacity(0.3),
      width: 1,
    ),
  );
  
  static BoxDecoration get darkActiveNavigationItemDecoration => BoxDecoration(
    color: darkTutorialPrimary.withOpacity(0.2),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: darkTutorialPrimary.withOpacity(0.5),
      width: 1,
    ),
  );

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Animation curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve slideCurve = Curves.easeInOutCubic;
}