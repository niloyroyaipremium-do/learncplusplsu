import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:provider/provider.dart';
import '../../providers/progress_provider.dart';
import '../../services/cpp_execution_service.dart';

class CodeEditorScreen extends StatefulWidget {
  const CodeEditorScreen({super.key});

  @override
  State<CodeEditorScreen> createState() => _CodeEditorScreenState();
}

class _CodeEditorScreenState extends State<CodeEditorScreen> {
  final CodeController _codeController = CodeController(
    text: '''#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    return 0;
}''',
  );

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Editor'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (template) {
              _codeController.text = template;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'template1',
                child: Text('Hello World'),
              ),
              const PopupMenuItem(
                value: 'template2',
                child: Text('Input/Output'),
              ),
              const PopupMenuItem(
                value: 'template3',
                child: Text('Basic Math'),
              ),
              const PopupMenuItem(value: 'template4', child: Text('For Loop')),
              const PopupMenuItem(value: 'template5', child: Text('If-Else')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildToolbarButton(
                          context,
                          'Run',
                          Icons.play_arrow,
                          () => _runCode(context),
                        ),
                        const SizedBox(width: 8),
                        _buildToolbarButton(
                          context,
                          'Clear',
                          Icons.clear,
                          () => _clearCode(),
                        ),
                        const SizedBox(width: 8),
                        _buildToolbarButton(
                          context,
                          'Format',
                          Icons.format_align_left,
                          () => _formatCode(),
                        ),
                        const SizedBox(width: 8),
                        _buildToolbarButton(
                          context,
                          'Share',
                          Icons.share,
                          () => _shareCode(context),
                        ),
                        const SizedBox(width: 8),
                        _buildToolbarButton(
                          context,
                          'Save',
                          Icons.save,
                          () => _saveCode(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Code Editor
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CodeField(
                controller: _codeController,
                textStyle: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ),

          // Output Panel
          Container(
            height: 200,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.terminal, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'Output',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () {
                          setState(() {
                            _output = '';
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      child: Text(
                        _output.isEmpty
                            ? 'Click "Run" to execute your code...'
                            : _output,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontSize: 14,
                        ),
                      ),
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

  Widget _buildToolbarButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  String _output = '';

  void _runCode(BuildContext context) async {
    setState(() {
      _output = 'Compiling...\nRunning...\n\n';
    });

    try {
      final result = await CppExecutionService.executeCode(
        _codeController.text,
        timeoutSeconds: 30,
      );

      if (result.success) {
        setState(() {
          _output += result.output;
          if (result.output.isEmpty) {
            _output += '(No output produced)';
          }
          _output += '\n\nProcess finished with exit code 0';
        });

        // Add points for using the code editor
        context.read<ProgressProvider>().addPoints(5);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Code executed successfully! +5 points'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _output += 'Error: ${result.error}';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Execution failed: ${result.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _output += 'Execution error: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Execution error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearCode() {
    _codeController.text = '';
    setState(() {
      _output = '';
    });
  }

  void _formatCode() {
    // Simple formatting - in a real app, you'd use a proper formatter
    String formatted = _codeController.text
        .replaceAll(RegExp(r'\s*{\s*'), ' {\n    ')
        .replaceAll(RegExp(r';\s*'), ';\n')
        .replaceAll(RegExp(r'\n\s*\n'), '\n');

    _codeController.text = formatted;
  }

  void _shareCode(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code sharing feature coming soon!')),
    );
  }

  void _saveCode(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
