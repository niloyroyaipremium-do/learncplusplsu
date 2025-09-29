import 'dart:async';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import '../utils/logger.dart';
import 'notification_service.dart';

/// Background task callback dispatcher
/// This file must be separate from the main service to work with WorkManager
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    Logger.info('Background task executed: $task');

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
        default:
          Logger.warning('Unknown background task: $task');
          return Future.value(true);
      }
    } catch (e) {
      Logger.error('Error in background task $task', e);
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

  try {
    final prefs = await SharedPreferences.getInstance();
    final lastActiveDate = prefs.getString('lastActiveDate');
    final currentDate = DateTime.now().toIso8601String().split('T')[0];

    // Check if user was active today
    if (lastActiveDate != currentDate) {
      await _sendDailyReminderNotification();
    }
  } catch (e) {
    Logger.error('Error in daily reminder task', e);
    // Still send notification as fallback
    await _sendDailyReminderNotification();
  }

  return true;
}

/// Handle streak check task
Future<bool> _handleStreakCheckTask() async {
  Logger.info('Executing streak check task');

  try {
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
  } catch (e) {
    Logger.error('Error in streak check task', e);
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
  try {
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
  } catch (e) {
    Logger.error('Error updating user progress', e);
  }
}

/// Send daily reminder notification
Future<void> _sendDailyReminderNotification() async {
  try {
    final notificationService = NotificationService();
    await notificationService.initialize();

    await notificationService.showNotification(
      id: 1,
      title: 'Time to Learn C++! 🚀',
      body: 'Your daily coding session is waiting. Keep your streak alive!',
      payload: 'daily_reminder',
    );
  } catch (e) {
    Logger.error('Error sending daily reminder notification', e);
  }
}

/// Send motivational notification
Future<void> _sendMotivationalNotification() async {
  try {
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
  } catch (e) {
    Logger.error('Error sending motivational notification', e);
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