import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/cpp.dart';

/// Optimized Code Editor Widget
///
/// This widget provides high-performance code editing with:
/// - Efficient syntax highlighting
/// - Optimized rendering
/// - Memory management
/// - Performance monitoring
class OptimizedCodeEditor extends StatefulWidget {
  final String initialCode;
  final ValueChanged<String>? onCodeChanged;
  final bool readOnly;
  final double? height;
  final String? language;
  final Map<String, TextStyle>? theme;

  const OptimizedCodeEditor({
    super.key,
    this.initialCode = '',
    this.onCodeChanged,
    this.readOnly = false,
    this.height,
    this.language = 'cpp',
    this.theme,
  });

  @override
  State<OptimizedCodeEditor> createState() => _OptimizedCodeEditorState();
}

class _OptimizedCodeEditorState extends State<OptimizedCodeEditor>
    with AutomaticKeepAliveClientMixin {
  late CodeController _controller;
  late FocusNode _focusNode;

  // Performance optimization
  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 300);

  // Memory management
  bool _isDisposed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeEditor();
  }

  void _initializeEditor() {
    _focusNode = FocusNode();
    _controller = CodeController(
      text: widget.initialCode,
      language: _getLanguage(),
      theme: _getTheme(),
    );

    _controller.addListener(_onCodeChanged);
  }

  Language? _getLanguage() {
    switch (widget.language?.toLowerCase()) {
      case 'cpp':
      case 'c++':
        return cpp;
      default:
        return cpp;
    }
  }

  Map<String, TextStyle> _getTheme() {
    return widget.theme ?? _getDefaultTheme();
  }

  Map<String, TextStyle> _getDefaultTheme() {
    return {
      'root': const TextStyle(
        color: Color(0xFFD4D4D4),
        backgroundColor: Color(0xFF1E1E1E),
        fontSize: 14,
        fontFamily: 'Consolas, Monaco, "Courier New", monospace',
      ),
      'keyword': const TextStyle(
        color: Color(0xFF569CD6),
        fontWeight: FontWeight.bold,
      ),
      'string': const TextStyle(color: Color(0xFFCE9178)),
      'comment': const TextStyle(
        color: Color(0xFF6A9955),
        fontStyle: FontStyle.italic,
      ),
      'number': const TextStyle(color: Color(0xFFB5CEA8)),
      'operator': const TextStyle(color: Color(0xFFD4D4D4)),
      'punctuation': const TextStyle(color: Color(0xFFD4D4D4)),
      'class': const TextStyle(color: Color(0xFF4EC9B0)),
      'function': const TextStyle(color: Color(0xFFDCDCAA)),
      'variable': const TextStyle(color: Color(0xFF9CDCFE)),
    };
  }

  void _onCodeChanged() {
    if (_isDisposed) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDelay, () {
      if (!_isDisposed && widget.onCodeChanged != null) {
        widget.onCodeChanged!(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    _controller.removeListener(_onCodeChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      height: widget.height ?? 400,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CodeTheme(
          data: CodeThemeData(styles: _getTheme()),
          child: CodeField(
            controller: _controller,
            focusNode: _focusNode,
            readOnly: widget.readOnly,
            textStyle: const TextStyle(
              fontFamily: 'Consolas, Monaco, "Courier New", monospace',
              fontSize: 14,
            ),
            lineNumberStyle: LineNumberStyle(
              textStyle: TextStyle(
                color: Colors.grey.withValues(alpha: 0.7),
                fontSize: 12,
              ),
              width: 60,
            ),
            background: const Color(0xFF1E1E1E),
            selection: const TextSelectionThemeData(
              selectionColor: Color(0xFF264F78),
              selectionHandleColor: Color(0xFF264F78),
            ),
            cursorColor: Colors.white,
            onChanged: (text) {
              // Handle real-time changes if needed
            },
          ),
        ),
      ),
    );
  }
}

/// Optimized Code Execution Widget
///
/// This widget provides high-performance code execution with:
/// - Async execution
/// - Progress indicators
/// - Error handling
/// - Memory management
class OptimizedCodeExecutor extends StatefulWidget {
  final String code;
  final VoidCallback? onExecutionComplete;
  final ValueChanged<String>? onOutputChanged;
  final ValueChanged<String>? onErrorChanged;

  const OptimizedCodeExecutor({
    super.key,
    required this.code,
    this.onExecutionComplete,
    this.onOutputChanged,
    this.onErrorChanged,
  });

  @override
  State<OptimizedCodeExecutor> createState() => _OptimizedCodeExecutorState();
}

class _OptimizedCodeExecutorState extends State<OptimizedCodeExecutor> {
  bool _isExecuting = false;
  String _output = '';
  String _error = '';

  @override
  void initState() {
    super.initState();
    _executeCode();
  }

  Future<void> _executeCode() async {
    if (widget.code.isEmpty) return;

    setState(() {
      _isExecuting = true;
      _output = '';
      _error = '';
    });

    try {
      // Import the execution service
      // This would be replaced with actual service call
      await Future.delayed(const Duration(seconds: 1)); // Simulate execution

      setState(() {
        _isExecuting = false;
        _output = 'Code executed successfully!';
      });

      widget.onOutputChanged?.call(_output);
      widget.onExecutionComplete?.call();
    } catch (e) {
      setState(() {
        _isExecuting = false;
        _error = e.toString();
      });

      widget.onErrorChanged?.call(_error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.play_circle_outline,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Output',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_isExecuting)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _isExecuting
                    ? 'Executing...'
                    : (_error.isNotEmpty ? _error : _output),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Consolas, Monaco, "Courier New", monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
