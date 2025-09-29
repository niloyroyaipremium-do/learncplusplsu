import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

/// Crash Reporting Service
/// 
/// Handles crash reporting, error tracking, and analytics
/// without external dependencies for better privacy
class CrashReportingService {
  static final CrashReportingService _instance = CrashReportingService._internal();
  factory CrashReportingService() => _instance;
  CrashReportingService._internal();

  bool _isInitialized = false;
  final List<Map<String, dynamic>> _crashReports = [];
  final List<Map<String, dynamic>> _analyticsEvents = [];
  Timer? _reportTimer;

  /// Initialize crash reporting service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set up error handling
      FlutterError.onError = _handleFlutterError;
      
      // Set up isolate error handling
      PlatformDispatcher.instance.onError = _handlePlatformError;

      // Start periodic report sending
      _startPeriodicReporting();

      _isInitialized = true;
      Logger.info('Crash reporting service initialized');
    } catch (e) {
      Logger.error('Failed to initialize crash reporting service', e);
    }
  }

  /// Handle Flutter framework errors
  void _handleFlutterError(FlutterErrorDetails details) {
    final error = {
      'type': 'flutter_error',
      'error': details.exception.toString(),
      'stackTrace': details.stack?.toString(),
      'library': details.library,
      'context': details.context?.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      'platform': Platform.operatingSystem,
    };

    _recordCrash(error);
    Logger.error('Flutter error caught', details.exception, details.stack);
  }

  /// Handle platform errors
  bool _handlePlatformError(Object error, StackTrace stack) {
    final errorData = {
      'type': 'platform_error',
      'error': error.toString(),
      'stackTrace': stack.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      'platform': Platform.operatingSystem,
    };

    _recordCrash(errorData);
    Logger.error('Platform error caught', error, stack);
    return true;
  }

  /// Record a crash report
  void _recordCrash(Map<String, dynamic> crashData) {
    _crashReports.add(crashData);
    
    // Save to local storage
    _saveCrashReports();
    
    // Send immediately for critical errors
    if (crashData['type'] == 'platform_error') {
      _sendCrashReports();
    }
  }

  /// Record an analytics event
  void recordEvent(String eventName, {Map<String, dynamic>? parameters}) {
    final event = {
      'eventName': eventName,
      'parameters': parameters ?? {},
      'timestamp': DateTime.now().toIso8601String(),
      'platform': Platform.operatingSystem,
    };

    _analyticsEvents.add(event);
    Logger.info('Analytics event recorded: $eventName');
  }

  /// Record user action
  void recordUserAction(String action, {Map<String, dynamic>? context}) {
    recordEvent('user_action', parameters: {
      'action': action,
      'context': context ?? {},
    });
  }

  /// Record screen view
  void recordScreenView(String screenName, {Map<String, dynamic>? parameters}) {
    recordEvent('screen_view', parameters: {
      'screen_name': screenName,
      ...?parameters,
    });
  }

  /// Record code execution event
  void recordCodeExecution({
    required String code,
    required bool success,
    String? error,
    int? executionTime,
  }) {
    recordEvent('code_execution', parameters: {
      'code_length': code.length,
      'success': success,
      'error': error,
      'execution_time': executionTime,
    });
  }

  /// Record lesson completion
  void recordLessonCompletion(String lessonId, {int? timeSpent, int? attempts}) {
    recordEvent('lesson_completed', parameters: {
      'lesson_id': lessonId,
      'time_spent': timeSpent,
      'attempts': attempts,
    });
  }

  /// Record app performance metrics
  void recordPerformanceMetric(String metricName, dynamic value, {String? unit}) {
    recordEvent('performance_metric', parameters: {
      'metric_name': metricName,
      'value': value,
      'unit': unit,
    });
  }

  /// Start periodic reporting
  void _startPeriodicReporting() {
    _reportTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _sendCrashReports();
      _sendAnalyticsEvents();
    });
  }

  /// Save crash reports to local storage
  Future<void> _saveCrashReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsJson = _crashReports.map((report) => report.toString()).join('\n');
      await prefs.setString('crash_reports', reportsJson);
    } catch (e) {
      Logger.error('Failed to save crash reports', e);
    }
  }

  /// Load crash reports from local storage
  Future<void> _loadCrashReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsJson = prefs.getString('crash_reports');
      if (reportsJson != null && reportsJson.isNotEmpty) {
        // Parse and add to reports list
        // This is a simplified implementation
        Logger.info('Loaded crash reports from storage');
      }
    } catch (e) {
      Logger.error('Failed to load crash reports', e);
    }
  }

  /// Send crash reports (simulated)
  Future<void> _sendCrashReports() async {
    if (_crashReports.isEmpty) return;

    try {
      // In a real implementation, this would send to a backend service
      Logger.info('Sending ${_crashReports.length} crash reports');
      
      // Simulate sending
      await Future.delayed(const Duration(seconds: 1));
      
      // Clear sent reports
      _crashReports.clear();
      await _saveCrashReports();
      
      Logger.info('Crash reports sent successfully');
    } catch (e) {
      Logger.error('Failed to send crash reports', e);
    }
  }

  /// Send analytics events (simulated)
  Future<void> _sendAnalyticsEvents() async {
    if (_analyticsEvents.isEmpty) return;

    try {
      // In a real implementation, this would send to an analytics service
      Logger.info('Sending ${_analyticsEvents.length} analytics events');
      
      // Simulate sending
      await Future.delayed(const Duration(seconds: 1));
      
      // Clear sent events
      _analyticsEvents.clear();
      
      Logger.info('Analytics events sent successfully');
    } catch (e) {
      Logger.error('Failed to send analytics events', e);
    }
  }

  /// Get crash statistics
  Map<String, dynamic> getCrashStatistics() {
    final totalCrashes = _crashReports.length;
    final flutterErrors = _crashReports.where((r) => r['type'] == 'flutter_error').length;
    final platformErrors = _crashReports.where((r) => r['type'] == 'platform_error').length;

    return {
      'total_crashes': totalCrashes,
      'flutter_errors': flutterErrors,
      'platform_errors': platformErrors,
      'last_crash': _crashReports.isNotEmpty 
          ? _crashReports.last['timestamp'] 
          : null,
    };
  }

  /// Get analytics summary
  Map<String, dynamic> getAnalyticsSummary() {
    final totalEvents = _analyticsEvents.length;
    final eventTypes = <String, int>{};
    
    for (final event in _analyticsEvents) {
      final eventName = event['eventName'] as String;
      eventTypes[eventName] = (eventTypes[eventName] ?? 0) + 1;
    }

    return {
      'total_events': totalEvents,
      'event_types': eventTypes,
      'last_event': _analyticsEvents.isNotEmpty 
          ? _analyticsEvents.last['timestamp'] 
          : null,
    };
  }

  /// Force send all pending reports
  Future<void> sendPendingReports() async {
    await _sendCrashReports();
    await _sendAnalyticsEvents();
  }

  /// Clear all stored data
  Future<void> clearAllData() async {
    _crashReports.clear();
    _analyticsEvents.clear();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('crash_reports');
    } catch (e) {
      Logger.error('Failed to clear crash reports', e);
    }
  }

  /// Dispose resources
  void dispose() {
    _reportTimer?.cancel();
    _reportTimer = null;
  }
}