// Local analytics service (Firebase removed)
import 'package:flutter/foundation.dart';
import '../utils/logger.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  // Local analytics tracking
  final Map<String, dynamic> _analyticsData = {};
  final List<Map<String, dynamic>> _events = [];
  bool _isInitialized = false;

  /// Initialize analytics service
  Future<void> initialize() async {
    try {
      if (kDebugMode) {
        Logger.info('Analytics initialized in debug mode (local tracking)');
      }

      // Set up error handling
      FlutterError.onError = (FlutterErrorDetails details) {
        recordError(details.exception, details.stack, fatal: true);
      };

      // Set up platform error handling
      PlatformDispatcher.instance.onError = (error, stack) {
        recordError(error, stack, fatal: true);
        return true;
      };

      _isInitialized = true;
      Logger.info('Analytics service initialized (local mode)');
    } catch (e) {
      Logger.error('Failed to initialize analytics: $e');
    }
  }

  /// Track screen view
  Future<void> logScreenView(String screenName, {String? screenClass}) async {
    if (!_isInitialized) return;

    try {
      _events.add({
        'type': 'screen_view',
        'screen_name': screenName,
        'screen_class': screenClass ?? screenName,
        'timestamp': DateTime.now().toIso8601String(),
      });
      Logger.info('Screen view logged: $screenName');
    } catch (e) {
      Logger.error('Failed to log screen view: $e');
    }
  }

  /// Track lesson completion
  Future<void> logLessonCompleted(
    String lessonId,
    String lessonTitle, {
    int? duration,
    int? score,
  }) async {
    if (!_isInitialized) return;

    try {
      _events.add({
        'type': 'lesson_completed',
        'lesson_id': lessonId,
        'lesson_title': lessonTitle,
        'duration_seconds': duration,
        'score': score,
        'timestamp': DateTime.now().toIso8601String(),
      });
      Logger.info('Lesson completion logged: $lessonTitle');
    } catch (e) {
      Logger.error('Failed to log lesson completion: $e');
    }
  }

  /// Track quiz completion
  Future<void> logQuizCompleted(
    String quizId,
    String quizTitle, {
    int? score,
    int? totalQuestions,
    int? duration,
    bool? passed,
  }) async {
    if (!_isInitialized) return;

    try {
      _events.add({
        'type': 'quiz_completed',
        'quiz_id': quizId,
        'quiz_title': quizTitle,
        'score': score,
        'total_questions': totalQuestions,
        'duration_seconds': duration,
        'passed': passed,
        'timestamp': DateTime.now().toIso8601String(),
      });
      Logger.info('Quiz completion logged: $quizTitle');
    } catch (e) {
      Logger.error('Failed to log quiz completion: $e');
    }
  }

  /// Track code execution
  Future<void> logCodeExecution(
    String language, {
    bool? success,
    int? executionTime,
    String? error,
  }) async {
    if (!_isInitialized) return;

    try {
      _events.add({
        'type': 'code_execution',
        'language': language,
        'success': success,
        'execution_time_ms': executionTime,
        'error_type': error,
        'timestamp': DateTime.now().toIso8601String(),
      });
      Logger.info('Code execution logged: $language');
    } catch (e) {
      Logger.error('Failed to log code execution: $e');
    }
  }

  /// Track user engagement
  Future<void> logUserEngagement(
    String action, {
    String? category,
    String? label,
    int? value,
  }) async {
    if (!_isInitialized) return;

    try {
      _events.add({
        'type': 'user_engagement',
        'action': action,
        'category': category,
        'label': label,
        'value': value,
        'timestamp': DateTime.now().toIso8601String(),
      });
      Logger.info('User engagement logged: $action');
    } catch (e) {
      Logger.error('Failed to log user engagement: $e');
    }
  }

  /// Track achievement unlock
  Future<void> logAchievementUnlocked(
    String achievementId,
    String achievementTitle,
  ) async {
    if (!_isInitialized) return;

    try {
      _events.add({
        'type': 'achievement_unlocked',
        'achievement_id': achievementId,
        'achievement_title': achievementTitle,
        'timestamp': DateTime.now().toIso8601String(),
      });
      Logger.info('Achievement unlock logged: $achievementTitle');
    } catch (e) {
      Logger.error('Failed to log achievement unlock: $e');
    }
  }

  /// Track app performance
  Future<void> logPerformance(String metric, int value, {String? unit}) async {
    if (!_isInitialized) return;

    try {
      _events.add({
        'type': 'performance_metric',
        'metric_name': metric,
        'value': value,
        'unit': unit,
        'timestamp': DateTime.now().toIso8601String(),
      });
      Logger.info('Performance metric logged: $metric = $value');
    } catch (e) {
      Logger.error('Failed to log performance metric: $e');
    }
  }

  /// Set user properties
  Future<void> setUserProperties({
    String? userId,
    String? userLevel,
    String? preferredLanguage,
    bool? isPremium,
  }) async {
    if (!_isInitialized) return;

    try {
      if (userId != null) {
        _analyticsData['user_id'] = userId;
      }

      if (userLevel != null) {
        _analyticsData['user_level'] = userLevel;
      }

      if (preferredLanguage != null) {
        _analyticsData['preferred_language'] = preferredLanguage;
      }

      if (isPremium != null) {
        _analyticsData['is_premium'] = isPremium;
      }

      Logger.info('User properties set');
    } catch (e) {
      Logger.error('Failed to set user properties: $e');
    }
  }

  /// Log custom event
  Future<void> logCustomEvent(
    String eventName,
    Map<String, dynamic> parameters,
  ) async {
    if (!_isInitialized) return;

    try {
      _events.add({
        'type': 'custom_event',
        'event_name': eventName,
        'parameters': parameters,
        'timestamp': DateTime.now().toIso8601String(),
      });
      Logger.info('Custom event logged: $eventName');
    } catch (e) {
      Logger.error('Failed to log custom event: $e');
    }
  }

  /// Record non-fatal error
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    if (!_isInitialized) return;

    try {
      _events.add({
        'type': 'error',
        'error': error.toString(),
        'stack_trace': stackTrace?.toString(),
        'reason': reason,
        'fatal': fatal,
        'timestamp': DateTime.now().toIso8601String(),
      });
      Logger.info('Error recorded: $error');
    } catch (e) {
      Logger.error('Failed to record error: $e');
    }
  }

  /// Set custom key-value pairs for crash reports
  Future<void> setCustomKey(String key, dynamic value) async {
    if (!_isInitialized) return;

    try {
      _analyticsData[key] = value;
      Logger.info('Custom key set: $key = $value');
    } catch (e) {
      Logger.error('Failed to set custom key: $e');
    }
  }

  /// Log breadcrumb for debugging
  Future<void> logBreadcrumb(String message) async {
    if (!_isInitialized) return;

    try {
      _events.add({
        'type': 'breadcrumb',
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      });
      Logger.info('Breadcrumb logged: $message');
    } catch (e) {
      Logger.error('Failed to log breadcrumb: $e');
    }
  }

  /// Get analytics data for debugging
  Map<String, dynamic> get analyticsData => Map.from(_analyticsData);

  /// Get events for debugging
  List<Map<String, dynamic>> get events => List.from(_events);

  /// Track XP earned
  Future<void> logXPEarned(int xp, String source) async {
    if (!_isInitialized) return;

    try {
      _events.add({
        'type': 'xp_earned',
        'xp_amount': xp,
        'source': source,
        'timestamp': DateTime.now().toIso8601String(),
      });
      Logger.info('XP earned logged: $xp from $source');
    } catch (e) {
      Logger.error('Failed to log XP earned: $e');
    }
  }

  /// Track app opened
  Future<void> logAppOpened() async {
    if (!_isInitialized) return;

    try {
      _events.add({
        'type': 'app_opened',
        'timestamp': DateTime.now().toIso8601String(),
      });
      Logger.info('App opened logged');
    } catch (e) {
      Logger.error('Failed to log app opened: $e');
    }
  }

  /// Check if analytics is initialized
  bool get isInitialized => _isInitialized;

  /// Clear all stored data
  void clearData() {
    _analyticsData.clear();
    _events.clear();
    Logger.info('Analytics data cleared');
  }
}
