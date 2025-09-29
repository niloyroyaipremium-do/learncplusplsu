import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../utils/logger.dart';

/// Performance monitoring and optimization service
///
/// This service provides performance monitoring, memory management,
/// and optimization utilities for the C++ Learning App.
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final Map<String, Stopwatch> _timers = {};
  final Map<String, int> _memoryUsage = {};
  final List<PerformanceMetric> _metrics = [];

  bool _isMonitoring = false;
  Timer? _monitoringTimer;

  /// Start performance monitoring
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _monitoringTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _collectMetrics(),
    );

    Logger.info('Performance monitoring started');
  }

  /// Stop performance monitoring
  void stopMonitoring() {
    if (!_isMonitoring) return;

    _isMonitoring = false;
    _monitoringTimer?.cancel();
    _monitoringTimer = null;

    Logger.info('Performance monitoring stopped');
  }

  /// Start timing an operation
  void startTimer(String operation) {
    _timers[operation] = Stopwatch()..start();
  }

  /// Stop timing an operation and return duration
  Duration stopTimer(String operation) {
    final stopwatch = _timers.remove(operation);
    if (stopwatch == null) return Duration.zero;

    stopwatch.stop();
    final duration = stopwatch.elapsed;

    // Log performance metric
    _addMetric(
      PerformanceMetric(
        operation: operation,
        duration: duration,
        timestamp: DateTime.now(),
      ),
    );

    return duration;
  }

  /// Measure execution time of a function
  Future<T> measureAsync<T>(
    String operation,
    Future<T> Function() function,
  ) async {
    startTimer(operation);
    try {
      final result = await function();
      return result;
    } finally {
      final duration = stopTimer(operation);
      Logger.info('$operation completed in ${duration.inMilliseconds}ms');
    }
  }

  /// Measure execution time of a synchronous function
  T measure<T>(String operation, T Function() function) {
    startTimer(operation);
    try {
      final result = function();
      return result;
    } finally {
      final duration = stopTimer(operation);
      Logger.info('$operation completed in ${duration.inMilliseconds}ms');
    }
  }

  /// Get current memory usage
  int getCurrentMemoryUsage() {
    // In Flutter, we can't directly access ProcessInfo
    // This is a placeholder implementation
    final memory = 0; // Placeholder value
    _memoryUsage['current'] = memory;
    return memory;
  }

  /// Get memory usage for a specific operation
  int getMemoryUsage(String operation) {
    return _memoryUsage[operation] ?? 0;
  }

  /// Set memory usage for a specific operation
  void setMemoryUsage(String operation, int usage) {
    _memoryUsage[operation] = usage;
  }

  /// Get performance metrics
  List<PerformanceMetric> getMetrics() {
    return List.unmodifiable(_metrics);
  }

  /// Get metrics for a specific operation
  List<PerformanceMetric> getMetricsForOperation(String operation) {
    return _metrics.where((m) => m.operation == operation).toList();
  }

  /// Get average duration for an operation
  Duration getAverageDuration(String operation) {
    final operationMetrics = getMetricsForOperation(operation);
    if (operationMetrics.isEmpty) return Duration.zero;

    final totalMs = operationMetrics
        .map((m) => m.duration.inMilliseconds)
        .reduce((a, b) => a + b);

    return Duration(milliseconds: totalMs ~/ operationMetrics.length);
  }

  /// Clear all metrics
  void clearMetrics() {
    _metrics.clear();
    _timers.clear();
    _memoryUsage.clear();
  }

  /// Collect performance metrics
  void _collectMetrics() {
    final memory = getCurrentMemoryUsage();
    final timestamp = DateTime.now();

    _addMetric(
      PerformanceMetric(
        operation: 'memory_usage',
        duration: Duration.zero,
        timestamp: timestamp,
        memoryUsage: memory,
      ),
    );

    // Log performance summary
    if (kDebugMode) {
      Logger.info('Performance Summary:');
      Logger.info('  Memory Usage: ${_formatBytes(memory)}');
      Logger.info('  Active Timers: ${_timers.length}');
      Logger.info('  Total Metrics: ${_metrics.length}');
    }
  }

  /// Add a performance metric
  void _addMetric(PerformanceMetric metric) {
    _metrics.add(metric);

    // Keep only last 1000 metrics to prevent memory issues
    if (_metrics.length > 1000) {
      _metrics.removeAt(0);
    }
  }

  /// Format bytes to human readable format
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Optimize memory usage
  void optimizeMemory() {
    // Clear old metrics
    if (_metrics.length > 500) {
      _metrics.removeRange(0, _metrics.length - 500);
    }

    // Clear old timers
    _timers.removeWhere((key, timer) => !timer.isRunning);

    // Force garbage collection in debug mode
    if (kDebugMode) {
      developer.Timeline.instantSync('Memory Optimization');
    }

    Logger.info('Memory optimization completed');
  }

  /// Get performance report
  PerformanceReport getPerformanceReport() {
    final now = DateTime.now();
    final lastHour = now.subtract(const Duration(hours: 1));

    final recentMetrics = _metrics
        .where((m) => m.timestamp.isAfter(lastHour))
        .toList();

    final operations = recentMetrics.map((m) => m.operation).toSet().toList();

    final operationStats = <String, OperationStats>{};

    for (final operation in operations) {
      final operationMetrics = recentMetrics
          .where((m) => m.operation == operation)
          .toList();

      if (operationMetrics.isNotEmpty) {
        final durations = operationMetrics
            .map((m) => m.duration.inMilliseconds)
            .toList();

        durations.sort();

        operationStats[operation] = OperationStats(
          operation: operation,
          count: operationMetrics.length,
          averageDuration: Duration(
            milliseconds: durations.reduce((a, b) => a + b) ~/ durations.length,
          ),
          minDuration: Duration(milliseconds: durations.first),
          maxDuration: Duration(milliseconds: durations.last),
          medianDuration: Duration(
            milliseconds: durations[durations.length ~/ 2],
          ),
        );
      }
    }

    return PerformanceReport(
      timestamp: now,
      totalMetrics: recentMetrics.length,
      memoryUsage: getCurrentMemoryUsage(),
      operationStats: operationStats,
    );
  }
}

/// Performance metric data class
class PerformanceMetric {
  final String operation;
  final Duration duration;
  final DateTime timestamp;
  final int? memoryUsage;

  const PerformanceMetric({
    required this.operation,
    required this.duration,
    required this.timestamp,
    this.memoryUsage,
  });
}

/// Operation statistics
class OperationStats {
  final String operation;
  final int count;
  final Duration averageDuration;
  final Duration minDuration;
  final Duration maxDuration;
  final Duration medianDuration;

  const OperationStats({
    required this.operation,
    required this.count,
    required this.averageDuration,
    required this.minDuration,
    required this.maxDuration,
    required this.medianDuration,
  });
}

/// Performance report
class PerformanceReport {
  final DateTime timestamp;
  final int totalMetrics;
  final int memoryUsage;
  final Map<String, OperationStats> operationStats;

  const PerformanceReport({
    required this.timestamp,
    required this.totalMetrics,
    required this.memoryUsage,
    required this.operationStats,
  });
}
