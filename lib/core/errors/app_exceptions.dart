/// Base class for all application-specific exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Data operation exceptions
class DataException extends AppException {
  const DataException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Code execution exceptions
class CodeExecutionException extends AppException {
  const CodeExecutionException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Authentication exceptions
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
    super.details,
  });
}

/// File operation exceptions
class FileException extends AppException {
  const FileException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Storage exceptions
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Lesson-related exceptions
class LessonException extends AppException {
  const LessonException({
    required super.message,
    super.code,
    super.details,
  });
}

/// User profile exceptions
class UserProfileException extends AppException {
  const UserProfileException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Configuration exceptions
class ConfigurationException extends AppException {
  const ConfigurationException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Timeout exceptions
class TimeoutException extends AppException {
  const TimeoutException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Permission exceptions
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code,
    super.details,
  });
}