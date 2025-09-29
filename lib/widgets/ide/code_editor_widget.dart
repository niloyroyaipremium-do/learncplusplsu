import 'package:flutter/material.dart';
import '../syntax_highlighted_editor.dart';

class CodeEditorWidget extends StatefulWidget {
  final TextEditingController controller;
  final String fileName;
  final Function(String) onCodeChanged;
  final bool isDarkMode;
  final bool showLineNumbers;
  final bool showMinimap;
  final double fontSize;

  const CodeEditorWidget({
    super.key,
    required this.controller,
    required this.fileName,
    required this.onCodeChanged,
    this.isDarkMode = false,
    this.showLineNumbers = true,
    this.showMinimap = true,
    this.fontSize = 16.0,
  });

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  int _cursorPosition = 0;
  int _selectionStart = 0;
  int _selectionEnd = 0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChanged() {
    widget.onCodeChanged(widget.controller.text);
    setState(() {
      _cursorPosition = widget.controller.selection.baseOffset;
      _selectionStart = widget.controller.selection.start;
      _selectionEnd = widget.controller.selection.end;
    });
  }


  void _formatCode() {
    // Basic code formatting
    String code = widget.controller.text;

    // Add proper indentation
    List<String> lines = code.split('\n');
    List<String> formattedLines = [];
    int indentLevel = 0;

    for (String line in lines) {
      String trimmedLine = line.trim();
      if (trimmedLine.isEmpty) {
        formattedLines.add('');
        continue;
      }

      // Decrease indent for closing braces
      if (trimmedLine.startsWith('}') ||
          trimmedLine.startsWith(']') ||
          trimmedLine.startsWith(')')) {
        indentLevel = (indentLevel - 1).clamp(0, 100);
      }

      // Add indentation
      String indentedLine = '  ' * indentLevel + trimmedLine;
      formattedLines.add(indentedLine);

      // Increase indent for opening braces
      if (trimmedLine.endsWith('{') ||
          trimmedLine.endsWith('[') ||
          trimmedLine.endsWith('(')) {
        indentLevel++;
      }
    }

    widget.controller.text = formattedLines.join('\n');
  }

  void _commentSelection() {
    final selection = widget.controller.selection;
    if (selection.isCollapsed) return;

    String selectedText = widget.controller.text.substring(
      selection.start,
      selection.end,
    );

    List<String> lines = selectedText.split('\n');
    List<String> commentedLines = lines.map((line) => '// $line').toList();
    String commentedText = commentedLines.join('\n');

    widget.controller.text = widget.controller.text.replaceRange(
      selection.start,
      selection.end,
      commentedText,
    );
  }

  void _duplicateLine() {
    final selection = widget.controller.selection;
    final text = widget.controller.text;
    final lines = text.split('\n');

    int currentLine = text.substring(0, selection.start).split('\n').length - 1;
    if (currentLine < lines.length) {
      String lineToDuplicate = lines[currentLine];
      String newText = text.replaceRange(
        selection.start,
        selection.end,
        '$lineToDuplicate\n',
      );
      widget.controller.text = newText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border.all(
          color: _isFocused
              ? Theme.of(context).primaryColor
              : Colors.grey.withOpacity(0.3),
          width: _isFocused ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Editor Header
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? const Color(0xFF2D2D30)
                  : Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                // File name and language indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        _getFileIcon(),
                        size: 16,
                        color: _getFileIconColor(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.fileName,
                        style: TextStyle(
                          color: widget.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'C++',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Editor actions
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.format_align_left, size: 18),
                      onPressed: _formatCode,
                      tooltip: 'Format Code',
                      color: widget.isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    IconButton(
                      icon: const Icon(Icons.comment, size: 18),
                      onPressed: _commentSelection,
                      tooltip: 'Comment Selection',
                      color: widget.isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    IconButton(
                      icon: const Icon(Icons.content_copy, size: 18),
                      onPressed: _duplicateLine,
                      tooltip: 'Duplicate Line',
                      color: widget.isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Code Editor
          Expanded(
            child: SyntaxHighlightedEditor(
              controller: widget.controller,
              isDarkMode: widget.isDarkMode,
              fontSize: widget.fontSize,
              onChanged: () {
                widget.onCodeChanged(widget.controller.text);
              },
            ),
          ),

          // Status Bar
          Container(
            height: 24,
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? const Color(0xFF2D2D30)
                  : Colors.grey[100],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Line ${_getCurrentLine()}, Column ${_getCurrentColumn()}',
                    style: TextStyle(
                      color: widget.isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                if (_isFocused)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '${_getSelectionLength()} selected',
                      style: TextStyle(
                        color: widget.isDarkMode
                            ? Colors.white70
                            : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon() {
    if (widget.fileName.endsWith('.cpp') || widget.fileName.endsWith('.cxx')) {
      return Icons.code;
    } else if (widget.fileName.endsWith('.h') ||
        widget.fileName.endsWith('.hpp')) {
      return Icons.description;
    } else {
      return Icons.insert_drive_file;
    }
  }

  Color _getFileIconColor() {
    if (widget.fileName.endsWith('.cpp') || widget.fileName.endsWith('.cxx')) {
      return Colors.blue;
    } else if (widget.fileName.endsWith('.h') ||
        widget.fileName.endsWith('.hpp')) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  int _getCurrentLine() {
    return widget.controller.text
        .substring(0, _cursorPosition)
        .split('\n')
        .length;
  }

  int _getCurrentColumn() {
    String textBeforeCursor = widget.controller.text.substring(
      0,
      _cursorPosition,
    );
    List<String> lines = textBeforeCursor.split('\n');
    return lines.last.length + 1;
  }

  int _getSelectionLength() {
    return _selectionEnd - _selectionStart;
  }
}
