import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_provider.dart';
import '../providers/progress_provider.dart';
import 'database_service.dart';

class ProgressExportService {
  static const String _exportFileName = 'learn_cpp_progress.json';

  /// Export user progress to a JSON file and share it
  static Future<bool> exportProgress({
    required AppProvider appProvider,
    required ProgressProvider progressProvider,
  }) async {
    try {
      // Collect all progress data
      final progressData = await _collectProgressData(
        appProvider,
        progressProvider,
      );

      // Convert to JSON
      final jsonString = json.encode(progressData);

      // Get the directory for saving the file
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_exportFileName');

      // Write the file
      await file.writeAsString(jsonString);

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'My Learn C++ Progress Export',
        subject: 'Learn C++ Progress Data',
      );

      return true;
    } catch (e) {
      debugPrint('Error exporting progress: $e');
      return false;
    }
  }

  /// Collect all progress data from various sources
  static Future<Map<String, dynamic>> _collectProgressData(
    AppProvider appProvider,
    ProgressProvider progressProvider,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // Get all stored data
    final allKeys = prefs.getKeys();
    final sharedPrefsData = <String, dynamic>{};

    for (final key in allKeys) {
      final value = prefs.get(key);
      if (value != null) {
        sharedPrefsData[key] = value;
      }
    }

    // Quiz results and achievements removed - using progress provider data instead
    final quizResults = <Map<String, dynamic>>[];
    final achievements = <Map<String, dynamic>>[];

    // Collect database statistics
    final databaseStats = await _getDatabaseStatistics();

    return {
      'export_info': {
        'app_name': 'Learn C++',
        'export_date': DateTime.now().toIso8601String(),
        'app_version': '1.0.0',
        'platform': Platform.operatingSystem,
      },
      'user_profile': {
        'name': appProvider.userName,
        'email': appProvider.userEmail,
        'avatar': appProvider.userAvatar,
        'total_xp': appProvider.totalXP,
        'level': appProvider.level,
        'current_streak': appProvider.currentStreak,
        'longest_streak': appProvider.longestStreak,
        'hearts': appProvider.hearts,
        'last_active_date': appProvider.userProfile.lastActiveDate
            ?.toIso8601String(),
        'lessons_completed': appProvider.lessonsCompleted,
        'quizzes_passed': appProvider.quizzesPassed,
        'xp_today': appProvider.xpToday,
        'is_first_launch': appProvider.userProfile.isFirstLaunch,
      },
      'progress_stats': {
        'total_points': progressProvider.totalPoints,
        'streak': progressProvider.streak,
        'lessons_completed': progressProvider.lessonsCompleted,
        'quizzes_passed': progressProvider.quizzesPassed,
      },
      'achievements': achievements,
      'quiz_results': quizResults,
      'database_statistics': databaseStats,
      'app_settings': {
        'theme_mode': appProvider.themeMode.toString(),
        'font_size': appProvider.fontSize,
        'is_first_launch': appProvider.isFirstLaunch,
      },
      'raw_shared_preferences': sharedPrefsData,
    };
  }

  /// Get database statistics
  static Future<Map<String, dynamic>> _getDatabaseStatistics() async {
    try {
      final databaseService = DatabaseService();
      final stats = await databaseService.getStatistics();
      return stats;
    } catch (e) {
      debugPrint('Error getting database statistics: $e');
      return {};
    }
  }

  /// Generate a summary of the progress data
  static String generateProgressSummary(Map<String, dynamic> progressData) {
    final userProfile = progressData['user_profile'] as Map<String, dynamic>;
    final progressStats =
        progressData['progress_stats'] as Map<String, dynamic>;
    final achievements = progressData['achievements'] as List<dynamic>;
    final quizResults = progressData['quiz_results'] as List<dynamic>;
    final dbStats = progressData['database_statistics'] as Map<String, dynamic>;

    final unlockedAchievements = achievements
        .where((a) => a['is_unlocked'] == true)
        .length;
    final totalQuizScore = quizResults.fold<int>(
      0,
      (sum, quiz) => sum + (quiz['score'] as int? ?? 0),
    );
    final averageQuizScore = quizResults.isNotEmpty
        ? totalQuizScore / quizResults.length
        : 0;

    return '''
Learn C++ Progress Summary
========================

User: ${userProfile['name'] ?? 'Guest User'}
Level: ${userProfile['level'] ?? 1}
Total XP: ${userProfile['total_xp'] ?? 0}
Current Streak: ${userProfile['current_streak'] ?? 0}
Longest Streak: ${userProfile['longest_streak'] ?? 0}
Hearts: ${userProfile['hearts'] ?? 5}

Progress:
- Lessons Completed: ${progressStats['lessons_completed'] ?? 0}
- Quizzes Passed: ${progressStats['quizzes_passed'] ?? 0}
- Total Points: ${progressStats['total_points'] ?? 0}

Achievements:
- Unlocked: $unlockedAchievements / ${achievements.length}
- Total Available: ${dbStats['total_achievements'] ?? 0}

Quiz Performance:
- Total Quizzes Taken: ${quizResults.length}
- Average Score: ${averageQuizScore.toStringAsFixed(1)}%
- Total Quiz Score: $totalQuizScore

Database Statistics:
- Total Lessons: ${dbStats['total_lessons'] ?? 0}
- Completed Lessons: ${dbStats['completed_lessons'] ?? 0}
- Total Quizzes: ${dbStats['total_quizzes'] ?? 0}

Export Date: ${progressData['export_info']['export_date']}
App Version: ${progressData['export_info']['app_version']}
Platform: ${progressData['export_info']['platform']}
''';
  }

  /// Check if export is available (has progress data)
  static Future<bool> hasProgressToExport(AppProvider appProvider) async {
    return appProvider.totalXP > 0 ||
        appProvider.lessonsCompleted > 0 ||
        appProvider.quizzesPassed > 0;
  }
}
