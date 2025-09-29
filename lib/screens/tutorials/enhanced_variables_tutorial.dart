// Enhanced C++ Variables Tutorial with new theme
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_provider.dart';
import '../../core/theme/tutorial_theme.dart';
import '../../widgets/tutorial_widgets.dart';

class EnhancedCppVariablesTutorial extends StatefulWidget {
  const EnhancedCppVariablesTutorial({super.key});

  @override
  State<EnhancedCppVariablesTutorial> createState() => _EnhancedCppVariablesTutorialState();
}

class _EnhancedCppVariablesTutorialState extends State<EnhancedCppVariablesTutorial>
    with TickerProviderStateMixin {
  late TabController _tabController;
  double _fontSize = 16.0;

  final List<VariableTutorialSection> _tutorialSections = [
    VariableTutorialSection(
      title: "🔢 Variable Basics",
      subtitle: "Understanding what variables are and how to use them!",
      content: "A variable in C++ is a named storage location in memory that holds a value. Think of it as a labeled box where you can store different types of data that your program can use and modify!",
    ),
    VariableTutorialSection(
      title: "📝 Variable Declaration",
      subtitle: "Different ways to declare and initialize variables!",
      content: "Variables in C++ can be declared in several ways. You can declare them first and assign values later, or declare and initialize them at the same time.",
    ),
    VariableTutorialSection(
      title: "🏷️ Data Types",
      subtitle: "Understanding different data types for variables!",
      content: "C++ provides several built-in data types to store different kinds of values. Each data type has a specific size and range of values it can hold.",
    ),
    VariableTutorialSection(
      title: "🌐 Variable Scope",
      subtitle: "Understanding where variables can be used!",
      content: "Variable scope determines where in your program a variable can be accessed. Understanding scope is crucial for writing maintainable code.",
    ),
    VariableTutorialSection(
      title: "🔒 Constants",
      subtitle: "Creating variables that cannot be changed!",
      content: "Constants are variables whose values cannot be changed after initialization. They are useful for storing values that should remain fixed throughout the program.",
    ),
    VariableTutorialSection(
      title: "💡 Variable Examples",
      subtitle: "Real-world examples and practice problems!",
      content: "Let's look at practical examples of how variables are used in real C++ programs.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tutorialSections.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final isDarkMode = appProvider.themeMode == ThemeMode.dark;
        
        return Scaffold(
          backgroundColor: isDarkMode 
              ? TutorialTheme.darkTutorialBackground 
              : TutorialTheme.lightTutorialBackground,
          appBar: AppBar(
            title: Text(
              '🔢 C++ Variables Tutorial',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            backgroundColor: isDarkMode 
                ? TutorialTheme.darkTutorialPrimary 
                : TutorialTheme.tutorialPrimary,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _fontSize = _fontSize == 16.0 ? 20.0 : 16.0;
                  });
                },
                icon: Icon(_fontSize == 16.0 ? Icons.zoom_in : Icons.zoom_out),
                tooltip: 'Adjust Font Size',
              ),
            ],
            bottom: TutorialTabBar(
              controller: _tabController,
              tabs: _tutorialSections.map((section) => section.title.split(' ')[1]).toList(),
              isDarkMode: isDarkMode,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: _tutorialSections.map((section) => _buildSectionContent(section, isDarkMode)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildSectionContent(VariableTutorialSection section, bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          TutorialHeader(
            title: section.title,
            subtitle: section.subtitle,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 24),
          
          // Info card
          TutorialCard(
            title: 'Overview',
            content: section.content,
            icon: Icons.info_outline,
            iconColor: TutorialTheme.tutorialInfo,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 20),
          
          // Code example
          TutorialCodeBlock(
            title: '💻 Code Example',
            code: _getCodeExample(section.title),
            isDarkMode: isDarkMode,
            fontSize: _fontSize,
            onRun: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Code executed successfully! 🎉'),
                  backgroundColor: TutorialTheme.tutorialSuccess,
                ),
              );
            },
            onCopy: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Code copied to clipboard! 📋'),
                  backgroundColor: TutorialTheme.tutorialInfo,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          
          // Key points
          _buildKeyPoints(section.title, isDarkMode),
        ],
      ),
    );
  }

  String _getCodeExample(String title) {
    switch (title) {
      case "🔢 Variable Basics":
        return '''#include <iostream>
using namespace std;

int main() {
    // Declaring variables
    int age = 25;
    string name = "Alice";
    double height = 5.6;
    
    // Using variables
    cout << "Name: " << name << endl;
    cout << "Age: " << age << endl;
    cout << "Height: " << height << " feet" << endl;
    
    // Modifying variables
    age = age + 1;
    cout << "Next year, age will be: " << age << endl;
    
    return 0;
}''';
      case "📝 Variable Declaration":
        return '''#include <iostream>
using namespace std;

int main() {
    // Method 1: Declare then assign
    int number;
    number = 42;
    
    // Method 2: Declare and initialize
    int count = 10;
    
    // Method 3: Multiple variables
    int x = 5, y = 10, z = 15;
    
    // Method 4: Using auto keyword
    auto name = "John";  // string
    auto age = 25;       // int
    
    cout << "Number: " << number << endl;
    cout << "Count: " << count << endl;
    cout << "x=" << x << ", y=" << y << ", z=" << z << endl;
    cout << "Name: " << name << ", Age: " << age << endl;
    
    return 0;
}''';
      case "🏷️ Data Types":
        return '''#include <iostream>
using namespace std;

int main() {
    // Integer types
    int age = 25;
    short smallNumber = 100;
    long bigNumber = 1000000;
    
    // Floating point types
    float price = 19.99f;
    double pi = 3.14159265359;
    
    // Character type
    char grade = 'A';
    
    // Boolean type
    bool isStudent = true;
    
    // String type
    string name = "Alice";
    
    cout << "Age: " << age << endl;
    cout << "Price: $" << price << endl;
    cout << "Pi: " << pi << endl;
    cout << "Grade: " << grade << endl;
    cout << "Is Student: " << isStudent << endl;
    cout << "Name: " << name << endl;
    
    return 0;
}''';
      case "🌐 Variable Scope":
        return '''#include <iostream>
using namespace std;

int globalVar = 100;  // Global variable

int main() {
    int localVar = 50;  // Local variable
    
    cout << "Global variable: " << globalVar << endl;
    cout << "Local variable: " << localVar << endl;
    
    {
        int blockVar = 25;  // Block scope variable
        cout << "Block variable: " << blockVar << endl;
        cout << "Local variable (inside block): " << localVar << endl;
    }
    
    // blockVar is not accessible here
    // cout << blockVar;  // This would cause an error
    
    return 0;
}''';
      case "🔒 Constants":
        return '''#include <iostream>
using namespace std;

int main() {
    // Method 1: const keyword
    const int MAX_SIZE = 100;
    const double PI = 3.14159;
    const string APP_NAME = "MyApp";
    
    // Method 2: #define preprocessor
    #define MAX_USERS 50
    
    // Method 3: constexpr (C++11)
    constexpr int BUFFER_SIZE = 1024;
    
    cout << "Max size: " << MAX_SIZE << endl;
    cout << "Pi: " << PI << endl;
    cout << "App name: " << APP_NAME << endl;
    cout << "Max users: " << MAX_USERS << endl;
    cout << "Buffer size: " << BUFFER_SIZE << endl;
    
    // These would cause compilation errors:
    // MAX_SIZE = 200;  // Error: cannot modify const
    // PI = 3.14;       // Error: cannot modify const
    
    return 0;
}''';
      case "💡 Variable Examples":
        return '''#include <iostream>
using namespace std;

int main() {
    // Variable declarations
    int age = 25;
    double height = 5.9;
    char grade = 'A';
    string name = "John";
    bool isEmployed = true;
    int count = 10;
    double price = 99.99;
    string message = "Hello, World!";
    
    // Display variables
    cout << "Name: " << name << endl;
    cout << "Age: " << age << endl;
    cout << "Height: " << height << " feet" << endl;
    cout << "Grade: " << grade << endl;
    cout << "Employed: " << isEmployed << endl;
    cout << "Count: " << count << endl;
    cout << "Price: " << price << endl;
    cout << "Message: " << message << endl;
    
    return 0;
}''';
      default:
        return '''#include <iostream>
using namespace std;

int main() {
    cout << "Learning C++ Variables!" << endl;
    return 0;
}''';
    }
  }

  Widget _buildKeyPoints(String sectionTitle, bool isDarkMode) {
    List<String> keyPoints = [];
    
    switch (sectionTitle) {
      case "🔢 Variable Basics":
        keyPoints = [
          "Variables store data in memory",
          "Must be declared before use",
          "Have a data type (int, string, double, etc.)",
          "Can be modified after declaration",
          "Have a name that identifies them",
          "Hold values that can change during program execution"
        ];
        break;
      case "📝 Variable Declaration":
        keyPoints = [
          "Declare first, assign later: int x; x = 5;",
          "Declare and initialize: int x = 5;",
          "Multiple variables: int x = 5, y = 10;",
          "Use auto keyword for type inference",
          "Choose meaningful variable names",
          "Initialize variables to avoid undefined behavior"
        ];
        break;
      case "🏷️ Data Types":
        keyPoints = [
          "int: whole numbers (-2,147,483,648 to 2,147,483,647)",
          "double: decimal numbers with high precision",
          "float: decimal numbers with lower precision",
          "char: single character ('a', 'Z', '5')",
          "bool: true or false values",
          "string: sequence of characters"
        ];
        break;
      case "🌐 Variable Scope":
        keyPoints = [
          "Global scope: accessible throughout the program",
          "Local scope: accessible only within the function",
          "Block scope: accessible only within the block {}",
          "Variables hide outer scope variables with same name",
          "Use meaningful names to avoid confusion",
          "Minimize global variables for better code organization"
        ];
        break;
      case "🔒 Constants":
        keyPoints = [
          "const: value cannot be changed after initialization",
          "#define: preprocessor constant",
          "constexpr: compile-time constant (C++11)",
          "Use UPPERCASE names for constants",
          "Constants improve code readability",
          "Constants prevent accidental modifications"
        ];
        break;
      case "💡 Variable Examples":
        keyPoints = [
          "Practice with different data types",
          "Try modifying variable values",
          "Experiment with variable scope",
          "Use variables in calculations",
          "Combine variables in expressions",
          "Test your understanding with exercises"
        ];
        break;
    }

    return TutorialCard(
      title: '🔑 Key Points',
      content: keyPoints.map((point) => '• $point').join('\n'),
      icon: Icons.lightbulb_outline,
      iconColor: TutorialTheme.tutorialWarning,
      isDarkMode: isDarkMode,
    );
  }
}

class VariableTutorialSection {
  final String title;
  final String subtitle;
  final String content;

  VariableTutorialSection({
    required this.title,
    required this.subtitle,
    required this.content,
  });
}