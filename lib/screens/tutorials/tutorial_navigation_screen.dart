import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/tutorial_theme.dart';
import '../../widgets/tutorial_widgets.dart';

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
  final String _executionResult = '';
  final Map<String, List<String>> _sections = {};

  @override
  void initState() {
    super.initState();
    _initializeSections();
  }

  void _initializeSections() {
    _sections.addAll({
      'C++ Variables': ['Variable Declaration', 'Variable Types', 'Variable Scope'],
      'C++ Data Types': ['Primitive Types', 'User-defined Types', 'Type Conversion'],
      'C++ Operators': ['Arithmetic Operators', 'Logical Operators', 'Comparison Operators'],
      'C++ If...Else': ['if Statement', 'else Statement', 'else if Statement'],
      'C++ While Loop': ['while Loop', 'do-while Loop', 'Loop Control'],
      'C++ For Loop': ['for Loop', 'Range-based for', 'Nested Loops'],
      'C++ Arrays': ['Array Declaration', 'Array Access', 'Array Methods'],
      'C++ Structures': ['Struct Definition', 'Struct Members', 'Struct Usage'],
    });
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
      backgroundColor: _isDarkMode 
          ? TutorialTheme.darkTutorialBackground 
          : TutorialTheme.lightTutorialBackground,
      appBar: AppBar(
        title: Text(
          'C++ Tutorial',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _isDarkMode 
            ? TutorialTheme.darkTutorialPrimary 
            : TutorialTheme.tutorialPrimary,
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
              color: _isDarkMode 
                  ? TutorialTheme.darkTutorialSurface 
                  : TutorialTheme.lightTutorialSurface,
              border: Border(
                right: BorderSide(
                  color: _isDarkMode 
                      ? Colors.grey[700]! 
                      : Colors.grey[300]!,
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
                    gradient: _isDarkMode 
                        ? TutorialTheme.darkGradient 
                        : TutorialTheme.primaryGradient,
                    border: Border(
                      bottom: BorderSide(
                        color: _isDarkMode
                            ? Colors.grey[700]!
                            : Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.code, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'C++ Tutorial',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Navigation List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      TutorialNavigationItem(
                        title: 'C++ HOME',
                        icon: Icons.home,
                        isSelected: _selectedSection == 'C++ HOME',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ HOME'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Intro',
                        icon: Icons.info_outline,
                        isSelected: _selectedSection == 'C++ Intro',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Intro'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Get Started',
                        icon: Icons.play_arrow,
                        isSelected: _selectedSection == 'C++ Get Started',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Get Started'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Syntax',
                        icon: Icons.code,
                        isSelected: _selectedSection == 'C++ Syntax',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Syntax'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Output',
                        icon: Icons.output,
                        isSelected: _selectedSection == 'C++ Output',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Output'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Comments',
                        icon: Icons.comment,
                        isSelected: _selectedSection == 'C++ Comments',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Comments'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Variables',
                        icon: Icons.variable,
                        isSelected: _selectedSection == 'C++ Variables',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Variables'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Data Types',
                        icon: Icons.category,
                        isSelected: _selectedSection == 'C++ Data Types',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Data Types'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Operators',
                        icon: Icons.add_circle_outline,
                        isSelected: _selectedSection == 'C++ Operators',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Operators'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Strings',
                        icon: Icons.text_fields,
                        isSelected: _selectedSection == 'C++ Strings',
                        isDarkMode: _isDarkMode,
                        onTap: () {
                          context.go('/string-tutorial');
                        },
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Booleans',
                        icon: Icons.toggle_on,
                        isSelected: _selectedSection == 'C++ Booleans',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Booleans'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ If...Else',
                        icon: Icons.help_outline,
                        isSelected: _selectedSection == 'C++ If...Else',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ If...Else'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Switch',
                        icon: Icons.swap_horiz,
                        isSelected: _selectedSection == 'C++ Switch',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Switch'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Break/Continue',
                        icon: Icons.skip_next,
                        isSelected: _selectedSection == 'C++ Break/Continue',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Break/Continue'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ While Loop',
                        icon: Icons.repeat,
                        isSelected: _selectedSection == 'C++ While Loop',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ While Loop'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ For Loop',
                        icon: Icons.loop,
                        isSelected: _selectedSection == 'C++ For Loop',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ For Loop'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Arrays',
                        icon: Icons.view_list,
                        isSelected: _selectedSection == 'C++ Arrays',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Arrays'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Structures',
                        icon: Icons.account_tree,
                        isSelected: _selectedSection == 'C++ Structures',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Structures'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ Math',
                        icon: Icons.calculate,
                        isSelected: _selectedSection == 'C++ Math',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ Math'),
                      ),
                      TutorialNavigationItem(
                        title: 'C++ User Input',
                        icon: Icons.input,
                        isSelected: _selectedSection == 'C++ User Input',
                        isDarkMode: _isDarkMode,
                        onTap: () => _selectSection('C++ User Input'),
                      ),
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

  void _selectSection(String section) {
    setState(() {
      _selectedSection = section;
    });
  }

  // Removed unused _buildSubSection method

  Widget _buildContentArea() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content Header
          TutorialHeader(
            title: _selectedSection,
            subtitle: _getSectionDescription(_selectedSection),
            isDarkMode: _isDarkMode,
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
    return TutorialCard(
      title: 'Overview',
      content: _getSectionContent(_selectedSection),
      icon: Icons.info_outline,
      iconColor: _isDarkMode 
          ? TutorialTheme.darkTutorialPrimary 
          : TutorialTheme.tutorialPrimary,
      isDarkMode: _isDarkMode,
    );
  }

  Widget _buildCodeExample() {
    return TutorialCodeBlock(
      title: 'Code Example',
      code: _getCodeExample(_selectedSection),
      isDarkMode: _isDarkMode,
      onRun: () => _executeCode(),
    );
  }

  Widget _buildExecutionResult() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDarkMode 
            ? TutorialTheme.darkTutorialCard 
            : TutorialTheme.lightTutorialCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDarkMode 
              ? TutorialTheme.darkTutorialPrimary.withOpacity(0.3)
              : TutorialTheme.tutorialPrimary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Execution Result',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isDarkMode 
                  ? TutorialTheme.darkTutorialPrimary 
                  : TutorialTheme.tutorialPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _executionResult,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _executeCode() async {
    // Simulate code execution
    final result = await CppExecutionService.executeCode(_getCodeExample(_selectedSection));
    setState(() {
      // Update execution result state
    });
  }

  String _getCodeExample(String section) {
    switch (section) {
      case 'C++ HOME':
        return '''#include <iostream>
using namespace std;

int main() {
    cout << "Welcome to C++ Programming!" << endl;
    cout << "Let's start learning C++ together!" << endl;
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
      default:
        return '''#include <iostream>
using namespace std;

int main() {
    cout << "Learning " << "$section" << " in C++!" << endl;
    return 0;
}''';
    }
  }

  String _getSectionContent(String section) {
    switch (section) {
      case 'C++ HOME':
        return 'Welcome to the C++ Tutorial! This comprehensive guide will take you through all the essential concepts of C++ programming, from basic syntax to advanced topics. Each section includes detailed explanations, code examples, and interactive exercises to help you master C++ programming.';
      case 'C++ Intro':
        return 'C++ is a powerful, general-purpose programming language that was developed by Bjarne Stroustrup at Bell Labs in 1979. It is an extension of the C programming language and includes object-oriented programming features. C++ is widely used for system software, game development, and high-performance applications.';
      case 'C++ Variables':
        return 'Variables in C++ are containers for storing data values. They have a specific data type and can hold different kinds of information. Variables must be declared before they can be used, and they can be modified throughout the program execution. Understanding variables is fundamental to C++ programming.';
      case 'C++ Data Types':
        return 'C++ supports various data types including primitive types (int, char, float, double, bool) and user-defined types (classes, structures, unions). Each data type has a specific size and range of values it can store. Choosing the right data type is important for efficient memory usage and program performance.';
      case 'C++ Operators':
        return 'Operators in C++ are symbols that perform operations on variables and values. They include arithmetic operators (+, -, *, /), comparison operators (==, !=, <, >), logical operators (&&, ||, !), and assignment operators (=, +=, -=). Understanding operators is crucial for writing expressions and controlling program flow.';
      case 'C++ Strings':
        return 'Strings in C++ are sequences of characters used to store and manipulate text data. C++ provides the string class which offers many useful methods for string operations like concatenation, searching, and modification. Strings are essential for handling user input and text processing.';
      default:
        return 'This section covers $section in detail. You will learn the fundamental concepts, syntax, and best practices for using $section in your C++ programs. Each topic includes practical examples and exercises to reinforce your understanding.';
    }
  }
}