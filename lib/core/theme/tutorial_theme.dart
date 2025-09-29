import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

class TutorialTheme {
  // Tutorial-specific colors - Enhanced with Duolingo-inspired palette
  static const Color tutorialPrimary = AppTheme.primaryColor; // Duolingo green
  static const Color tutorialSecondary = AppTheme.secondaryColor; // Duolingo blue
  static const Color tutorialAccent = AppTheme.accentColor; // Duolingo orange
  static const Color tutorialWarning = AppTheme.warningColor;
  static const Color tutorialError = AppTheme.errorColor;
  static const Color tutorialSuccess = AppTheme.successColor;
  static const Color tutorialInfo = AppTheme.purpleColor; // Duolingo purple
  static const Color tutorialPink = AppTheme.pinkColor; // Duolingo pink
  static const Color tutorialGold = AppTheme.goldColor; // Gold for achievements
  
  // Dark theme colors - Enhanced with app theme consistency
  static const Color darkTutorialPrimary = AppTheme.darkPrimaryColor;
  static const Color darkTutorialSecondary = AppTheme.darkSecondaryColor;
  static const Color darkTutorialAccent = AppTheme.accentColor;
  static const Color darkTutorialBackground = AppTheme.darkBackgroundColor;
  static const Color darkTutorialSurface = AppTheme.darkSurfaceColor;
  static const Color darkTutorialCard = Color(0xFF2D2D2D);
  
  // Light theme colors - Enhanced with app theme consistency
  static const Color lightTutorialBackground = Color(0xFFF8F9FA);
  static const Color lightTutorialSurface = Colors.white;
  static const Color lightTutorialCard = Colors.white;
  
  // Code editor colors
  static const Color codeBackground = Color(0xFF0D1117);
  static const Color codeSurface = Color(0xFF161B22);
  static const Color codeKeyword = Color(0xFFD73A49);
  static const Color codeString = Color(0xFF032F62);
  static const Color codeComment = Color(0xFF6A737D);
  static const Color codeNumber = Color(0xFF005CC5);
  static const Color codeFunction = Color(0xFF6F42C1);
  
  // Enhanced gradient definitions with Duolingo-inspired colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [tutorialPrimary, tutorialSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [tutorialAccent, tutorialSuccess],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkTutorialPrimary, darkTutorialSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // New colorful gradients for different tutorial sections
  static const LinearGradient successGradient = LinearGradient(
    colors: [tutorialSuccess, Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    colors: [tutorialWarning, Color(0xFFFFB74D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient infoGradient = LinearGradient(
    colors: [tutorialInfo, tutorialPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [tutorialGold, Color(0xFFFFC107)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Enhanced text styles with better typography
  static TextStyle get tutorialTitle => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: -0.5,
  );
  
  static TextStyle get tutorialSubtitle => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
    height: 1.4,
  );
  
  static TextStyle get sectionTitle => GoogleFonts.inter(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: tutorialPrimary,
    letterSpacing: -0.3,
  );
  
  static TextStyle get sectionSubtitle => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: tutorialSecondary,
    height: 1.3,
  );
  
  static TextStyle get contentText => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.7,
    letterSpacing: 0.1,
  );
  
  static TextStyle get codeText => GoogleFonts.firaCode(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.2,
  );
  
  static TextStyle get buttonText => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
  
  // New enhanced text styles
  static TextStyle get cardTitle => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.2,
  );
  
  static TextStyle get cardContent => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.1,
  );
  
  static TextStyle get navigationTitle => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
  
  static TextStyle get progressText => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.2,
  );

  // Enhanced card themes with better visual effects
  static BoxDecoration get infoCardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: tutorialPrimary.withOpacity(0.15),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: tutorialPrimary.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: tutorialPrimary.withOpacity(0.04),
        blurRadius: 40,
        offset: const Offset(0, 16),
        spreadRadius: 0,
      ),
    ],
  );
  
  static BoxDecoration get darkInfoCardDecoration => BoxDecoration(
    color: darkTutorialCard,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: darkTutorialPrimary.withOpacity(0.2),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: darkTutorialPrimary.withOpacity(0.15),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: darkTutorialPrimary.withOpacity(0.08),
        blurRadius: 40,
        offset: const Offset(0, 16),
        spreadRadius: 0,
      ),
    ],
  );
  
  static BoxDecoration get codeCardDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: tutorialPrimary.withOpacity(0.12),
        blurRadius: 25,
        offset: const Offset(0, 12),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: tutorialPrimary.withOpacity(0.06),
        blurRadius: 50,
        offset: const Offset(0, 24),
        spreadRadius: 0,
      ),
    ],
  );
  
  static BoxDecoration get darkCodeCardDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: darkTutorialPrimary.withOpacity(0.2),
        blurRadius: 25,
        offset: const Offset(0, 12),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: darkTutorialPrimary.withOpacity(0.1),
        blurRadius: 50,
        offset: const Offset(0, 24),
        spreadRadius: 0,
      ),
    ],
  );
  
  // New decorative card styles for different content types
  static BoxDecoration get successCardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: tutorialSuccess.withOpacity(0.2),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: tutorialSuccess.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
    ],
  );
  
  static BoxDecoration get warningCardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: tutorialWarning.withOpacity(0.2),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: tutorialWarning.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
    ],
  );
  
  static BoxDecoration get infoCardDecorationSpecial => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: tutorialInfo.withOpacity(0.2),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: tutorialInfo.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
    ],
  );

  // Enhanced button themes with better visual appeal
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: tutorialPrimary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    textStyle: buttonText,
    elevation: 6,
    shadowColor: tutorialPrimary.withOpacity(0.3),
  );
  
  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: tutorialPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: tutorialPrimary, width: 2),
    ),
    textStyle: buttonText,
    elevation: 0,
  );
  
  static ButtonStyle get accentButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: tutorialAccent,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    textStyle: buttonText,
    elevation: 6,
    shadowColor: tutorialAccent.withOpacity(0.3),
  );
  
  // New button styles for different actions
  static ButtonStyle get successButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: tutorialSuccess,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    textStyle: buttonText,
    elevation: 6,
    shadowColor: tutorialSuccess.withOpacity(0.3),
  );
  
  static ButtonStyle get warningButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: tutorialWarning,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    textStyle: buttonText,
    elevation: 6,
    shadowColor: tutorialWarning.withOpacity(0.3),
  );
  
  static ButtonStyle get infoButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: tutorialInfo,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    textStyle: buttonText,
    elevation: 6,
    shadowColor: tutorialInfo.withOpacity(0.3),
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
  
  // New decorative elements
  static BoxDecoration get floatingCardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: tutorialPrimary.withOpacity(0.1),
        blurRadius: 30,
        offset: const Offset(0, 15),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: tutorialPrimary.withOpacity(0.05),
        blurRadius: 60,
        offset: const Offset(0, 30),
        spreadRadius: 0,
      ),
    ],
  );
  
  static BoxDecoration get darkFloatingCardDecoration => BoxDecoration(
    color: darkTutorialCard,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: darkTutorialPrimary.withOpacity(0.15),
        blurRadius: 30,
        offset: const Offset(0, 15),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: darkTutorialPrimary.withOpacity(0.08),
        blurRadius: 60,
        offset: const Offset(0, 30),
        spreadRadius: 0,
      ),
    ],
  );
  
  // Achievement badge decoration
  static BoxDecoration get achievementBadgeDecoration => BoxDecoration(
    gradient: goldGradient,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: tutorialGold.withOpacity(0.3),
        blurRadius: 15,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
    ],
  );
  
  // Progress bar decoration
  static BoxDecoration get progressBarDecoration => BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.circular(10),
  );
  
  static BoxDecoration get darkProgressBarDecoration => BoxDecoration(
    color: Colors.grey[700],
    borderRadius: BorderRadius.circular(10),
  );
  
  // Code syntax highlighting colors
  static const Map<String, Color> syntaxColors = {
    'keyword': Color(0xFFD73A49),
    'string': Color(0xFF032F62),
    'comment': Color(0xFF6A737D),
    'number': Color(0xFF005CC5),
    'function': Color(0xFF6F42C1),
    'type': Color(0xFFE36209),
    'operator': Color(0xFF24292E),
  };
  
  // Dark mode syntax colors
  static const Map<String, Color> darkSyntaxColors = {
    'keyword': Color(0xFFFF7B72),
    'string': Color(0xFF9ECBFF),
    'comment': Color(0xFF8B949E),
    'number': Color(0xFF79C0FF),
    'function': Color(0xFFD2A8FF),
    'type': Color(0xFFFFA657),
    'operator': Color(0xFFF0F6FC),
  };
}