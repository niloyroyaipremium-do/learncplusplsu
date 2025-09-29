import 'dart:isolate';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../utils/logger.dart';
import 'notification_service.dart';

/// Background callback dispatcher for WorkManager
///
/// This function is called by the WorkManager when background tasks are executed.
/// It handles the actual execution of background tasks in a separate isolate.
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      Logger.info('Background task started: $task');
      
      switch (task) {
        case 'learnCppBackgroundTask':
          return await _handleMainBackgroundTask(inputData);
        case 'dailyReminderTask':
          return await _handleDailyReminderTask(inputData);
        case 'streakCheckTask':
          return await _handleStreakCheckTask(inputData);
        case 'progressSyncTask':
          return await _handleProgressSyncTask(inputData);
        default:
          Logger.warning('Unknown background task: $task');
          return Future.value(false);
      }
    } catch (e) {
      Logger.error('Error executing background task: $task', e);
      return false;
    }
  });
}

/// Handle the main background task
Future<bool> _handleMainBackgroundTask(Map<String, dynamic>? inputData) async {
  try {
    // Initialize services
    await _initializeServices();
    
    // Check user streak
    await _checkUserStreak();
    
    // Send daily reminder if needed
    await _sendDailyReminder();
    
    // Sync progress
    await _syncUserProgress();
    
    Logger.info('Main background task completed successfully');
    return true;
  } catch (e) {
    Logger.error('Error in main background task', e);
    return false;
  }
}

/// Handle daily reminder task
Future<bool> _handleDailyReminderTask(Map<String, dynamic>? inputData) async {
  try {
    await _initializeServices();
    await _sendDailyReminder();
    Logger.info('Daily reminder task completed');
    return true;
  } catch (e) {
    Logger.error('Error in daily reminder task', e);
    return false;
  }
}

/// Handle streak check task
Future<bool> _handleStreakCheckTask(Map<String, dynamic>? inputData) async {
  try {
    await _initializeServices();
    await _checkUserStreak();
    Logger.info('Streak check task completed');
    return true;
  } catch (e) {
    Logger.error('Error in streak check task', e);
    return false;
  }
}

/// Handle progress sync task
Future<bool> _handleProgressSyncTask(Map<String, dynamic>? inputData) async {
  try {
    await _initializeServices();
    await _syncUserProgress();
    Logger.info('Progress sync task completed');
    return true;
  } catch (e) {
    Logger.error('Error in progress sync task', e);
    return false;
  }
}

/// Initialize required services for background tasks
Future<void> _initializeServices() async {
  try {
    // Initialize timezone
    tz.initializeTimeZones();
    
    // Initialize notification service
    final notificationService = NotificationService();
    await notificationService.initialize();
    
    Logger.info('Background services initialized');
  } catch (e) {
    Logger.error('Error initializing background services', e);
  }
}

/// Check user learning streak
Future<void> _checkUserStreak() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final lastLearningDate = prefs.getString('last_learning_date');
    final currentStreak = prefs.getInt('current_streak') ?? 0;
    
    if (lastLearningDate != null) {
      final lastDate = DateTime.parse(lastLearningDate);
      final now = DateTime.now();
      final daysDifference = now.difference(lastDate).inDays;
      
      if (daysDifference == 1) {
        // Streak continues
        await prefs.setInt('current_streak', currentStreak + 1);
        await prefs.setString('last_learning_date', now.toIso8601String());
        
        // Send streak milestone notification
        if ((currentStreak + 1) % 7 == 0) {
          await _sendStreakMilestoneNotification(currentStreak + 1);
        }
      } else if (daysDifference > 1) {
        // Streak broken
        await prefs.setInt('current_streak', 0);
        await prefs.setString('last_learning_date', now.toIso8601String());
      }
    }
    
    Logger.info('User streak checked: $currentStreak days');
  } catch (e) {
    Logger.error('Error checking user streak', e);
  }
}

/// Send daily learning reminder
Future<void> _sendDailyReminder() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final lastReminderDate = prefs.getString('last_reminder_date');
    final now = DateTime.now();
    
    if (lastReminderDate == null || 
        now.difference(DateTime.parse(lastReminderDate)).inDays >= 1) {
      
      final notificationService = NotificationService();
      await notificationService.showNotification(
        id: 1,
        title: 'Daily Learning Reminder',
        body: 'Time to practice C++! Your coding journey continues today.',
        payload: 'daily_reminder',
      );
      
      await prefs.setString('last_reminder_date', now.toIso8601String());
      Logger.info('Daily reminder sent');
    }
  } catch (e) {
    Logger.error('Error sending daily reminder', e);
  }
}

/// Send streak milestone notification
Future<void> _sendStreakMilestoneNotification(int streak) async {
  try {
    final notificationService = NotificationService();
    await notificationService.showNotification(
      id: 2,
      title: 'Streak Milestone! 🔥',
      body: 'You\'ve been learning for $streak days straight! Keep it up!',
      payload: 'streak_milestone',
    );
    
    Logger.info('Streak milestone notification sent: $streak days');
  } catch (e) {
    Logger.error('Error sending streak milestone notification', e);
  }
}

/// Sync user progress
Future<void> _syncUserProgress() async {
  try {
    // This would typically sync with a backend service
    // For now, we'll just log the sync attempt
    Logger.info('Syncing user progress...');
    
    // TODO: Implement actual sync logic with backend
    // - Upload progress data
    // - Download new lessons
    // - Sync user preferences
    
    Logger.info('Progress sync completed');
  } catch (e) {
    Logger.error('Error syncing user progress', e);
  }
}