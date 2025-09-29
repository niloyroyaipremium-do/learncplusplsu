import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Represents an error marker in the code editor
class ErrorMarker {
  final int line;
  final int column;
  final String message;
  final String severity;

  const ErrorMarker({
    required this.line,
    required this.column,
    required this.message,
    this.severity = 'error',
  });
}

/// Represents a breakpoint in the code editor
class Breakpoint {
  final int line;
  final bool isEnabled;

  const Breakpoint({required this.line, this.isEnabled = true});
}

/// Represents a syntax token for highlighting
class SyntaxToken {
  final String text;
  final SyntaxTokenType type;
  final int start;
  final int end;

  const SyntaxToken({
    required this.text,
    required this.type,
    required this.start,
    required this.end,
  });
}

/// Types of syntax tokens
enum SyntaxTokenType {
  keyword,
  identifier,
  string,
  number,
  comment,
  operator,
  punctuation,
  whitespace,
  text,
}

/// Dialog for find and replace functionality
class FindReplaceDialog extends StatefulWidget {
  final TextEditingController controller;
  final Function(String find, String replace) onReplace;

  const FindReplaceDialog({
    super.key,
    required this.controller,
    required this.onReplace,
  });

  @override
  State<FindReplaceDialog> createState() => _FindReplaceDialogState();
}

class _FindReplaceDialogState extends State<FindReplaceDialog> {
  final TextEditingController _findController = TextEditingController();
  final TextEditingController _replaceController = TextEditingController();

  @override
  void dispose() {
    _findController.dispose();
    _replaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Find and Replace'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _findController,
            decoration: const InputDecoration(
              labelText: 'Find',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _replaceController,
            decoration: const InputDecoration(
              labelText: 'Replace with',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onReplace(_findController.text, _replaceController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Replace'),
        ),
      ],
    );
  }
}

/// Dialog for go to line functionality
class GoToLineDialog extends StatefulWidget {
  final int maxLines;
  final Function(int lineNumber) onGoToLine;

  const GoToLineDialog({
    super.key,
    required this.maxLines,
    required this.onGoToLine,
  });

  @override
  State<GoToLineDialog> createState() => _GoToLineDialogState();
}

class _GoToLineDialogState extends State<GoToLineDialog> {
  final TextEditingController _lineController = TextEditingController();

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Go to Line'),
      content: TextField(
        controller: _lineController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Line number (1-${widget.maxLines})',
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final lineNumber = int.tryParse(_lineController.text);
            if (lineNumber != null &&
                lineNumber >= 1 &&
                lineNumber <= widget.maxLines) {
              widget.onGoToLine(lineNumber);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Go'),
        ),
      ],
    );
  }
}

class AdvancedCodeEditor extends StatefulWidget {
  final String initialCode;
  final Function(String) onCodeChanged;
  final Function(String) onError;
  final List<ErrorMarker> errorMarkers;
  final List<Breakpoint> breakpoints;
  final Function(int) onBreakpointToggled;
  final bool isReadOnly;
  final String language;
  final ThemeData? theme;

  const AdvancedCodeEditor({
    super.key,
    this.initialCode = '',
    required this.onCodeChanged,
    required this.onError,
    this.errorMarkers = const [],
    this.breakpoints = const [],
    required this.onBreakpointToggled,
    this.isReadOnly = false,
    this.language = 'cpp',
    this.theme,
  });

  @override
  State<AdvancedCodeEditor> createState() => _AdvancedCodeEditorState();
}

class _AdvancedCodeEditorState extends State<AdvancedCodeEditor>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  late FocusNode _focusNode;

  // Undo/Redo functionality
  final List<String> _undoStack = [];
  final List<String> _redoStack = [];
  int _undoIndex = -1;

  // Line numbers and syntax highlighting
  List<String> _lines = [];
  final Map<int, List<SyntaxToken>> _syntaxTokens = {};

  // Selection and cursor
  TextSelection _selection = const TextSelection.collapsed(offset: 0);

  // Animation controllers
  late AnimationController _errorAnimationController;
  late AnimationController _breakpointAnimationController;

  // C++ keywords and syntax
  static const Set<String> _cppKeywords = {
    'auto',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'const_cast',
    'continue',
    'default',
    'delete',
    'do',
    'dynamic_cast',
    'else',
    'enum',
    'explicit',
    'extern',
    'false',
    'for',
    'friend',
    'goto',
    'if',
    'inline',
    'int',
    'long',
    'mutable',
    'namespace',
    'new',
    'operator',
    'private',
    'protected',
    'public',
    'register',
    'reinterpret_cast',
    'return',
    'short',
    'signed',
    'sizeof',
    'static',
    'static_cast',
    'struct',
    'switch',
    'template',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'typeid',
    'typename',
    'union',
    'unsigned',
    'using',
    'virtual',
    'void',
    'volatile',
    'while',
    'bool',
    'char',
    'double',
    'float',
    'string',
    'vector',
    'map',
    'set',
    'list',
    'cout',
    'cin',
    'endl',
    'include',
    'define',
    'ifdef',
    'ifndef',
    'endif',
    'pragma',
    'main',
  };

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCode);
    _scrollController = ScrollController();
    _focusNode = FocusNode();

    _errorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _breakpointAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _updateLines();
    _updateSyntaxHighlighting();

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _errorAnimationController.dispose();
    _breakpointAnimationController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _updateLines();
    _updateSyntaxHighlighting();
    _updateUndoStack();
    widget.onCodeChanged(_controller.text);
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _updateCursorPosition();
    }
  }

  void _updateLines() {
    _lines = _controller.text.split('\n');
  }

  void _updateSyntaxHighlighting() {
    _syntaxTokens.clear();
    for (int i = 0; i < _lines.length; i++) {
      _syntaxTokens[i] = _parseLine(_lines[i]);
    }
  }

  List<SyntaxToken> _parseLine(String line) {
    List<SyntaxToken> tokens = [];
    String remaining = line;
    int offset = 0;

    while (remaining.isNotEmpty) {
      // Skip whitespace
      if (remaining.startsWith(' ')) {
        int spaceCount = 0;
        while (spaceCount < remaining.length && remaining[spaceCount] == ' ') {
          spaceCount++;
        }
        tokens.add(
          SyntaxToken(
            text: remaining.substring(0, spaceCount),
            type: SyntaxTokenType.whitespace,
            start: offset,
            end: offset + spaceCount,
          ),
        );
        offset += spaceCount;
        remaining = remaining.substring(spaceCount);
        continue;
      }

      // Comments
      if (remaining.startsWith('//')) {
        tokens.add(
          SyntaxToken(
            text: remaining,
            type: SyntaxTokenType.comment,
            start: offset,
            end: offset + remaining.length,
          ),
        );
        break;
      }

      // Multi-line comments
      if (remaining.startsWith('/*')) {
        int endIndex = remaining.indexOf('*/');
        if (endIndex != -1) {
          tokens.add(
            SyntaxToken(
              text: remaining.substring(0, endIndex + 2),
              type: SyntaxTokenType.comment,
              start: offset,
              end: offset + endIndex + 2,
            ),
          );
          offset += endIndex + 2;
          remaining = remaining.substring(endIndex + 2);
          continue;
        }
      }

      // Strings
      if (remaining.startsWith('"') || remaining.startsWith("'")) {
        String quote = remaining[0];
        int endIndex = remaining.indexOf(quote, 1);
        if (endIndex != -1) {
          tokens.add(
            SyntaxToken(
              text: remaining.substring(0, endIndex + 1),
              type: SyntaxTokenType.string,
              start: offset,
              end: offset + endIndex + 1,
            ),
          );
          offset += endIndex + 1;
          remaining = remaining.substring(endIndex + 1);
          continue;
        }
      }

      // Numbers
      RegExp numberRegex = RegExp(r'^\d+(\.\d+)?([eE][+-]?\d+)?[fF]?');
      Match? numberMatch = numberRegex.firstMatch(remaining);
      if (numberMatch != null) {
        String number = numberMatch.group(0)!;
        tokens.add(
          SyntaxToken(
            text: number,
            type: SyntaxTokenType.number,
            start: offset,
            end: offset + number.length,
          ),
        );
        offset += number.length;
        remaining = remaining.substring(number.length);
        continue;
      }

      // Keywords and identifiers
      RegExp wordRegex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*');
      Match? wordMatch = wordRegex.firstMatch(remaining);
      if (wordMatch != null) {
        String word = wordMatch.group(0)!;
        SyntaxTokenType type = _cppKeywords.contains(word)
            ? SyntaxTokenType.keyword
            : SyntaxTokenType.identifier;

        tokens.add(
          SyntaxToken(
            text: word,
            type: type,
            start: offset,
            end: offset + word.length,
          ),
        );
        offset += word.length;
        remaining = remaining.substring(word.length);
        continue;
      }

      // Operators and punctuation
      String char = remaining[0];
      SyntaxTokenType type = _getOperatorType(char);
      tokens.add(
        SyntaxToken(text: char, type: type, start: offset, end: offset + 1),
      );
      offset += 1;
      remaining = remaining.substring(1);
    }

    return tokens;
  }

  SyntaxTokenType _getOperatorType(String char) {
    switch (char) {
      case '+':
      case '-':
      case '*':
      case '/':
      case '%':
      case '=':
      case '!':
      case '<':
      case '>':
      case '&':
      case '|':
      case '^':
        return SyntaxTokenType.operator;
      case '(':
      case ')':
      case '[':
      case ']':
      case '{':
      case '}':
      case ';':
      case ',':
      case '.':
        return SyntaxTokenType.punctuation;
      default:
        return SyntaxTokenType.text;
    }
  }

  void _updateCursorPosition() {
    _selection = _controller.selection;
  }

  void _updateUndoStack() {
    if (_undoIndex < _undoStack.length - 1) {
      _undoStack.removeRange(_undoIndex + 1, _undoStack.length);
    }
    _undoStack.add(_controller.text);
    _undoIndex = _undoStack.length - 1;

    // Limit undo stack size
    if (_undoStack.length > 50) {
      _undoStack.removeAt(0);
      _undoIndex--;
    }
  }

  void _undo() {
    if (_undoIndex > 0) {
      _redoStack.add(_undoStack[_undoIndex]);
      _undoIndex--;
      _controller.text = _undoStack[_undoIndex];
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      _undoIndex++;
      _undoStack.add(_redoStack.removeLast());
      _controller.text = _undoStack[_undoIndex];
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  void _copy() {
    if (_selection.isValid && !_selection.isCollapsed) {
      Clipboard.setData(
        ClipboardData(
          text: _controller.text.substring(_selection.start, _selection.end),
        ),
      );
    }
  }

  void _paste() {
    Clipboard.getData('text/plain').then((data) {
      if (data != null && data.text != null) {
        _controller.text = _controller.text.replaceRange(
          _selection.start,
          _selection.end,
          data.text!,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border.all(color: Colors.grey[800]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildToolbar(),
          Expanded(child: _buildEditor()),
        ],
      ),
    );
  }

  Widget _buildEditor() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        scrollController: _scrollController,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter your C++ code here...',
        ),
        style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
        onChanged: (value) {
          widget.onCodeChanged(value);
          _updateLineNumbers();
        },
      ),
    );
  }

  void _updateLineNumbers() {
    // This method can be used to update line numbers if needed
    // For now, it's a placeholder
  }

  Widget _buildToolbar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D30),
        border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.undo, size: 18),
            onPressed: _undoIndex > 0 ? _undo : null,
            tooltip: 'Undo',
          ),
          IconButton(
            icon: const Icon(Icons.redo, size: 18),
            onPressed: _redoStack.isNotEmpty ? _redo : null,
            tooltip: 'Redo',
          ),
          const VerticalDivider(width: 1),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            onPressed: _selection.isValid && !_selection.isCollapsed
                ? _copy
                : null,
            tooltip: 'Copy',
          ),
          IconButton(
            icon: const Icon(Icons.content_paste, size: 18),
            onPressed: _paste,
            tooltip: 'Paste',
          ),
        ],
      ),
    );
  }
}
