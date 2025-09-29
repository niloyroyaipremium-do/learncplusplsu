import 'package:flutter/services.dart';
import 'app_exceptions.dart';
import '../../utils/logger.dart';

/// Centralized error handling system for the C++ Learning App
///
/// This class provides a unified way to handle errors throughout the application,
/// including logging, user notifications, and error recovery strategies.
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  /// Handle any exception and provide appropriate user feedback
  static Future<void> handleError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
    bool showUserMessage = true,
    VoidCallback? onRetry,
  }) async {
    try {
      // Log the error
      _logError(error, stackTrace, context);

      // Determine error type and handle accordingly
      if (error is AppException) {
        await _handleAppException(error, showUserMessage, onRetry);
      } else if (error is PlatformException) {
        await _handlePlatformException(error, showUserMessage, onRetry);
      } else {
        await _handleGenericError(error, showUserMessage, onRetry);
      }
    } catch (e) {
      // Fallback error handling
      Logger.error('Error in error handler: $e');
    }
  }

  /// Log error details
  static void _logError(
    dynamic error,
    StackTrace? stackTrace,
    String? context,
  ) {
    final errorMessage =
        'Error${context != null ? ' in $context' : ''}: $error';

    if (error is AppException) {
      Logger.error(
        '$errorMessage\nCode: ${error.code}\nDetails: ${error.details}',
      );
    } else {
      Logger.error(errorMessage);
    }

    if (stackTrace != null) {
      Logger.error('Stack trace: $stackTrace');
    }
  }

  /// Handle app-specific exceptions
  static Future<void> _handleAppException(
    AppException exception,
    bool showUserMessage,
    VoidCallback? onRetry,
  ) async {
    if (!showUserMessage) return;

    String userMessage;
    String? actionText;

    switch (exception.runtimeType) {
      case NetworkException _:
        userMessage =
            'Network connection failed. Please check your internet connection.';
        actionText = 'Retry';
        break;
      case DataException _:
        userMessage = 'Data operation failed. Please try again.';
        actionText = 'Retry';
        break;
      case CodeExecutionException _:
        userMessage = 'Code execution failed: ${exception.message}';
        actionText = 'Check Code';
        break;
      case ValidationException _:
        userMessage = 'Validation error: ${exception.message}';
        actionText = 'Fix';
        break;
      case AuthenticationException _:
        userMessage = 'Authentication failed. Please log in again.';
        actionText = 'Login';
        break;
      case FileException _:
        userMessage = 'File operation failed. Please try again.';
        actionText = 'Retry';
        break;
      case StorageException _:
        userMessage = 'Storage operation failed. Please try again.';
        actionText = 'Retry';
        break;
      case LessonException _:
        userMessage = 'Lesson operation failed: ${exception.message}';
        actionText = 'Retry';
        break;
      case UserProfileException _:
        userMessage = 'Profile operation failed: ${exception.message}';
        actionText = 'Retry';
        break;
      case ConfigurationException _:
        userMessage = 'Configuration error: ${exception.message}';
        actionText = 'Settings';
        break;
      case TimeoutException _:
        userMessage = 'Operation timed out. Please try again.';
        actionText = 'Retry';
        break;
      case PermissionException _:
        userMessage = 'Permission denied: ${exception.message}';
        actionText = 'Settings';
        break;
      default:
        userMessage = 'An unexpected error occurred: ${exception.message}';
        actionText = 'Retry';
    }

    await _showErrorDialog(userMessage, actionText, onRetry);
  }

  /// Handle platform-specific exceptions
  static Future<void> _handlePlatformException(
    PlatformException exception,
    bool showUserMessage,
    VoidCallback? onRetry,
  ) async {
    if (!showUserMessage) return;

    String userMessage;
    String? actionText;

    switch (exception.code) {
      case 'network_error':
        userMessage =
            'Network connection failed. Please check your internet connection.';
        actionText = 'Retry';
        break;
      case 'permission_denied':
        userMessage =
            'Permission denied. Please grant the required permissions.';
        actionText = 'Settings';
        break;
      case 'file_not_found':
        userMessage = 'File not found. Please check the file path.';
        actionText = 'Browse';
        break;
      case 'storage_full':
        userMessage = 'Storage is full. Please free up some space.';
        actionText = 'Storage';
        break;
      case 'invalid_argument':
        userMessage = 'Invalid input. Please check your data.';
        actionText = 'Fix';
        break;
      default:
        userMessage = 'Platform error: ${exception.message ?? 'Unknown error'}';
        actionText = 'Retry';
    }

    await _showErrorDialog(userMessage, actionText, onRetry);
  }

  /// Handle generic errors
  static Future<void> _handleGenericError(
    dynamic error,
    bool showUserMessage,
    VoidCallback? onRetry,
  ) async {
    if (!showUserMessage) return;

    const userMessage = 'An unexpected error occurred. Please try again.';
    const actionText = 'Retry';

    await _showErrorDialog(userMessage, actionText, onRetry);
  }

  /// Show error dialog to user
  static Future<void> _showErrorDialog(
    String message,
    String? actionText,
    VoidCallback? onRetry,
  ) async {
    // This would typically use a global navigator or context
    // For now, we'll just log the message
    Logger.error('User error message: $message');

    // In a real implementation, you would show a dialog here
    // using the current context or a global navigator
  }

  /// Handle code execution errors specifically
  static Future<void> handleCodeExecutionError(
    String error,
    String? code,
    dynamic details,
  ) async {
    final exception = CodeExecutionException(
      message: error,
      code: code,
      details: details,
    );

    await handleError(exception, null, context: 'Code Execution');
  }

  /// Handle network errors specifically
  static Future<void> handleNetworkError(
    String message, {
    String? code,
    dynamic details,
    VoidCallback? onRetry,
  }) async {
    final exception = NetworkException(
      message: message,
      code: code,
      details: details,
    );

    await handleError(exception, null, context: 'Network', onRetry: onRetry);
  }

  /// Handle data errors specifically
  static Future<void> handleDataError(
    String message, {
    String? code,
    dynamic details,
    VoidCallback? onRetry,
  }) async {
    final exception = DataException(
      message: message,
      code: code,
      details: details,
    );

    await handleError(exception, null, context: 'Data', onRetry: onRetry);
  }

  /// Handle validation errors specifically
  static Future<void> handleValidationError(
    String message, {
    String? code,
    dynamic details,
  }) async {
    final exception = ValidationException(
      message: message,
      code: code,
      details: details,
    );

    await handleError(exception, null, context: 'Validation');
  }

  /// Handle storage errors specifically
  static Future<void> handleStorageError(
    String message, {
    String? code,
    dynamic details,
    VoidCallback? onRetry,
  }) async {
    final exception = StorageException(
      message: message,
      code: code,
      details: details,
    );

    await handleError(exception, null, context: 'Storage', onRetry: onRetry);
  }

  /// Get user-friendly error message
  static String getUserFriendlyMessage(dynamic error) {
    if (error is AppException) {
      switch (error.runtimeType) {
        case NetworkException _:
          return 'Please check your internet connection and try again.';
        case DataException _:
          return 'There was a problem with your data. Please try again.';
        case CodeExecutionException _:
          return 'There was an error running your code. Please check the syntax.';
        case ValidationException _:
          return 'Please check your input and try again.';
        case AuthenticationException _:
          return 'Please log in again to continue.';
        case FileException _:
          return 'There was a problem with the file. Please try again.';
        case StorageException _:
          return 'There was a problem saving your data. Please try again.';
        case LessonException _:
          return 'There was a problem with the lesson. Please try again.';
        case UserProfileException _:
          return 'There was a problem with your profile. Please try again.';
        case ConfigurationException _:
          return 'There was a configuration problem. Please check your settings.';
        case TimeoutException _:
          return 'The operation took too long. Please try again.';
        case PermissionException _:
          return 'Please grant the required permissions to continue.';
        default:
          return 'An unexpected error occurred. Please try again.';
      }
    } else if (error is PlatformException) {
      switch (error.code) {
        case 'network_error':
          return 'Please check your internet connection and try again.';
        case 'permission_denied':
          return 'Please grant the required permissions to continue.';
        case 'file_not_found':
          return 'The requested file was not found.';
        case 'storage_full':
          return 'Your device storage is full. Please free up some space.';
        case 'invalid_argument':
          return 'Please check your input and try again.';
        default:
          return 'A system error occurred. Please try again.';
      }
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Check if error is recoverable
  static bool isRecoverable(dynamic error) {
    if (error is AppException) {
      switch (error.runtimeType) {
        case NetworkException _:
        case DataException _:
        case TimeoutException _:
        case StorageException _:
        case LessonException _:
        case UserProfileException _:
          return true;
        case ValidationException _:
        case ConfigurationException _:
        case PermissionException _:
          return false;
        default:
          return true;
      }
    } else if (error is PlatformException) {
      switch (error.code) {
        case 'network_error':
        case 'timeout':
          return true;
        case 'permission_denied':
        case 'file_not_found':
        case 'storage_full':
        case 'invalid_argument':
          return false;
        default:
          return true;
      }
    }
    return true;
  }
}
