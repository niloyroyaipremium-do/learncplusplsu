import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class CppVariablesTutorial extends StatefulWidget {
  const CppVariablesTutorial({super.key});

  @override
  State<CppVariablesTutorial> createState() => _CppVariablesTutorialState();
}

class _CppVariablesTutorialState extends State<CppVariablesTutorial>
    with TickerProviderStateMixin {
  late TabController _tabController;
  double _fontSize = 16.0;

  final String _defaultCode = '''#include <iostream>
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

  final List<VariableTutorialSection> _tutorialSections = [
    VariableTutorialSection(
      title: "?? Variable Basics",
      subtitle: "Understanding what variables are and how to use them!",
      content: "A variable in C++ is a named storage location in memory that holds a value. Think of it as a labeled box where you can store different types of data that your program can use and modify!",
    ),
    VariableTutorialSection(
      title: "?? Variable Declaration",
      subtitle: "Different ways to declare and initialize variables!",
      content: "Variables in C++ can be declared in several ways. You can declare them first and assign values later, or declare and initialize them at the same time.",
    ),
    VariableTutorialSection(
      title: "?? Data Types",
      subtitle: "Understanding different data types for variables!",
      content: "C++ provides several built-in data types to store different kinds of values. Each data type has a specific size and range of values it can hold.",
    ),
    VariableTutorialSection(
      title: "?? Variable Scope",
      subtitle: "Understanding where variables can be used!",
      content: "Variable scope determines where in your program a variable can be accessed. Understanding scope is crucial for writing maintainable code.",
    ),
    VariableTutorialSection(
      title: "? Constants",
      subtitle: "Creating variables that cannot be changed!",
      content: "Constants are variables whose values cannot be changed after initialization. They are useful for storing values that should remain fixed throughout the program.",
    ),
    VariableTutorialSection(
      title: "?? Variable Examples",
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
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
          appBar: AppBar(
            title: const Text(
              'C++ Variables Tutorial',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.blue[600],
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
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: _tutorialSections.map((section) => Tab(
                text: section.title.split(' ')[1], // Remove emoji
              )).toList(),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            section.title,
            section.content,
            isDarkMode,
          ),
          const SizedBox(height: 20),
          _buildCodeExample(
            "?? Code Example",
            _getCodeExample(section.title),
            isDarkMode,
          ),
          const SizedBox(height: 20),
          _buildKeyPoints(section.title, isDarkMode),
        ],
      ),
    );
  }

  String _getCodeExample(String title) {
    switch (title) {
      case "?? Variable Basics":
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
      case "?? Variable Declaration":
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
      case "?? Data Types":
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
      case "?? Variable Scope":
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
      case "? Constants":
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
      case "?? Variable Examples":
        return _defaultCode;
      default:
        return _defaultCode;
    }
  }

  Widget _buildInfoCard(String title, String content, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: _fontSize,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExample(String title, String code, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                code,
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: _fontSize,
                  color: isDarkMode ? Colors.green[400] : Colors.green[800],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyPoints(String sectionTitle, bool isDarkMode) {
    List<String> keyPoints = [];
    
    switch (sectionTitle) {
      case "?? Variable Basics":
        keyPoints = [
          "Variables store data in memory",
          "Must be declared before use",
          "Have a data type (int, string, double, etc.)",
          "Can be modified after declaration",
          "Have a name that identifies them",
          "Hold values that can change during program execution"
        ];
        break;
      case "?? Variable Declaration":
        keyPoints = [
          "Declare first, assign later: int x; x = 5;",
          "Declare and initialize: int x = 5;",
          "Multiple variables: int x = 5, y = 10;",
          "Use auto keyword for type inference",
          "Choose meaningful variable names",
          "Initialize variables to avoid undefined behavior"
        ];
        break;
      case "?? Data Types":
        keyPoints = [
          "int: whole numbers (-2,147,483,648 to 2,147,483,647)",
          "double: decimal numbers with high precision",
          "float: decimal numbers with lower precision",
          "char: single character ('a', 'Z', '5')",
          "bool: true or false values",
          "string: sequence of characters"
        ];
        break;
      case "?? Variable Scope":
        keyPoints = [
          "Global scope: accessible throughout the program",
          "Local scope: accessible only within the function",
          "Block scope: accessible only within the block {}",
          "Variables hide outer scope variables with same name",
          "Use meaningful names to avoid confusion",
          "Minimize global variables for better code organization"
        ];
        break;
      case "? Constants":
        keyPoints = [
          "const: value cannot be changed after initialization",
          "#define: preprocessor constant",
          "constexpr: compile-time constant (C++11)",
          "Use UPPERCASE names for constants",
          "Constants improve code readability",
          "Constants prevent accidental modifications"
        ];
        break;
      case "?? Variable Examples":
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.blue[900] : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.blue[700]! : Colors.blue[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "?? Key Points",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...keyPoints.map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "• ",
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    point,
                    style: TextStyle(
                      fontSize: _fontSize,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
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
