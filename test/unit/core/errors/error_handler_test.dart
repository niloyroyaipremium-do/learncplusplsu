import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

// --- 1. Custom Exception Classes (AppExceptions) ---

/// A base class for all custom exceptions in the application.
class AppException implements Exception {
  /// A user-friendly message describing the error.
  final String message;

  /// An optional error code for specific identification.
  final String? code;

  /// Optional additional details about the error.
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() {
    final codePart = code != null ? ' (Code: $code)' : '';
    return '$runtimeType: $message$codePart';
  }
}

/// Exception for network-related issues (e.g., no internet, DNS failure).
class NetworkException extends AppException {
  const NetworkException({required super.message, super.code, super.details});
}

/// Exception for data processing errors (e.g., parsing JSON, database issues).
class DataException extends AppException {
  const DataException({required super.message, super.code, super.details});
}

/// Exception for errors during code compilation or execution.
class CodeExecutionException extends AppException {
  const CodeExecutionException({required super.message, super.code, super.details});
}

/// Exception for input validation failures.
class ValidationException extends AppException {
  const ValidationException({required super.message, super.code, super.details});
}

/// Exception for local storage errors (e.g., reading/writing to a file).
class StorageException extends AppException {
  const StorageException({required super.message, super.code, super.details});
}

/// Exception for configuration-related problems.
class ConfigurationException extends AppException {
  const ConfigurationException({required super.message, super.code, super.details});
}

/// Exception for permission-related errors (e.g., camera, location access denied).
class PermissionException extends AppException {
  const PermissionException({required super.message, super.code, super.details});
}

// --- 2. Error Handler Class ---

/// A centralized class for handling, logging, and reporting errors.
class ErrorHandler {
  /// Main error handling method.
  static Future<void> handleError(
    dynamic error, {
    String? context,
    bool showUserMessage = true,
    VoidCallback? onRetry,
  }) async {
    // In a real app, this would log the error and potentially show a UI message.
    debugPrint('ErrorHandler handled: $error ${context != null ? '[Context: $context]' : ''}');
  }

  /// Determines if an error is something the user might recover from (e.g., by retrying).
  static bool isRecoverable(dynamic error) {
    return error is NetworkException;
  }

  /// Generates a user-friendly message for a given error.
  static String getUserFriendlyMessage(dynamic error) {
    if (error is NetworkException) {
      return 'Please check your internet connection and try again.';
    }
    if (error is DataException) {
      return 'There was an issue processing data. Please try again.';
    }
    if (error is CodeExecutionException) {
      return 'There was a problem with the executed code. Please check the syntax.';
    }
    if (error is ValidationException) {
      return 'Invalid input provided. Please check your entries and try again.';
    }
    return 'An unexpected error occurred. Please try again later.';
  }

  /// Specific handler for code execution errors.
  static Future<void> handleCodeExecutionError(String message, {String? code, dynamic details}) async {
    await handleError(CodeExecutionException(message: message, code: code, details: details));
  }

  /// Specific handler for network errors.
  static Future<void> handleNetworkError(String message, {String? code, dynamic details}) async {
    await handleError(NetworkException(message: message, code: code, details: details));
  }

  /// Specific handler for data errors.
  static Future<void> handleDataError(String message, {String? code, dynamic details}) async {
    await handleError(DataException(message: message, code: code, details: details));
  }

  /// Specific handler for validation errors.
  static Future<void> handleValidationError(String message, {String? code, dynamic details}) async {
    await handleError(ValidationException(message: message, code: code, details: details));
  }

  /// Specific handler for storage errors.
  static Future<void> handleStorageError(String message, {String? code, dynamic details}) async {
    await handleError(StorageException(message: message, code: code, details: details));
  }
}

// --- 3. Unit Tests ---

void main() {
  group('ErrorHandler', () {
    group('AppException Handling', () {
      test('should handle NetworkException correctly', () async {
        const exception = NetworkException(
          message: 'Network connection failed',
          code: 'network_error',
        );

        await ErrorHandler.handleError(exception);

        // Verify the properties of the exception object itself.
        expect(exception.message, equals('Network connection failed'));
        expect(exception.code, equals('network_error'));
      });

      test('should handle DataException correctly', () async {
        const exception = DataException(
          message: 'Data operation failed',
          code: 'data_error',
        );

        await ErrorHandler.handleError(exception);

        expect(exception.message, equals('Data operation failed'));
        expect(exception.code, equals('data_error'));
      });

      test('should handle CodeExecutionException correctly', () async {
        const exception = CodeExecutionException(
          message: 'Code execution failed',
          code: 'execution_error',
        );

        await ErrorHandler.handleError(exception);

        expect(exception.message, equals('Code execution failed'));
        expect(exception.code, equals('execution_error'));
      });

      test('should handle ValidationException correctly', () async {
        const exception = ValidationException(
          message: 'Invalid input provided',
          code: 'validation_error',
        );

        await ErrorHandler.handleError(exception);

        expect(exception.message, equals('Invalid input provided'));
        expect(exception.code, equals('validation_error'));
      });

      test('should handle StorageException correctly', () async {
        const exception = StorageException(
          message: 'Storage operation failed',
          code: 'storage_error',
        );

        await ErrorHandler.handleError(exception);

        expect(exception.message, equals('Storage operation failed'));
        expect(exception.code, equals('storage_error'));
      });
    });

    group('Error Recovery', () {
      test('should identify recoverable errors', () {
        const networkError = NetworkException(
          message: 'Network connection failed',
        );
        const validationError = ValidationException(message: 'Invalid input');

        expect(ErrorHandler.isRecoverable(networkError), isTrue);
        expect(ErrorHandler.isRecoverable(validationError), isFalse);
      });

      test('should identify non-recoverable errors', () {
        const configError = ConfigurationException(
          message: 'Invalid configuration',
        );
        const permissionError = PermissionException(
          message: 'Permission denied',
        );

        expect(ErrorHandler.isRecoverable(configError), isFalse);
        expect(ErrorHandler.isRecoverable(permissionError), isFalse);
      });
    });

    group('User-Friendly Messages', () {
      test('should provide user-friendly message for NetworkException', () {
        const exception = NetworkException(
          message: 'Network connection failed',
        );

        final message = ErrorHandler.getUserFriendlyMessage(exception);

        expect(message, contains('internet connection'));
        expect(message, contains('try again'));
      });

      test('should provide user-friendly message for DataException', () {
        const exception = DataException(message: 'Data operation failed');

        final message = ErrorHandler.getUserFriendlyMessage(exception);

        expect(message, contains('data'));
        expect(message, contains('try again'));
      });

      test(
        'should provide user-friendly message for CodeExecutionException',
        () {
          const exception = CodeExecutionException(
            message: 'Code execution failed',
          );

          final message = ErrorHandler.getUserFriendlyMessage(exception);

          expect(message, contains('code'));
          expect(message, contains('syntax'));
        },
      );

      test('should provide user-friendly message for ValidationException', () {
        const exception = ValidationException(message: 'Invalid input');

        final message = ErrorHandler.getUserFriendlyMessage(exception);

        expect(message, contains('input'));
        expect(message, contains('try again'));
      });

      test('should provide user-friendly message for generic error', () {
        final genericError = Exception('Generic error');

        final message = ErrorHandler.getUserFriendlyMessage(genericError);

        expect(message, contains('unexpected error'));
        expect(message, contains('try again'));
      });
    });

    group('Specific Error Handlers', () {
      // These tests primarily verify that the handler methods don't throw an unhandled exception.
      test('should handle code execution errors', () async {
        await ErrorHandler.handleCodeExecutionError(
          'Syntax error in code',
          code: 'syntax_error',
          details: 'Missing semicolon',
        );

        expect(true, isTrue); // Verifies the method completed.
      });

      test('should handle network errors', () async {
        await ErrorHandler.handleNetworkError(
          'Connection timeout',
          code: 'timeout',
          details: 'Request timed out after 30 seconds',
        );

        expect(true, isTrue); // Verifies the method completed.
      });

      test('should handle data errors', () async {
        await ErrorHandler.handleDataError(
          'Failed to save data',
          code: 'save_error',
          details: 'Database connection lost',
        );

        expect(true, isTrue); // Verifies the method completed.
      });

      test('should handle validation errors', () async {
        await ErrorHandler.handleValidationError(
          'Invalid email format',
          code: 'email_validation',
          details: 'Email must contain @ symbol',
        );

        expect(true, isTrue); // Verifies the method completed.
      });

      test('should handle storage errors', () async {
        await ErrorHandler.handleStorageError(
          'Failed to read from storage',
          code: 'read_error',
          details: 'File not found',
        );

        expect(true, isTrue); // Verifies the method completed.
      });
    });

    group('Error Context', () {
      test('should handle errors with context', () async {
        const exception = NetworkException(
          message: 'Network connection failed',
        );

        await ErrorHandler.handleError(exception, context: 'User Login');

        expect(exception.message, equals('Network connection failed'));
      });

      test('should handle errors without showing user message', () async {
        const exception = NetworkException(
          message: 'Network connection failed',
        );

        await ErrorHandler.handleError(exception, showUserMessage: false);

        expect(exception.message, equals('Network connection failed'));
      });

      test('should handle errors with retry callback', () async {
        const exception = NetworkException(
          message: 'Network connection failed',
        );

        bool retryCalled = false;
        void retryCallback() {
          retryCalled = true;
        }

        await ErrorHandler.handleError(exception, onRetry: retryCallback);

        // The retryCallback is not executed by handleError itself, but passed to a potential UI component.
        expect(exception.message, equals('Network connection failed'));
        expect(retryCalled, isFalse);
      });
    });

    group('Exception Types', () {
      test('should create NetworkException with all parameters', () {
        const exception = NetworkException(
          message: 'Connection failed',
          code: 'CONN_001',
          details: {'url': 'https://api.example.com'},
        );

        expect(exception.message, equals('Connection failed'));
        expect(exception.code, equals('CONN_001'));
        expect(exception.details, equals({'url': 'https://api.example.com'}));
      });

      test('should create DataException with minimal parameters', () {
        const exception = DataException(message: 'Data not found');

        expect(exception.message, equals('Data not found'));
        expect(exception.code, isNull);
        expect(exception.details, isNull);
      });

      test('should create CodeExecutionException with details', () {
        const exception = CodeExecutionException(
          message: 'Compilation failed',
          code: 'COMP_001',
          details: 'Missing semicolon at line 5',
        );

        expect(exception.message, equals('Compilation failed'));
        expect(exception.code, equals('COMP_001'));
        expect(exception.details, equals('Missing semicolon at line 5'));
      });

      test('should create ValidationException with code', () {
        const exception = ValidationException(
          message: 'Invalid input',
          code: 'VAL_001',
        );

        expect(exception.message, equals('Invalid input'));
        expect(exception.code, equals('VAL_001'));
        expect(exception.details, isNull);
      });
    });

    group('Error String Representation', () {
      test('should provide proper string representation for NetworkException', () {
        const exception = NetworkException(
          message: 'Connection failed',
          code: 'CONN_001',
        );

        final stringRep = exception.toString();

        expect(stringRep, contains('NetworkException'));
        expect(stringRep, contains('Connection failed'));
        expect(stringRep, contains('Code: CONN_001'));
      });

      test(
        'should provide proper string representation for base AppException',
        () {
          const exception = AppException(
            message: 'Generic error',
            code: 'GEN_001',
          );

          final stringRep = exception.toString();

          expect(stringRep, contains('AppException'));
          expect(stringRep, contains('Generic error'));
          expect(stringRep, contains('Code: GEN_001'));
        },
      );
    });
  });
}