import 'dart:async';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import '../utils/logger.dart';
import 'notification_service.dart';
import 'background_callback.dart';

/// Background Service for Learn C++ App
///
/// Handles:
/// - Daily learning reminders
/// - Streak tracking
/// - Progress notifications
/// - Data synchronization
class BackgroundService {
  static const String _taskName = 'learnCppBackgroundTask';
  static const String _dailyReminderTask = 'dailyReminderTask';
  static const String _streakCheckTask = 'streakCheckTask';
  static const String _progressSyncTask = 'progressSyncTask';

  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  bool _isInitialized = false;
  final NotificationService _notificationService = NotificationService();

  /// Initialize background service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize WorkManager
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

      // Initialize notification service
      await _notificationService.initialize();

      // Register background tasks
      await _registerBackgroundTasks();

      _isInitialized = true;
      Logger.info('Background service initialized successfully');
    } catch (e) {
      Logger.error('Failed to initialize background service', e);
    }
  }

  /// Register all background tasks
  Future<void> _registerBackgroundTasks() async {
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

