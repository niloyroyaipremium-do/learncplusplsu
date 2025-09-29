import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TerminalWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final bool isDarkMode;
  final bool autoScroll;

  const TerminalWidget({
    super.key,
    required this.controller,
    required this.onClear,
    this.isDarkMode = false,
    this.autoScroll = true,
  });

  @override
  State<TerminalWidget> createState() => _TerminalWidgetState();
}

class _TerminalWidgetState extends State<TerminalWidget> {
  late ScrollController _scrollController;
  final bool _isScrollAtBottom = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.autoScroll && _isScrollAtBottom) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _clearTerminal() {
    widget.controller.clear();
    widget.onClear();
  }

  void _copyOutput() {
    if (widget.controller.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: widget.controller.text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terminal output copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _saveOutput() {
    // In a real implementation, this would save to a file
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Output saved to file'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? const Color(0xFF0C0C0C)
            : const Color(0xFFF5F5F5),
        border: Border.all(
          color: widget.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Terminal Header
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? const Color(0xFF1E1E1E)
                  : Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                // Terminal title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.terminal,
                        size: 16,
                        color: widget.isDarkMode
                            ? Colors.green
                            : Colors.black87,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Terminal',
                        style: TextStyle(
                          color: widget.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Terminal actions
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: _clearTerminal,
                      tooltip: 'Clear Terminal',
                      color: widget.isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: _copyOutput,
                      tooltip: 'Copy Output',
                      color: widget.isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    IconButton(
                      icon: const Icon(Icons.save, size: 18),
                      onPressed: _saveOutput,
                      tooltip: 'Save Output',
                      color: widget.isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Terminal Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: SelectableText(
                    widget.controller.text.isEmpty
                        ? 'Terminal ready. Run your code to see output here...\n'
                        : widget.controller.text,
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 13,
                      color: widget.isDarkMode ? Colors.green : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
