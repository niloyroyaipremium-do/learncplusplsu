/// Custom exceptions for the C++ Learning App
///
/// This file defines all custom exceptions used throughout the application
/// to provide better error handling and user feedback.
library;

/// Base exception class for all app-specific exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({required this.message, this.code, this.details});

  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown when network operations fail
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when data operations fail
class DataException extends AppException {
  const DataException({required super.message, super.code, super.details});

  @override
  String toString() => 'DataException: $message';
}

/// Exception thrown when code execution fails
class CodeExecutionException extends AppException {
  const CodeExecutionException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'CodeExecutionException: $message';
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Exception thrown when authentication fails
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Exception thrown when file operations fail
class FileException extends AppException {
  const FileException({required super.message, super.code, super.details});

  @override
  String toString() => 'FileException: $message';
}

/// Exception thrown when storage operations fail
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'StorageException: $message';
}

/// Exception thrown when lesson operations fail
class LessonException extends AppException {
  const LessonException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'LessonException: $message';
}

/// Exception thrown when user profile operations fail
class UserProfileException extends AppException {
  const UserProfileException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'UserProfileException: $message';
}

/// Exception thrown when configuration is invalid
class ConfigurationException extends AppException {
  const ConfigurationException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ConfigurationException: $message';
}

/// Exception thrown when timeout occurs
class TimeoutException extends AppException {
  const TimeoutException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'TimeoutException: $message';
}

/// Exception thrown when permission is denied
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'PermissionException: $message';
}

/// Exception thrown when cache operations fail
class CacheException extends AppException {
  final dynamic originalException;
  
  const CacheException({
    required super.message,
    super.code,
    super.details,
    this.originalException,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when student operations fail
class StudentException extends AppException {
  const StudentException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'StudentException: $message';
}
