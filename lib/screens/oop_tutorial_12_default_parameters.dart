import 'package:flutter/material.dart';

class OopTutorialDefaultParameters extends StatefulWidget {
  const OopTutorialDefaultParameters({super.key});

  @override
  State<OopTutorialDefaultParameters> createState() =>
      _OopTutorialDefaultParametersState();
}

class _OopTutorialDefaultParametersState
    extends State<OopTutorialDefaultParameters> {
  final TextEditingController _codeController = TextEditingController();
  String _executionResult = '';
  bool _isExecuting = false;

  @override
  void initState() {
    super.initState();
    _codeController.text = '''#include <iostream>
#include <string>
using namespace std;

class Calculator {
private:
    string name;
    
public:
    // Constructor with default parameters
    Calculator(string n = "Basic Calculator") : name(n) {
        cout << "Created: " << name << endl;
    }
    
    // Method with default parameters
    int add(int a, int b = 0, int c = 0) {
        return a + b + c;
    }
    
    // Method with mixed parameters
    void display(string message = "Hello", int count = 1) {
        for(int i = 0; i < count; i++) {
            cout << message << " ";
        }
        cout << endl;
    }
    
    // Method with default string parameter
    void greet(string user = "User") {
        cout << "Hello, " << user << "! Welcome to " << name << endl;
    }
};

int main() {
    // Using constructor with default parameter
    Calculator calc1;  // Uses default name
    Calculator calc2("Advanced Calculator");  // Custom name
    
    // Using methods with default parameters
    cout << "Addition with defaults: " << calc1.add(5) << endl;
    cout << "Addition with one default: " << calc1.add(5, 3) << endl;
    cout << "Addition with no defaults: " << calc1.add(5, 3, 2) << endl;
    
    // Using display method with defaults
    calc1.display();  // Uses all defaults
    calc1.display("Hi");  // Custom message, default count
    calc1.display("Wow", 3);  // Custom message and count
    
    // Using greet method
    calc1.greet();  // Uses default user
    calc1.greet("Alice");  // Custom user
    
    return 0;
}''';
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _executeCode() async {
    if (_isExecuting) return;

    setState(() {
      _isExecuting = true;
      _executionResult = '';
    });

    try {
      // Simulate code execution
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _executionResult = '''Created: Basic Calculator
Created: Advanced Calculator
Addition with defaults: 5
Addition with one default: 8
Addition with no defaults: 10
Hello 
Hi 
Wow Wow Wow 
Hello, User! Welcome to Basic Calculator
Hello, Alice! Welcome to Basic Calculator''';
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
        title: const Text('🎯 Default Parameters'),
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.settings, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Default Parameters',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Default parameters allow functions and constructors to have default values when no argument is provided.',
                    ),
                    const SizedBox(height: 8),
                    const Text('Key concepts:'),
                    const SizedBox(height: 4),
                    const Text('• Default parameters provide fallback values'),
                    const Text('• Parameters with defaults must come after those without'),
                    const Text('• Default values are evaluated at call time'),
                    const Text('• Can be used in constructors and methods'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Code Editor
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.code, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Code Editor',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.play_arrow),
                          label: Text(_isExecuting ? 'Running...' : 'Run Code'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _codeController,
                        maxLines: null,
                        expands: true,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'Enter your C++ code here...',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
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
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.play_circle, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Execution Result',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Examples Card
            Card(
              color: Colors.purple[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.purple),
                        const SizedBox(width: 8),
                        Text(
                          'Examples',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.purple[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('1. Constructor with defaults:'),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Calculator calc;  // Uses default name\nCalculator calc("MyCalc");  // Custom name',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                      ),
                    ),
                    const Text('2. Method with defaults:'),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'calc.add(5);        // Uses defaults for b, c\ncalc.add(5, 3);     // Uses default for c\ncalc.add(5, 3, 2);   // No defaults used',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 12),
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
}