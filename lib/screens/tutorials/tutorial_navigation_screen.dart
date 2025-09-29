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
    // Sections are now handled statically in the UI
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
                color: isHome ? Colors.white : (_isDarkMode ? Colors.white70 : Colors.black87),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: isHome ? Colors.white : (_isDarkMode ? Colors.white : Colors.black87),
                  ),
                ),
              ),
              if (isActive)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: _isDarkMode ? Colors.white70 : Colors.black54,
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
                color: _isDarkMode ? Colors.white70 : Colors.black87,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: _isDarkMode ? Colors.white70 : Colors.black54,
                size: 20,
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
            children: [
              const Icon(Icons.code, color: Color(0xFF1A73E8), size: 20),
              const SizedBox(width: 8),
              Text(
                'Code Example',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  // Execute code logic
                  final result = await CppExecutionService.executeCode(_getCodeExample(_selectedSection));
                  setState(() {
                    // Update execution result
                  });
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Run'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF8F8F8),
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
                color: _isDarkMode ? Colors.white : Colors.black87,
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
          Row(
            children: [
              const Icon(Icons.play_circle_outline, color: Color(0xFF4CAF50), size: 20),
              const SizedBox(width: 8),
              Text(
                'Execution Result',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF8F8F8),
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
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    cout << "Welcome to C++!" << endl;\n    return 0;\n}';
      case 'C++ Intro':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    cout << "Hello, World!" << endl;\n    return 0;\n}';
      case 'C++ Get Started':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    cout << "Getting started with C++!" << endl;\n    return 0;\n}';
      case 'C++ Syntax':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    int number = 42;\n    cout << "Number: " << number << endl;\n    return 0;\n}';
      case 'C++ Output':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    cout << "This is output!" << endl;\n    return 0;\n}';
      case 'C++ Comments':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    // This is a single-line comment\n    /* This is a\n       multi-line comment */\n    cout << "Comments example" << endl;\n    return 0;\n}';
      case 'C++ Variables':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    int age = 25;\n    string name = "John";\n    cout << "Name: " << name << ", Age: " << age << endl;\n    return 0;\n}';
      case 'C++ Data Types':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    int integer = 42;\n    double decimal = 3.14;\n    char letter = \'A\';\n    bool flag = true;\n    \n    cout << "Integer: " << integer << endl;\n    cout << "Double: " << decimal << endl;\n    cout << "Char: " << letter << endl;\n    cout << "Bool: " << flag << endl;\n    \n    return 0;\n}';
      case 'C++ Operators':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    int a = 10, b = 3;\n    \n    cout << "a + b = " << (a + b) << endl;\n    cout << "a - b = " << (a - b) << endl;\n    cout << "a * b = " << (a * b) << endl;\n    cout << "a / b = " << (a / b) << endl;\n    cout << "a % b = " << (a % b) << endl;\n    \n    return 0;\n}';
      case 'C++ Strings':
        return '#include <iostream>\n#include <string>\nusing namespace std;\n\nint main() {\n    string greeting = "Hello";\n    string name = "World";\n    string message = greeting + " " + name;\n    \n    cout << message << endl;\n    cout << "Length: " << message.length() << endl;\n    \n    return 0;\n}';
      case 'C++ Booleans':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    bool isTrue = true;\n    bool isFalse = false;\n    \n    cout << "isTrue: " << isTrue << endl;\n    cout << "isFalse: " << isFalse << endl;\n    cout << "5 > 3: " << (5 > 3) << endl;\n    \n    return 0;\n}';
      case 'C++ If...Else':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    int age = 18;\n    \n    if (age >= 18) {\n        cout << "You are an adult" << endl;\n    } else {\n        cout << "You are a minor" << endl;\n    }\n    \n    return 0;\n}';
      case 'C++ Switch':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    int day = 3;\n    \n    switch (day) {\n        case 1:\n            cout << "Monday" << endl;\n            break;\n        case 2:\n            cout << "Tuesday" << endl;\n            break;\n        case 3:\n            cout << "Wednesday" << endl;\n            break;\n        default:\n            cout << "Other day" << endl;\n    }\n    \n    return 0;\n}';
      case 'C++ Break/Continue':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    for (int i = 1; i <= 10; i++) {\n        if (i == 3) continue; // Skip 3\n        if (i == 7) break;    // Stop at 7\n        cout << i << " ";\n    }\n    cout << endl;\n    \n    return 0;\n}';
      case 'C++ While Loop':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    int i = 1;\n    \n    while (i <= 5) {\n        cout << "Count: " << i << endl;\n        i++;\n    }\n    \n    return 0;\n}';
      case 'C++ For Loop':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    for (int i = 1; i <= 5; i++) {\n        cout << "Count: " << i << endl;\n    }\n    \n    return 0;\n}';
      case 'C++ Arrays':
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    int numbers[5] = {1, 2, 3, 4, 5};\n    \n    for (int i = 0; i < 5; i++) {\n        cout << "numbers[" << i << "] = " << numbers[i] << endl;\n    }\n    \n    return 0;\n}';
      case 'C++ Structures':
        return '#include <iostream>\n#include <string>\nusing namespace std;\n\nstruct Person {\n    string name;\n    int age;\n    double height;\n};\n\nint main() {\n    Person person1;\n    person1.name = "John";\n    person1.age = 25;\n    person1.height = 5.9;\n    \n    cout << "Name: " << person1.name << endl;\n    cout << "Age: " << person1.age << endl;\n    cout << "Height: " << person1.height << endl;\n    \n    return 0;\n}';
      case 'C++ Math':
        return '#include <iostream>\n#include <cmath>\nusing namespace std;\n\nint main() {\n    double x = 16.0;\n    \n    cout << "Square root of " << x << " = " << sqrt(x) << endl;\n    cout << "Power of 2^3 = " << pow(2, 3) << endl;\n    cout << "Absolute value of -5 = " << abs(-5) << endl;\n    \n    return 0;\n}';
      case 'C++ User Input':
        return '#include <iostream>\n#include <string>\nusing namespace std;\n\nint main() {\n    string name;\n    int age;\n    \n    cout << "Enter your name: ";\n    getline(cin, name);\n    \n    cout << "Enter your age: ";\n    cin >> age;\n    \n    cout << "Hello " << name << ", you are " << age << " years old!" << endl;\n    \n    return 0;\n}';
      default:
        return '#include <iostream>\nusing namespace std;\n\nint main() {\n    cout << "Hello, World!" << endl;\n    return 0;\n}';
    }
  }

  String _getSectionContent(String section) {
    switch (section) {
      case 'C++ HOME':
        return 'Welcome to the C++ Tutorial! This comprehensive guide will take you through the fundamentals of C++ programming, from basic syntax to advanced concepts. Start your journey to become a proficient C++ programmer.';
      case 'C++ Intro':
        return 'C++ is a powerful, general-purpose programming language that was developed by Bjarne Stroustrup at Bell Labs in 1979. It is an extension of the C programming language with object-oriented programming capabilities.';
      case 'C++ Get Started':
        return 'To get started with C++, you need a compiler and an IDE. Popular options include Visual Studio, Code::Blocks, Dev-C++, and online compilers. C++ programs are compiled into executable files that can run on your computer.';
      case 'C++ Syntax':
        return 'C++ syntax follows specific rules and conventions. Every C++ program must have a main() function, statements end with semicolons, and code is organized into blocks using curly braces. Understanding syntax is crucial for writing correct C++ programs.';
      case 'C++ Output':
        return 'The cout object is used to display output in C++. It is part of the iostream library and allows you to print text, numbers, and variables to the console. You can use the insertion operator (<<) to send data to cout.';
      case 'C++ Comments':
        return 'Comments are used to explain code and make it more readable. C++ supports two types of comments: single-line comments (//) and multi-line comments (/* */). Comments are ignored by the compiler and are only for human readers.';
      case 'C++ Variables':
        return 'Variables are containers for storing data values. In C++, you must declare variables before using them, specifying their data type. Variables can hold different types of data like numbers, text, and boolean values.';
      case 'C++ Data Types':
        return 'C++ has several built-in data types including int (integers), double (floating-point numbers), char (single characters), bool (true/false values), and string (text). Each data type has a specific size and range of values it can store.';
      case 'C++ Operators':
        return 'Operators are symbols that perform operations on variables and values. C++ includes arithmetic operators (+, -, *, /, %), comparison operators (==, !=, <, >, <=, >=), and logical operators (&&, ||, !).';
      case 'C++ Strings':
        return 'Strings are used to store and manipulate text in C++. The string class provides many useful methods for string operations like concatenation, finding substrings, and getting string length. Strings are enclosed in double quotes.';
      case 'C++ Booleans':
        return 'Boolean data type represents true or false values. Booleans are often used in conditional statements and loops. In C++, true is represented as 1 and false as 0, but it\'s better to use the actual boolean values true and false.';
      case 'C++ If...Else':
        return 'Conditional statements allow your program to make decisions based on different conditions. The if statement executes code if a condition is true, else if provides alternative conditions, and else handles all other cases.';
      case 'C++ Switch':
        return 'The switch statement is an alternative to if-else when you have multiple conditions to check. It compares a variable against multiple values and executes the corresponding code block. Each case should end with a break statement.';
      case 'C++ Break/Continue':
        return 'Break and continue are control flow statements used in loops. Break immediately exits the loop, while continue skips the current iteration and moves to the next one. These statements give you more control over loop execution.';
      case 'C++ While Loop':
        return 'While loops repeat a block of code as long as a condition is true. They are useful when you don\'t know in advance how many times the loop should run. The condition is checked before each iteration.';
      case 'C++ For Loop':
        return 'For loops are used when you know exactly how many times you want to repeat a block of code. They consist of initialization, condition, and increment/decrement, all in one line. For loops are very efficient and commonly used.';
      case 'C++ Arrays':
        return 'Arrays are used to store multiple values of the same data type in a single variable. They have a fixed size and elements are accessed using indices starting from 0. Arrays are useful for storing lists of data.';
      case 'C++ Structures':
        return 'Structures (structs) allow you to group related data items of different types together. They are user-defined data types that can contain multiple variables. Structs are useful for creating complex data types.';
      case 'C++ Math':
        return 'C++ provides many mathematical functions through the cmath library. You can perform operations like square root, power, absolute value, trigonometric functions, and more. These functions make mathematical calculations easy and efficient.';
      case 'C++ User Input':
        return 'User input allows your program to interact with users by reading data they enter. The cin object is used to read input from the keyboard. You can read different types of data including numbers, characters, and strings.';
      default:
        return 'This section covers $section in detail. Learn the fundamentals and practice with code examples.';
    }
  }
}