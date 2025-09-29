import 'dart:isolate';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import '../utils/logger.dart';

/// Background callback dispatcher for WorkManager
///
/// This is the entry point for background tasks executed by WorkManager.
/// It handles different types of background tasks like daily reminders,
/// streak checks, and progress synchronization.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      Logger.info('Background task started: $task');
      
      switch (task) {
        case 'dailyReminderTask':
          await _handleDailyReminder();
          break;
        case 'streakCheckTask':
          await _handleStreakCheck();
          break;
        case 'progressSyncTask':
          await _handleProgressSync();
          break;
        default:
          Logger.warning('Unknown background task: $task');
      }
      
      Logger.info('Background task completed: $task');
      return Future.value(true);
    } catch (e) {
      Logger.error('Background task failed: $task', e);
      return Future.value(false);
    }
  });
}

/// Handle daily reminder notifications
Future<void> _handleDailyReminder() async {
  try {
    // Initialize notification service
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    
    // Android initialization settings
    const androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS initialization settings
    const iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    
    // Check if user has notifications enabled
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    
    if (!notificationsEnabled) {
      Logger.info('Notifications disabled, skipping daily reminder');
      return;
    }
    
    // Check if user has already been reminded today
    final lastReminderDate = prefs.getString('last_reminder_date');
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    if (lastReminderDate == today) {
      Logger.info('Daily reminder already sent today');
      return;
    }
    
    // Schedule notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Time to Learn C++! 🚀',
      'Continue your coding journey with today\'s lesson',
      _nextInstanceOfTime(9, 0), // 9:00 AM
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Learning Reminder',
          channelDescription: 'Daily reminder to continue learning C++',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
    
    // Update last reminder date
    await prefs.setString('last_reminder_date', today);
    Logger.info('Daily reminder scheduled successfully');
    
  } catch (e) {
    Logger.error('Failed to handle daily reminder', e);
  }
}

/// Handle streak check and maintenance
Future<void> _handleStreakCheck() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    // Get current streak data
    final currentStreak = prefs.getInt('current_streak') ?? 0;
    final lastActivityDate = prefs.getString('last_activity_date');
    
    if (lastActivityDate == null) {
      Logger.info('No activity data found, skipping streak check');
      return;
    }
    
    final lastActivity = DateTime.parse(lastActivityDate);
    final today = DateTime.now();
    final daysDifference = today.difference(lastActivity).inDays;
    
    // If more than 1 day has passed, reset streak
    if (daysDifference > 1) {
      await prefs.setInt('current_streak', 0);
      Logger.info('Streak reset due to inactivity');
    } else if (daysDifference == 1) {
      // Streak continues
      Logger.info('Streak maintained: $currentStreak days');
    }
    
  } catch (e) {
    Logger.error('Failed to handle streak check', e);
  }
}

/// Handle progress synchronization
Future<void> _handleProgressSync() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    // Get progress data
    final completedLessons = prefs.getStringList('completed_lessons') ?? [];
    final totalProgress = prefs.getInt('total_progress') ?? 0;
    
    Logger.info('Progress sync: $completedLessons.length lessons completed, $totalProgress total progress');
    
    // In a real app, this would sync with a backend service
    // For now, we just log the progress
    
  } catch (e) {
    Logger.error('Failed to handle progress sync', e);
  }
}

/// Get the next instance of a specific time
tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  
  return scheduledDate;
}