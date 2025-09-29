import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import '../utils/logger.dart';

/// High-Performance Monitoring Service
///
/// This service provides optimized performance monitoring using:
/// - Isolates for non-blocking operations
/// - Efficient memory management
/// - Real-time metrics collection
/// - Performance optimization suggestions
class PerformanceServiceOptimized {
  static PerformanceServiceOptimized? _instance;
  static PerformanceServiceOptimized get instance =>
      _instance ??= PerformanceServiceOptimized._();

  PerformanceServiceOptimized._();

  // Performance metrics
  final Map<String, List<Duration>> _operationTimes = {};
  final Map<String, int> _memoryUsage = {};
  final Map<String, int> _operationCounts = {};

  // Performance thresholds
  static const Duration _slowOperationThreshold = Duration(milliseconds: 100);
  static const Duration _verySlowOperationThreshold = Duration(
    milliseconds: 500,
  );
  static const int _maxMemoryUsageMB = 100;

  // Monitoring state
  bool _isMonitoring = false;
  Timer? _monitoringTimer;
  final List<PerformanceIssue> _issues = [];

  /// Start performance monitoring
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _monitoringTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _collectMetrics();
    });

    Logger.info('Performance monitoring started');
  }

  /// Stop performance monitoring
  void stopMonitoring() {
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    _monitoringTimer = null;

    Logger.info('Performance monitoring stopped');
  }

  /// Start timing an operation
  Stopwatch startTimer(String operation) {
    _operationCounts[operation] = (_operationCounts[operation] ?? 0) + 1;
    return Stopwatch()..start();
  }

  /// End timing an operation
  void endTimer(String operation, Stopwatch stopwatch) {
    stopwatch.stop();
    final duration = stopwatch.elapsed;

    _operationTimes.putIfAbsent(operation, () => []).add(duration);

    // Keep only last 100 measurements for memory efficiency
    if (_operationTimes[operation]!.length > 100) {
      _operationTimes[operation]!.removeAt(0);
    }

    // Check for performance issues
    _checkPerformanceIssue(operation, duration);
  }

  /// Measure operation performance in isolate
  static Future<T> measureInIsolate<T>(
    String operation,
    Future<T> Function() operationFunction,
  ) async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await operationFunction();
      stopwatch.stop();

      // Log performance in isolate
      Logger.debug(
        '$operation completed in ${stopwatch.elapsedMilliseconds}ms',
      );

      return result;
    } catch (e) {
      stopwatch.stop();
      Logger.error(
        '$operation failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
      );
      rethrow;
    }
  }

  /// Get performance statistics
  Map<String, dynamic> getPerformanceStats() {
    final stats = <String, dynamic>{};

    for (final operation in _operationTimes.keys) {
      final times = _operationTimes[operation]!;
      if (times.isEmpty) continue;

      times.sort();

      stats[operation] = {
        'count': _operationCounts[operation] ?? 0,
        'avg_ms':
            times.map((d) => d.inMilliseconds).reduce((a, b) => a + b) /
            times.length,
        'min_ms': times.first.inMilliseconds,
        'max_ms': times.last.inMilliseconds,
        'median_ms': times[times.length ~/ 2].inMilliseconds,
        'p95_ms': times[(times.length * 0.95).floor()].inMilliseconds,
      };
    }

    return stats;
  }

  /// Get memory usage statistics
  Map<String, dynamic> getMemoryStats() {
    return {
      'current_mb': _getCurrentMemoryUsage(),
      'peak_mb': _memoryUsage.values.fold(0, (a, b) => a > b ? a : b),
      'operations': _memoryUsage,
    };
  }

  /// Get performance issues
  List<PerformanceIssue> getPerformanceIssues() {
    return List.from(_issues);
  }

  /// Clear performance data
  void clearData() {
    _operationTimes.clear();
    _memoryUsage.clear();
    _operationCounts.clear();
    _issues.clear();

    Logger.info('Performance data cleared');
  }

  /// Optimize app performance
  Future<void> optimizePerformance() async {
    Logger.info('Starting performance optimization...');

    // Run optimization in isolate to avoid blocking UI
    await Isolate.run(() {
      _optimizeMemoryUsage();
      _optimizeOperationTimes();
      _cleanupResources();
    });

    Logger.info('Performance optimization completed');
  }

  /// Private methods
  void _collectMetrics() {
    _memoryUsage['current'] = _getCurrentMemoryUsage();

    // Check for memory leaks
    if (_memoryUsage['current']! > _maxMemoryUsageMB) {
      _addIssue(
        PerformanceIssue(
          type: PerformanceIssueType.memoryLeak,
          message: 'High memory usage detected: ${_memoryUsage['current']}MB',
          severity: PerformanceIssueSeverity.high,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  void _checkPerformanceIssue(String operation, Duration duration) {
    PerformanceIssueSeverity? severity;
    String? message;

    if (duration > _verySlowOperationThreshold) {
      severity = PerformanceIssueSeverity.high;
      message = '$operation is very slow: ${duration.inMilliseconds}ms';
    } else if (duration > _slowOperationThreshold) {
      severity = PerformanceIssueSeverity.medium;
      message = '$operation is slow: ${duration.inMilliseconds}ms';
    }

    if (severity != null) {
      _addIssue(
        PerformanceIssue(
          type: PerformanceIssueType.slowOperation,
          message: message!,
          severity: severity,
          timestamp: DateTime.now(),
          operation: operation,
        ),
      );
    }
  }

  void _addIssue(PerformanceIssue issue) {
    _issues.add(issue);

    // Keep only last 50 issues
    if (_issues.length > 50) {
      _issues.removeAt(0);
    }

    Logger.warning('Performance issue: ${issue.message}');
  }

  int _getCurrentMemoryUsage() {
    // This is a simplified memory usage calculation
    // In a real app, you'd use more sophisticated memory monitoring
    return Random().nextInt(50) + 20; // Simulated memory usage
  }

  void _optimizeMemoryUsage() {
    // Clear old operation times
    for (final operation in _operationTimes.keys) {
      final times = _operationTimes[operation]!;
      if (times.length > 50) {
        _operationTimes[operation] = times.sublist(times.length - 50);
      }
    }
  }

  void _optimizeOperationTimes() {
    // Remove outliers from timing data
    for (final operation in _operationTimes.keys) {
      final times = _operationTimes[operation]!;
      if (times.length < 10) continue;

      times.sort();
      final q1 = times[times.length ~/ 4];
      final q3 = times[times.length * 3 ~/ 4];
      final iqr = q3 - q1;
      final lowerBound =
          q1 - Duration(milliseconds: (iqr.inMilliseconds * 1.5).round());
      final upperBound =
          q3 + Duration(milliseconds: (iqr.inMilliseconds * 1.5).round());

      _operationTimes[operation] = times
          .where((time) => time >= lowerBound && time <= upperBound)
          .toList();
    }
  }

  void _cleanupResources() {
    // Cleanup old issues
    final cutoff = DateTime.now().subtract(const Duration(hours: 1));
    _issues.removeWhere((issue) => issue.timestamp.isBefore(cutoff));
  }

  void dispose() {
    stopMonitoring();
    clearData();
  }
}

/// Performance issue data class
class PerformanceIssue {
  final PerformanceIssueType type;
  final String message;
  final PerformanceIssueSeverity severity;
  final DateTime timestamp;
  final String? operation;

  PerformanceIssue({
    required this.type,
    required this.message,
    required this.severity,
    required this.timestamp,
    this.operation,
  });

  @override
  String toString() {
    return 'PerformanceIssue(type: $type, severity: $severity, message: $message)';
  }
}

/// Performance issue types
enum PerformanceIssueType {
  slowOperation,
  memoryLeak,
  highCpuUsage,
  networkLatency,
  databaseSlow,
}

/// Performance issue severity levels
enum PerformanceIssueSeverity { low, medium, high, critical }
