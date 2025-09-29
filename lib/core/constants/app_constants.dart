/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'CodeLingo';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Duolingo-style programming learning app for C++';

  // Storage Keys
  static const String themeModeKey = 'theme_mode';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
  static const String userAvatarKey = 'user_avatar';
  static const String totalXpKey = 'total_xp';
  static const String currentStreakKey = 'current_streak';
  static const String longestStreakKey = 'longest_streak';
  static const String levelKey = 'level';
  static const String heartsKey = 'hearts';
  static const String lessonsCompletedKey = 'lessons_completed';
  static const String quizzesPassedKey = 'quizzes_passed';
  static const String lastActiveDateKey = 'last_active_date';
  static const String achievementsKey = 'achievements';
  static const String savedLessonsKey = 'saved_lessons';
  static const String lessonProgressKey = 'lesson_progress';

  // Gamification
  static const int maxHearts = 5;
  static const int xpPerLesson = 10;
  static const int xpPerQuiz = 20;
  static const int xpPerLevel = 100;
  static const int maxUndoStackSize = 50;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Code Editor
  static const int tabSize = 4;
  static const String defaultLanguage = 'cpp';

  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'Please check your internet connection.';
  static const String noDataError = 'No data available.';

  // Success Messages
  static const String lessonCompleted = 'Lesson completed successfully!';
  static const String quizPassed = 'Quiz passed! Great job!';
  static const String achievementUnlocked = 'Achievement unlocked!';
}
