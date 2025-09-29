import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import '../core/errors/error_handler.dart';
import '../utils/logger.dart';

/// High-Performance C++ Code Execution Service
///
/// This service provides optimized C++ code compilation and execution
/// using native C++ libraries for maximum performance.
class CppExecutionServiceOptimized {
  static CppExecutionServiceOptimized? _instance;
  static CppExecutionServiceOptimized get instance =>
      _instance ??= CppExecutionServiceOptimized._();

  CppExecutionServiceOptimized._();

  // C++ library handle
  late DynamicLibrary _cppLib;
  bool _isInitialized = false;

  /// Initialize the C++ execution service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load the native C++ library
      if (Platform.isWindows) {
        _cppLib = DynamicLibrary.open('cpp_compiler.dll');
      } else if (Platform.isLinux) {
        _cppLib = DynamicLibrary.open('libcpp_compiler.so');
      } else if (Platform.isMacOS) {
        _cppLib = DynamicLibrary.open('libcpp_compiler.dylib');
      } else {
        throw UnsupportedError('Platform not supported');
      }

      _isInitialized = true;
      Logger.info('C++ execution service initialized successfully');
    } catch (e) {
      Logger.error('Failed to initialize C++ execution service', e);
      await ErrorHandler.handleCodeExecutionError(
        'Failed to initialize C++ compiler',
        'initialization_error',
        e.toString(),
      );
      rethrow;
    }
  }

  /// Execute C++ code with high performance
  Future<CppExecutionResult> executeCode(
    String code, {
    int timeoutSeconds = 30,
    bool enableOptimizations = true,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Use isolate for non-blocking execution with optimized memory management
      return await Isolate.run(
        () => _executeCodeSync(code, timeoutSeconds, enableOptimizations),
      );
    } catch (e) {
      Logger.error('C++ code execution failed', e);
      await ErrorHandler.handleCodeExecutionError(
        'Code execution failed: ${e.toString()}',
        'execution_error',
        e.toString(),
      );

      return CppExecutionResult(
        success: false,
        output: '',
        error: ErrorHandler.getUserFriendlyMessage(e),
        compileTime: 0,
        executionTime: 0,
      );
    }
  }

  /// Synchronous code execution (runs in isolate)
  CppExecutionResult _executeCodeSync(
    String code,
    int timeoutSeconds,
    bool enableOptimizations,
  ) {
    try {
      // Call native C++ function
      final compileCppCode = _cppLib
          .lookupFunction<
            Pointer<CppResult> Function(Pointer<Utf8>, Int32),
            Pointer<CppResult> Function(Pointer<Utf8>, int)
          >('compileCppCode');

      final freeCppResult = _cppLib
          .lookupFunction<
            Void Function(Pointer<CppResult>),
            void Function(Pointer<CppResult>)
          >('freeCppResult');

      // Convert Dart string to C string
      final codeUtf8 = code.toNativeUtf8();

      try {
        // Call C++ function
        final resultPtr = compileCppCode(codeUtf8, timeoutSeconds);
        final result = resultPtr.ref;

        // Extract results
        final success = result.success;
        final output = result.output.toDartString();
        final error = result.error.toDartString();
        final compileTime = result.compileTime;
        final executionTime = result.executionTime;

        // Free C++ memory
        freeCppResult(resultPtr);

        return CppExecutionResult(
          success: success,
          output: output,
          error: error,
          compileTime: compileTime,
          executionTime: executionTime,
        );
      } finally {
        // Free C string
        malloc.free(codeUtf8);
      }
    } catch (e) {
      return CppExecutionResult(
        success: false,
        output: '',
        error: 'Native execution failed: ${e.toString()}',
        compileTime: 0,
        executionTime: 0,
      );
    }
  }

  /// Validate C++ code syntax
  Future<bool> validateCode(String code) async {
    try {
      final result = await executeCode(code, timeoutSeconds: 5);
      return result.success || !result.error.contains('syntax error');
    } catch (e) {
      return false;
    }
  }

  /// Get compiler information
  Future<Map<String, dynamic>> getCompilerInfo() async {
    if (!_isInitialized) {
      await initialize();
    }

    return {
      'type': 'Native C++ Compiler',
      'version': '1.0.0',
      'optimization': 'Enabled',
      'platform': Platform.operatingSystem,
      'architecture': Platform.operatingSystemVersion,
    };
  }

  /// Cleanup resources
  void dispose() {
    _isInitialized = false;
    Logger.info('C++ execution service disposed');
  }
}

/// Result of C++ code execution
class CppExecutionResult {
  final bool success;
  final String output;
  final String error;
  final double compileTime;
  final double executionTime;

  CppExecutionResult({
    required this.success,
    required this.output,
    required this.error,
    required this.compileTime,
    required this.executionTime,
  });

  @override
  String toString() {
    return 'CppExecutionResult(success: $success, output: $output, error: $error, '
        'compileTime: ${compileTime}ms, executionTime: ${executionTime}ms)';
  }
}

/// C++ result structure for FFI
final class CppResult extends Struct {
  @Bool()
  external bool success;

  external Pointer<Utf8> output;
  external Pointer<Utf8> error;

  @Double()
  external double compileTime;

  @Double()
  external double executionTime;
}
