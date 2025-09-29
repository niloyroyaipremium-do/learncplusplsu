import 'package:flutter/material.dart';
import '../services/cpp_execution_service.dart';
import '../widgets/syntax_highlighted_editor.dart';

class OopTutorial08StaticMembers extends StatefulWidget {
  const OopTutorial08StaticMembers({super.key});

  @override
  State<OopTutorial08StaticMembers> createState() =>
      _OopTutorial08StaticMembersState();
}

class _OopTutorial08StaticMembersState
    extends State<OopTutorial08StaticMembers> {
  final TextEditingController _codeController = TextEditingController();

  bool _isExecuting = false;
  String _executionResult = '';

  @override
  void initState() {
    super.initState();
    _loadDefaultCode();
  }

  void _loadDefaultCode() {
    _codeController.text = '''#include <iostream>
using namespace std;

class Counter {
private:
    static int count;  // Static member variable
    int id;

public:
    Counter() {
        count++;  // Increment static count
        id = count;
        cout << "Object " << id << " created. Total objects: " << count << endl;
    }
    
    ~Counter() {
        cout << "Object " << id << " destroyed. Remaining objects: " << --count << endl;
    }
    
    // Static member function
    static int getCount() {
        return count;
    }
    
    int getId() {
        return id;
    }
};

// Define static member outside the class
int Counter::count = 0;

int main() {
    cout << "=== Static Members Tutorial ===" << endl;
    cout << "Initial count: " << Counter::getCount() << endl;
    
    {
        Counter obj1;
        Counter obj2;
        cout << "Count inside block: " << Counter::getCount() << endl;
    }  // Objects go out of scope here
    
    cout << "Final count: " << Counter::getCount() << endl;
    
    return 0;
}''';
  }

  Future<void> _executeCode() async {
    if (_isExecuting) return;

    setState(() {
      _isExecuting = true;
      _executionResult = 'Executing...';
    });

    try {
      final result = await CppExecutionService.executeCode(
        _codeController.text,
      );
      setState(() {
        _executionResult = result.output;
      });
    } catch (e) {
      setState(() {
        _executionResult = 'Error: $e';
      });
    } finally {
      setState(() {
        _isExecuting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Static Members in C++'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _executeCode,
            tooltip: 'Run Code',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Static Members',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.blue[600],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Static members belong to the class itself, not to any specific object. '
                      'They are shared among all objects of the class and can be accessed without creating an object.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Key Points:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('• Static variables are shared by all objects'),
                          Text(
                            '• Static functions can be called without creating objects',
                          ),
                          Text(
                            '• Static members are defined outside the class',
                          ),
                          Text('• Use :: operator to access static members'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Code Editor
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.code, color: Colors.green[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Code Editor',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.green[600],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: _isExecuting ? null : _executeCode,
                          icon: _isExecuting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.play_arrow),
                          label: Text(_isExecuting ? 'Running...' : 'Run Code'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SyntaxHighlightedEditor(
                        controller: _codeController,
                        language: 'cpp',
                        fontSize: 14,
                        isDarkMode: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Execution Result
            if (_executionResult.isNotEmpty)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.terminal, color: Colors.orange[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Execution Result',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.orange[600],
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _executionResult,
                          style: const TextStyle(
                            color: Colors.green,
                            fontFamily: 'monospace',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
