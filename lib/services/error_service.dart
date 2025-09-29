import 'package:flutter/foundation.dart';
import '../utils/logger.dart';

enum ErrorType { network, database, authentication, validation, unknown }

class AppError {
  final String message;
  final String? code;
  final ErrorType type;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? metadata;

  const AppError({
    required this.message,
    this.code,
    required this.type,
    this.stackTrace,
    this.metadata,
  });

  @override
  String toString() {
    return 'AppError{message: $message, code: $code, type: $type}';
  }
}

class ErrorService {
  static final ErrorService _instance = ErrorService._internal();
  factory ErrorService() => _instance;
  ErrorService._internal();

  final List<AppError> _errors = [];
  final List<VoidCallback> _errorListeners = [];

  List<AppError> get errors => List.unmodifiable(_errors);
  bool get hasErrors => _errors.isNotEmpty;

  void addErrorListener(VoidCallback listener) {
    _errorListeners.add(listener);
  }

  void removeErrorListener(VoidCallback listener) {
    _errorListeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _errorListeners) {
      try {
        listener();
      } catch (e) {
        Logger.error('Error in error listener', e);
      }
    }
  }

  void reportError(
    String message, {
    String? code,
    ErrorType type = ErrorType.unknown,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
    bool showToUser = true,
  }) {
    final error = AppError(
      message: message,
      code: code,
      type: type,
      stackTrace: stackTrace,
      metadata: metadata,
    );

    _errors.add(error);

    // Log the error
    Logger.error('Error reported: $message', error, stackTrace);

    // In production, you might want to send this to a crash reporting service
    if (kReleaseMode) {
      _sendToCrashReporting(error);
    }

    _notifyListeners();
  }

  void reportException(
    Object exception, {
    String? message,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
    bool showToUser = true,
  }) {
    final errorMessage = message ?? exception.toString();
    final errorType = _getErrorTypeFromException(exception);

    reportError(
      errorMessage,
      type: errorType,
      stackTrace: stackTrace,
      metadata: metadata,
      showToUser: showToUser,
    );
  }

  ErrorType _getErrorTypeFromException(Object exception) {
    final exceptionString = exception.toString().toLowerCase();

    if (exceptionString.contains('network') ||
        exceptionString.contains('connection') ||
        exceptionString.contains('timeout')) {
      return ErrorType.network;
    }

    if (exceptionString.contains('database') ||
        exceptionString.contains('sqlite') ||
        exceptionString.contains('sqflite')) {
      return ErrorType.database;
    }

    if (exceptionString.contains('auth') ||
        exceptionString.contains('login') ||
        exceptionString.contains('permission')) {
      return ErrorType.authentication;
    }

    if (exceptionString.contains('validation') ||
        exceptionString.contains('invalid') ||
        exceptionString.contains('format')) {
      return ErrorType.validation;
    }

    return ErrorType.unknown;
  }

  void _sendToCrashReporting(AppError error) {
    // In a real app, you would send this to Firebase Crashlytics, Sentry, etc.
    // For now, we'll just log it
    Logger.error('Crash reporting: ${error.message}', error, error.stackTrace);
  }

  void clearErrors() {
    _errors.clear();
    _notifyListeners();
  }

  void clearErrorType(ErrorType type) {
    _errors.removeWhere((error) => error.type == type);
    _notifyListeners();
  }

  List<AppError> getErrorsByType(ErrorType type) {
    return _errors.where((error) => error.type == type).toList();
  }

  AppError? getLastError() {
    return _errors.isNotEmpty ? _errors.last : null;
  }

  // Helper methods for common error scenarios
  void reportNetworkError(String message, {Map<String, dynamic>? metadata}) {
    reportError(message, type: ErrorType.network, metadata: metadata);
  }

  void reportDatabaseError(String message, {Map<String, dynamic>? metadata}) {
    reportError(message, type: ErrorType.database, metadata: metadata);
  }

  void reportAuthError(String message, {Map<String, dynamic>? metadata}) {
    reportError(message, type: ErrorType.authentication, metadata: metadata);
  }

  void reportValidationError(String message, {Map<String, dynamic>? metadata}) {
    reportError(message, type: ErrorType.validation, metadata: metadata);
  }
}
