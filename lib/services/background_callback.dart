import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'notification_service.dart';
import '../utils/logger.dart';

/// Background callback dispatcher for Workmanager
/// This file handles background tasks for the CodeLingo app
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case 'learnCppBackgroundTask':
          return await _handleMainBackgroundTask();
        case 'dailyReminderTask':
          return await _handleDailyReminderTask();
        case 'streakCheckTask':
          return await _handleStreakCheckTask();
        case 'progressSyncTask':
          return await _handleProgressSyncTask();
        case 'background_lesson_sync':
          await _handleLessonSync(inputData);
          break;
        case 'background_progress_save':
          await _handleProgressSave(inputData);
          break;
        case 'background_cleanup':
          await _handleCleanup(inputData);
          break;
        default:
          if (kDebugMode) {
            print('Unknown background task: $task');
          }
      }
      return Future.value(true);
    } catch (e) {
      if (kDebugMode) {
        print('Background task error: $e');
      }
      return Future.value(false);
    }
  });
}

/// Handle main background task
Future<bool> _handleMainBackgroundTask() async {
  Logger.info('Executing main background task');

  // Initialize timezone
  tz.initializeTimeZones();

  // Check and update user progress
  await _updateUserProgress();

  // Send motivational notification if needed
  await _sendMotivationalNotification();

  return true;
}

/// Handle daily reminder task
Future<bool> _handleDailyReminderTask() async {
  Logger.info('Executing daily reminder task');

  final prefs = await SharedPreferences.getInstance();
  final lastActiveDate = prefs.getString('lastActiveDate');
  final currentDate = DateTime.now().toIso8601String().split('T')[0];

  // Check if user was active today
  if (lastActiveDate != currentDate) {
    await _sendDailyReminderNotification();
  }

  return true;
}

/// Handle streak check task
Future<bool> _handleStreakCheckTask() async {
  Logger.info('Executing streak check task');

  final prefs = await SharedPreferences.getInstance();
  final lastActiveDate = prefs.getString('lastActiveDate');
  final currentStreak = prefs.getInt('currentStreak') ?? 0;

  if (lastActiveDate != null) {
    final lastActive = DateTime.parse(lastActiveDate);
    final daysSinceLastActive = DateTime.now().difference(lastActive).inDays;

    if (daysSinceLastActive > 1) {
      // Streak broken, reset to 0
      await prefs.setInt('currentStreak', 0);
      Logger.info('Streak broken, reset to 0');
    }
  }

  return true;
}

/// Handle progress sync task
Future<bool> _handleProgressSyncTask() async {
  Logger.info('Executing progress sync task');

  // Sync user progress data
  await _syncUserProgress();

  return true;
}

/// Update user progress
Future<void> _updateUserProgress() async {
  final prefs = await SharedPreferences.getInstance();
  final currentDate = DateTime.now().toIso8601String().split('T')[0];

  // Update last active date
  await prefs.setString('lastActiveDate', currentDate);

  // Update streak if needed
  final lastActiveDate = prefs.getString('lastActiveDate');
  final currentStreak = prefs.getInt('currentStreak') ?? 0;

  if (lastActiveDate != null) {
    final lastActive = DateTime.parse(lastActiveDate);
    final daysSinceLastActive = DateTime.now().difference(lastActive).inDays;

    if (daysSinceLastActive == 1) {
      // Continue streak
      await prefs.setInt('currentStreak', currentStreak + 1);
    }
  }
}

/// Send daily reminder notification
Future<void> _sendDailyReminderNotification() async {
  final notificationService = NotificationService();
  await notificationService.initialize();

  await notificationService.showNotification(
    id: 1,
    title: 'Time to Learn C++! 🚀',
    body: 'Your daily coding session is waiting. Keep your streak alive!',
    payload: 'daily_reminder',
  );
}

/// Send motivational notification
Future<void> _sendMotivationalNotification() async {
  final prefs = await SharedPreferences.getInstance();
  final currentStreak = prefs.getInt('currentStreak') ?? 0;

  if (currentStreak > 0 && currentStreak % 7 == 0) {
    // Weekly milestone
    final notificationService = NotificationService();
    await notificationService.initialize();

    await notificationService.showNotification(
      id: 2,
      title: 'Amazing Streak! 🔥',
      body:
          'You\'ve been learning for $currentStreak days straight! Keep it up!',
      payload: 'streak_milestone',
    );
  }
}

/// Sync user progress
Future<void> _syncUserProgress() async {
  // This would typically sync with a backend service
  // For now, we'll just log the sync attempt
  Logger.info('Syncing user progress...');

  // TODO: Implement actual sync logic with backend
  // - Upload progress data
  // - Download new lessons
  // - Sync user preferences
}

/// Handle lesson synchronization in background
Future<void> _handleLessonSync(Map<String, dynamic>? inputData) async {
  if (kDebugMode) {
    print('Background lesson sync started');
  }
  
  // TODO: Implement lesson synchronization logic
  // This could include:
  // - Syncing lesson progress with server
  // - Downloading new lessons
  // - Updating lesson content
  
  await Future.delayed(const Duration(seconds: 1)); // Simulate work
  
  if (kDebugMode) {
    print('Background lesson sync completed');
  }
}

/// Handle progress saving in background
Future<void> _handleProgressSave(Map<String, dynamic>? inputData) async {
  if (kDebugMode) {
    print('Background progress save started');
  }
  
  // TODO: Implement progress saving logic
  // This could include:
  // - Saving user progress to local database
  // - Syncing progress with cloud storage
  // - Updating analytics data
  
  await Future.delayed(const Duration(seconds: 1)); // Simulate work
  
  if (kDebugMode) {
    print('Background progress save completed');
  }
}

/// Handle cleanup tasks in background
Future<void> _handleCleanup(Map<String, dynamic>? inputData) async {
  if (kDebugMode) {
    print('Background cleanup started');
  }
  
  // TODO: Implement cleanup logic
  // This could include:
  // - Cleaning temporary files
  // - Clearing old cache data
  // - Optimizing database
  // - Removing unused resources
  
  await Future.delayed(const Duration(seconds: 1)); // Simulate work
  
  if (kDebugMode) {
    print('Background cleanup completed');
  }
}