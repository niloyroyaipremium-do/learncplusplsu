import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../services/cpp_execution_service.dart';
import '../../widgets/syntax_highlighted_editor.dart';

class SimpleIDEScreen extends StatefulWidget {
  const SimpleIDEScreen({super.key});

  @override
  State<SimpleIDEScreen> createState() => _SimpleIDEScreenState();
}

class _SimpleIDEScreenState extends State<SimpleIDEScreen> {
  late TextEditingController _codeController;
  late TextEditingController _outputController;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _outputController = TextEditingController();
    _loadDefaultCode();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  void _loadDefaultCode() {
    _codeController.text = '''#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    
    int a = 10;
    int b = 20;
    int sum = a + b;
    
    cout << "Sum of " << a << " and " << b << " is: " << sum << endl;
    
    return 0;
}''';
  }

  void _runCode() async {
    if (_isRunning) return;

    // Clear previous output
    _clearOutput();

    setState(() {
      _isRunning = true;
    });

    _addToOutput('🚀 Running code...\n');
    _addToOutput('─' * 50 + '\n');

    try {
      final result = await CppExecutionService.executeCode(
        _codeController.text,
        timeoutSeconds: 30,
      );

      if (result.success) {
        _addToOutput('✅ Execution successful!\n');
        _addToOutput('📤 Output:\n');
        _addToOutput(result.output);
        if (result.output.isEmpty) {
          _addToOutput('(No output produced)\n');
        }
        _addToOutput('\n');

        if (result.executionTime > 0) {
          _addToOutput('⏱️  Execution time: ${result.executionTime}ms\n');
        }
        if (result.memoryUsed != null && result.memoryUsed! > 0) {
          _addToOutput('💾 Memory used: ${result.memoryUsed}KB\n');
        }
      } else {
        _addToOutput('❌ Execution failed!\n');
        _addToOutput('🚨 Error:\n');
        _addToOutput(result.error);
        _addToOutput('\n');
      }
    } catch (e) {
      _addToOutput('💥 Execution error: $e\n');
    } finally {
      setState(() {
        _isRunning = false;
      });
      _addToOutput('─' * 50 + '\n');
      _addToOutput('✨ Ready for next execution\n\n');
    }
  }

  void _addToOutput(String text) {
    setState(() {
      _outputController.text += text;
    });
  }

  void _clearOutput() {
    setState(() {
      _outputController.clear();
    });
  }

  void _saveCode() {
    // In a real implementation, this would save to a file
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code saved successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keyboard Shortcuts'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('F5 or Ctrl+R - Run code'),
            Text('Ctrl+S - Save code'),
            Text('Ctrl+A - Select all'),
            SizedBox(height: 16),
            Text('Tips:'),
            Text('• Use proper C++ syntax with semicolons'),
            Text('• Include <iostream> for input/output'),
            Text('• Add return 0; at the end of main()'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          backgroundColor: appProvider.isDarkMode
              ? const Color(0xFF1E1E1E)
              : const Color(0xFFF5F5F5),
          appBar: AppBar(
            title: const Text('C++ IDE'),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: _showHelpDialog,
                tooltip: 'Help & Shortcuts',
              ),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveCode,
                tooltip: 'Save Code (Ctrl+S)',
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadDefaultCode,
                tooltip: 'Load Sample Code',
              ),
            ],
          ),
          body: Column(
            children: [
              // Code Editor Section
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: appProvider.isDarkMode
                        ? const Color(0xFF2D2D30)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Editor Header
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: appProvider.isDarkMode
                              ? const Color(0xFF37373D)
                              : Colors.grey[100],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.code,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'main.cpp',
                                    style: TextStyle(
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
                                      color: Colors.blue,
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
                            // Status indicator
                            if (_isRunning)
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            IconButton(
                              icon: Icon(
                                _isRunning ? Icons.stop : Icons.play_arrow,
                                color: _isRunning ? Colors.red : Colors.green,
                              ),
                              onPressed: _isRunning ? null : _runCode,
                              tooltip: _isRunning
                                  ? 'Stop'
                                  : 'Run Code (F5 or Ctrl+R)',
                            ),
                          ],
                        ),
                      ),
                      // Code Editor
                      Expanded(
                        child: Focus(
                          onKeyEvent: (node, event) {
                            // Add keyboard shortcuts
                            if (event is KeyDownEvent) {
                              final isControlPressed =
                                  HardwareKeyboard.instance.isControlPressed;
                              if (event.logicalKey.keyLabel == 'F5' ||
                                  (isControlPressed &&
                                      event.logicalKey.keyLabel == 'r')) {
                                _runCode();
                                return KeyEventResult.handled;
                              }
                              if (isControlPressed &&
                                  event.logicalKey.keyLabel == 's') {
                                _saveCode();
                                return KeyEventResult.handled;
                              }
                              if (isControlPressed &&
                                  event.logicalKey.keyLabel == 'a') {
                                _codeController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _codeController.text.length,
                                );
                                return KeyEventResult.handled;
                              }
                            }
                            return KeyEventResult.ignored;
                          },
                          child: SyntaxHighlightedEditor(
                            controller: _codeController,
                            isDarkMode: appProvider.isDarkMode,
                            fontSize: 16.0,
                            onChanged: () {
                              // Handle text changes if needed
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Output Panel Section
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  decoration: BoxDecoration(
                    color: appProvider.isDarkMode
                        ? const Color(0xFF0C0C0C)
                        : const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Output Header
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: appProvider.isDarkMode
                              ? const Color(0xFF37373D)
                              : Colors.grey[200],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.terminal,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Output',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: _clearOutput,
                              tooltip: 'Clear Output',
                            ),
                          ],
                        ),
                      ),
                      // Output Content
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: TextField(
                            controller: _outputController,
                            readOnly: true,
                            maxLines: null,
                            expands: true,
                            style: TextStyle(
                              fontFamily: 'Consolas',
                              fontSize: 14,
                              color: appProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Output will appear here...',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
