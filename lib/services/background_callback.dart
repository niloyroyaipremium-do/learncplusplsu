import 'dart:async';
import 'dart:isolate';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import '../utils/logger.dart';
import 'notification_service.dart';

/// Background Callback Service
///
/// This service handles background tasks and callbacks for the Learn C++ app.
/// It manages notifications, progress tracking, and data synchronization.
class BackgroundCallbackService {
  static const String _taskName = 'learnCppBackgroundTask';
  static const String _dailyReminderTask = 'dailyReminderTask';
  static const String _streakCheckTask = 'streakCheckTask';
  static const String _progressSyncTask = 'progressSyncTask';

  static final BackgroundCallbackService _instance = BackgroundCallbackService._internal();
  factory BackgroundCallbackService() => _instance;
  BackgroundCallbackService._internal();

  bool _isInitialized = false;
  final NotificationService _notificationService = NotificationService();

  /// Initialize background callback service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize WorkManager
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

      // Initialize notification service
      await _notificationService.initialize();

      // Initialize timezone
      tz.initializeTimeZones();

      _isInitialized = true;
      Logger.info('Background callback service initialized successfully');
    } catch (e) {
      Logger.error('Failed to initialize background callback service', e);
    }
  }

  /// Register background tasks
  Future<void> registerBackgroundTasks() async {
    if (!_isInitialized) {
      await initialize();
    }

    // Daily reminder task (runs every day at 9 AM)
    await Workmanager().registerPeriodicTask(
      _dailyReminderTask,
      _dailyReminderTask,
      frequency: Duration(hours: 24),
      initialDelay: _getInitialDelayForDailyReminder(),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );

    // Streak check task (runs every 6 hours)
    await Workmanager().registerPeriodicTask(
      _streakCheckTask,
      _streakCheckTask,
      frequency: Duration(hours: 6),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );

    // Progress sync task (runs every 12 hours)
    await Workmanager().registerPeriodicTask(
      _progressSyncTask,
      _progressSyncTask,
      frequency: Duration(hours: 12),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );

    Logger.info('Background tasks registered successfully');
  }

  /// Calculate initial delay for daily reminder (next 9 AM)
  Duration _getInitialDelayForDailyReminder() {
    final now = DateTime.now();
    final next9AM = DateTime(now.year, now.month, now.day, 9, 0);

    if (now.hour >= 9) {
      // If it's already past 9 AM today, schedule for tomorrow
      return next9AM.add(Duration(days: 1)).difference(now);
    } else {
      // Schedule for today at 9 AM
      return next9AM.difference(now);
    }
  }

  /// Start background service
  Future<void> start() async {
    if (!_isInitialized) {
      await initialize();
    }

    // Start the main background task
    await Workmanager().registerOneOffTask(
      _taskName,
      _taskName,
      initialDelay: Duration(seconds: 10),
    );

    Logger.info('Background service started');
  }

  /// Stop background service
  Future<void> stop() async {
    await Workmanager().cancelAll();
    Logger.info('Background service stopped');
  }

  /// Check if background service is running
  bool get isRunning => _isInitialized;
}

/// Background task callback dispatcher
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
      body: 'You\'ve been learning for $currentStreak days straight! Keep it up!',
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