import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../providers/progress_provider.dart';
import '../utils/logger.dart';

class ProgressExportService {
  static Future<bool> hasProgressToExport(AppProvider appProvider) async {
    // Check if there's any meaningful progress to export
    return appProvider.totalXP > 0 || 
           appProvider.lessonsCompleted > 0 || 
           appProvider.quizzesPassed > 0;
  }

  static Future<bool> exportProgress({
    required AppProvider appProvider,
    required ProgressProvider progressProvider,
  }) async {
    try {
      // Create progress data
      final progressData = {
        'exportDate': DateTime.now().toIso8601String(),
        'appVersion': '1.0.0',
        'userProfile': {
          'name': appProvider.userProfile.name,
          'email': appProvider.userProfile.email,
          'level': appProvider.userProfile.level,
          'totalXP': appProvider.userProfile.totalXP,
          'currentStreak': appProvider.userProfile.currentStreak,
          'longestStreak': appProvider.userProfile.longestStreak,
          'hearts': appProvider.userProfile.hearts,
          'lessonsCompleted': appProvider.userProfile.lessonsCompleted,
          'quizzesPassed': appProvider.userProfile.quizzesPassed,
          'achievements': appProvider.userProfile.achievements,
        },
        'progress': {
          'totalPoints': progressProvider.totalPoints,
          'streak': progressProvider.streak,
          'lessonsCompleted': progressProvider.lessonsCompleted,
          'quizzesPassed': progressProvider.quizzesPassed,
          'totalStudyTime': progressProvider.getTotalStudyTime(),
        },
        'statistics': {
          'exportTimestamp': DateTime.now().millisecondsSinceEpoch,
          'deviceInfo': {
            'platform': Platform.operatingSystem,
            'version': Platform.operatingSystemVersion,
          },
        },
      };

      // Convert to JSON
      final jsonString = const JsonEncoder.withIndent('  ').convert(progressData);

      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'learn_cpp_progress_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');

      // Write to file
      await file.writeAsString(jsonString);

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'My Learn C++ Progress Export',
        subject: 'Learn C++ Progress Data',
      );

      Logger.info('Progress exported successfully to: ${file.path}');
      return true;
    } catch (e) {
      Logger.error('Failed to export progress: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> importProgress(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        Logger.error('Import file does not exist: $filePath');
        return null;
      }

      final jsonString = await file.readAsString();
      final progressData = json.decode(jsonString) as Map<String, dynamic>;

      // Validate the data structure
      if (!progressData.containsKey('userProfile') || 
          !progressData.containsKey('progress')) {
        Logger.error('Invalid progress data format');
        return null;
      }

      Logger.info('Progress imported successfully from: $filePath');
      return progressData;
    } catch (e) {
      Logger.error('Failed to import progress: $e');
      return null;
    }
  }
}