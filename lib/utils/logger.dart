import 'dart:developer' as developer;

/// Centralized logging utility for the Learn C++ app
///
/// This logger provides a consistent logging interface across the application
/// with different log levels and proper formatting.
class Logger {
  static const String _appName = 'LearnCpp';

  /// Log an info message
  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: _appName,
      level: 800, // INFO level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a warning message
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: _appName,
      level: 900, // WARNING level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log an error message
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: _appName,
      level: 1000, // ERROR level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a debug message
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: _appName,
      level: 700, // DEBUG level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a verbose message
  static void verbose(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: _appName,
      level: 500, // VERBOSE level
      error: error,
      stackTrace: stackTrace,
    );
  }
}
