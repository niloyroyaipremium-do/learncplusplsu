import 'package:flutter/material.dart';

class SyntaxHighlightedEditor extends StatefulWidget {
  final TextEditingController controller;
  final String language;
  final double fontSize;
  final bool isDarkMode;
  final String theme;
  final VoidCallback? onChanged;

  const SyntaxHighlightedEditor({
    super.key,
    required this.controller,
    this.language = 'cpp',
    this.fontSize = 20.0,
    this.isDarkMode = false,
    this.theme = 'default',
    this.onChanged,
  });

  @override
  State<SyntaxHighlightedEditor> createState() =>
      _SyntaxHighlightedEditorState();
}

class _SyntaxHighlightedEditorState extends State<SyntaxHighlightedEditor> {
  late ScrollController _scrollController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.theme) {
      case 'dark':
        return const Color(0xFF1E1E1E);
      case 'monokai':
        return const Color(0xFF272822);
      case 'solarized':
        return const Color(0xFFFDF6E3);
      default:
        return widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    }
  }

  Color _getTextColor() {
    switch (widget.theme) {
      case 'dark':
        return Colors.white;
      case 'monokai':
        return const Color(0xFFF8F8F2);
      case 'solarized':
        return const Color(0xFF586E75);
      default:
        return widget.isDarkMode ? Colors.white : Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
          fontFamily: 'Consolas',
          fontSize: widget.fontSize,
          color: _getTextColor(),
          height: 1.6,
        ),
        decoration: InputDecoration(
          hintText: 'Enter your C++ code here...',
          hintStyle: TextStyle(
            color: _getTextColor().withOpacity(0.6),
            fontFamily: 'Consolas',
            fontSize: widget.fontSize,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onChanged: (value) {
          widget.onChanged?.call();
        },
      ),
    );
  }
}
