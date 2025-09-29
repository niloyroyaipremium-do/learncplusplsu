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
  final String _executionResult = '';

  @override
  void initState() {
    super.initState();
    _initializeSections();
  }

  void _initializeSections() {
    // Initialize sections - removed unused expansion tracking
    // This method is kept for future use but currently not needed
    // Sections can be expanded here if needed in the future
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
              Text(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableItem(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(0),
      ),
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
                Icons.expand_more,
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
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
                  color: const Color(0xFF1A73E8).withValues(alpha: 0.3),
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
            color: (_isDarkMode ? Colors.black : Colors.grey).withValues(alpha: 0.1),
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
            color: (_isDarkMode ? Colors.black : Colors.grey).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Code Example',
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
              _getCodeExample(_selectedSection),
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                color: _isDarkMode ? Colors.green[300] : Colors.green[700],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  // Execute code logic would go here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Code executed successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Run Code'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {
                  // Copy code logic would go here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Code copied to clipboard!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy'),
              ),
            ],
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
            color: (_isDarkMode ? Colors.black : Colors.grey).withValues(alpha: 0.1),
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
                fontSize: 14,
                fontFamily: 'monospace',
                color: _isDarkMode ? Colors.green[300] : Colors.green[700],
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
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    cout << "Welcome to C++ Learning!" << endl;\n    return 0;\n}';
      case 'C++ Intro':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    cout << "Hello, World!" << endl;\n    return 0;\n}';
      case 'C++ Variables':
        return 'int age = 25;\nstring name = "John";\ndouble height = 5.9;\nbool isStudent = true;';
      case 'C++ Data Types':
        return 'int number = 42;\nfloat decimal = 3.14f;\ndouble precise = 3.14159;\nchar letter = \'A\';\nbool flag = true;';
      default:
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    cout << "Learning $section" << endl;\n    return 0;\n}';
    }
  }

  String _getSectionContent(String section) {
    switch (section) {
      case 'C++ HOME':
        return 'Welcome to the C++ Learning Platform! This is your central hub for mastering C++ programming. Explore different topics, practice coding, and track your progress.';
      case 'C++ Intro':
        return 'C++ is a powerful programming language that extends C with object-oriented features. It\'s widely used in system programming, game development, and high-performance applications.';
      case 'C++ Variables':
        return 'Variables are containers for storing data values. In C++, you need to declare the type of data a variable will hold before using it.';
      case 'C++ Data Types':
        return 'C++ has several built-in data types including integers, floating-point numbers, characters, and booleans. Each type has different memory requirements and value ranges.';
      default:
        return 'This section covers $section in detail. Learn the fundamentals and practice with interactive examples.';
    }
  }
}