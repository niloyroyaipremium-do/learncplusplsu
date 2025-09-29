import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Assumed to be in pubspec.yaml

// --- Mock Services and Models for Demonstration ---

// A mock model for C++ execution results.
class CppExecutionResult {
  final bool success;
  final String output;
  final String error;

  CppExecutionResult({
    required this.success,
    this.output = '',
    this.error = '',
  });
}

// A mock C++ execution service. In a real application, this would be a backend service.
class CppExecutionService {
  static Future<CppExecutionResult> executeCode(String code) async {
    // Simulate a network delay to mimic real-world execution time
    await Future.delayed(const Duration(seconds: 2));

    // Simulate a potential compilation error for demonstration
    if (code.contains("error")) {
      return CppExecutionResult(
        success: false,
        error: 'Compilation Error: Invalid syntax detected.',
      );
    }

    // Simulate successful execution
    return CppExecutionResult(
      success: true,
      // A generic output for demonstration purposes
      output: 'Execution successful.\nHello, World!',
    );
  }
}


// File: Tutorial Navigation Screen - Complete UI Implementation
class TutorialNavigationScreen extends StatefulWidget {
  const TutorialNavigationScreen({super.key});

  @override
  State<TutorialNavigationScreen> createState() =>
      _TutorialNavigationScreenState();
}

class _TutorialNavigationScreenState extends State<TutorialNavigationScreen> {
  bool _isDarkMode = true; // Default to dark mode to match reference
  String _selectedSection = 'C++ HOME';
  // Removed unused fields to fix warnings
  String _executionResult = '';

  @override
  void initState() {
    super.initState();
    _initializeSections();
  }

  void _initializeSections() {
    // Initialize sections - removed unused expansion tracking
    // This method is kept for future use but currently not needed
    // Map<String, List<String>> sections = {
    //   'C++ Variables': [
    //     'Variable Declaration',
    //     'Variable Assignment',
    //     'Variable Types',
    //     'Conditional Logic',
    //   ],
    //   'C++ If...Else': ['if Statement', 'else Statement', 'else if Statement'],
    //   'C++ While Loop': ['while Loop', 'do-while Loop', 'Loop Control'],
    //   'C++ For Loop': ['for Loop', 'Range-based for', 'Nested Loops'],
    //   'C++ Arrays': ['Array Declaration', 'Array Access', 'Array Methods'],
    //   'C++ Structures': ['Struct Definition', 'Struct Members', 'Struct Usage'],
    // };
  }

  String? _getLessonIdForTutorial(String tutorialTitle) {
    // Map tutorial titles to lesson IDs for navigation
    switch (tutorialTitle) {
      case 'C++ HOME':
        return '1';
      case 'C++ Intro':
        return '1';
      // ... other mappings
      default:
        return null; // No mapping found, will show static content
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'C++ Tutorial',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: _isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Sidebar Navigation
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
              border: Border(
                right: BorderSide(
                  color: _isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFE8F4FD),
                    border: Border(
                      bottom: BorderSide(
                        color: _isDarkMode
                            ? Colors.grey[800]!
                            : Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.code, color: Color(0xFF1A73E8), size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'C++ Tutorial',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : const Color(0xFF1A73E8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Navigation List
                Expanded(
                  child: ListView(
                    children: [
                      _buildNavigationItem('C++ HOME', isHome: true),
                      _buildNavigationItem('C++ Intro'),
                      _buildNavigationItem('C++ Get Started'),
                      _buildNavigationItem('C++ Syntax'),
                      _buildNavigationItem('C++ Output'),
                      _buildNavigationItem('C++ Comments'),
                      _buildExpandableItem('C++ Variables'),
                      _buildExpandableItem('C++ Data Types'),
                      _buildExpandableItem('C++ Operators'),
                      _buildNavigationItem('C++ Strings', isSpecial: true),
                      _buildExpandableItem('C++ Booleans'),
                      _buildExpandableItem('C++ If...Else'),
                      _buildNavigationItem('C++ Switch'),
                      _buildNavigationItem('C++ Break/Continue'),
                      _buildExpandableItem('C++ While Loop'),
                      _buildExpandableItem('C++ For Loop'),
                      _buildExpandableItem('C++ Arrays'),
                      _buildExpandableItem('C++ Structures'),
                      _buildNavigationItem('C++ Math'),
                      _buildNavigationItem('C++ User Input', isSelected: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(child: _buildContentArea()),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(
    String title, {
    bool isHome = false,
    bool isSelected = false,
    bool isSpecial = false,
  }) {
    final isActive = _selectedSection == title;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: isHome
            ? const Color(0xFF4CAF50) // Green for HOME
            : isActive
                ? (_isDarkMode
                    ? const Color(0xFF3A3A3A)
                    : const Color(0xFFE8F4FD)) // Grey for selected
                : Colors.transparent,
        borderRadius: BorderRadius.circular(0),
      ),
      child: InkWell(
        onTap: () {
          // The go_router package provides the .go() extension method on BuildContext
          // for declarative navigation. It is assumed to be set up in the app's main file.
          if (isSpecial && title == 'C++ Strings') {
            context.go('/string-tutorial');
          } else {
            String? lessonId = _getLessonIdForTutorial(title);
            if (lessonId != null) {
              context.go('/lesson/$lessonId');
            } else {
              setState(() {
                _selectedSection = title;
              });
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                isHome ? Icons.home : Icons.code,
                color: isHome
                    ? Colors.white
                    : isActive
                        ? (_isDarkMode ? Colors.white : const Color(0xFF1A73E8))
                        : (_isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: isHome
                        ? Colors.white
                        : isActive
                            ? (_isDarkMode ? Colors.white : const Color(0xFF1A73E8))
                            : (_isDarkMode ? Colors.grey[300] : Colors.grey[700]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableItem(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedSection = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.folder_outlined,
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Removed unused _buildSubSection method

  Widget _buildContentArea() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A73E8), Color(0xFF4285F4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A73E8).withOpacity(0.3), // CORRECTED
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedSection,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getSectionDescription(_selectedSection),
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Content Body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainContent(),
                  const SizedBox(height: 24),
                  _buildCodeExample(),
                  const SizedBox(height: 24),
                  if (_executionResult.isNotEmpty) _buildExecutionResult(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSectionDescription(String section) {
    // ... Implementation remains the same
    return 'Learn about $section in C++';
  }

  Widget _buildMainContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        boxShadow: [
          BoxShadow(
            color: (_isDarkMode ? Colors.black : Colors.grey).withOpacity(0.1), // CORRECTED
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getSectionContent(_selectedSection),
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: _isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExample() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        boxShadow: [
          BoxShadow(
            color: (_isDarkMode ? Colors.black : Colors.grey).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Code Example',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final code = _getCodeExample(_selectedSection);
                  final result = await CppExecutionService.executeCode(code);
                  setState(() {
                    _executionResult = result.success ? result.output : result.error;
                  });
                },
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Run'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
              ),
            ),
            child: Text(
              _getCodeExample(_selectedSection),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: _isDarkMode ? Colors.green[300] : Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionResult() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        boxShadow: [
          BoxShadow(
            color: (_isDarkMode ? Colors.black : Colors.grey).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Execution Result',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
              ),
            ),
            child: Text(
              _executionResult,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: _isDarkMode ? Colors.white : Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Removed unused _executeCode method

  String _getCodeExample(String section) {
    switch (section) {
      case 'C++ HOME':
        return '''#include <iostream>
using namespace std;

int main() {
    cout << "Welcome to C++ Learning!" << endl;
    return 0;
}''';
      case 'C++ Intro':
        return '''#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    return 0;
}''';
      case 'C++ Variables':
        return '''#include <iostream>
using namespace std;

int main() {
    int age = 25;
    string name = "John";
    double height = 5.9;
    
    cout << "Name: " << name << endl;
    cout << "Age: " << age << endl;
    cout << "Height: " << height << endl;
    return 0;
}''';
      case 'C++ User Input':
        return '''#include <iostream>
using namespace std;

int main() {
    string name;
    int age;
    
    cout << "Enter your name: ";
    getline(cin, name);
    cout << "Enter your age: ";
    cin >> age;
    
    cout << "Hello " << name << ", you are " << age << " years old." << endl;
    return 0;
}''';
      default:
        return '''#include <iostream>
using namespace std;

int main() {
    cout << "Learning " << section << " in C++!" << endl;
    return 0;
}''';
    }
  }

  String _getSectionContent(String section) {
    switch (section) {
      case 'C++ HOME':
        return 'Welcome to the C++ Learning Platform! This is your starting point for mastering C++ programming. Explore different sections to learn various concepts, from basic syntax to advanced programming techniques.';
      case 'C++ Intro':
        return 'C++ is a powerful, general-purpose programming language. It was developed by Bjarne Stroustrup at Bell Labs in 1979 as an extension of the C language. C++ supports both procedural and object-oriented programming paradigms.';
      case 'C++ Variables':
        return 'Variables are containers for storing data values. In C++, you need to declare a variable before using it. Variables have a data type that determines what kind of data they can store.';
      case 'C++ User Input':
        return 'User input allows your program to interact with users by accepting data from them. In C++, you can use cin to read input from the keyboard. The getline() function is useful for reading strings with spaces.';
      default:
        return 'This section covers $section in detail. Learn the fundamentals and practice with interactive code examples.';
    }
  }
}