// Enhanced C++ Data Types Tutorial with new theme
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/tutorial_theme.dart';
import '../../widgets/tutorial_widgets.dart';

class EnhancedCppDataTypesTutorial extends StatefulWidget {
  const EnhancedCppDataTypesTutorial({super.key});

  @override
  State<EnhancedCppDataTypesTutorial> createState() => _EnhancedCppDataTypesTutorialState();
}

class _EnhancedCppDataTypesTutorialState extends State<EnhancedCppDataTypesTutorial>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isDarkMode = true;
  double _fontSize = 16.0;

  final List<DataTypeTutorialSection> _tutorialSections = [
    DataTypeTutorialSection(
      title: "🔢 Basic Data Types",
      subtitle: "Understanding fundamental data types in C++!",
      content: "C++ provides several built-in data types to store different kinds of values. Each data type has a specific size and range of values it can hold.",
    ),
    DataTypeTutorialSection(
      title: "📏 Integer Types",
      subtitle: "Different integer types and their ranges!",
      content: "Integer types are used to store whole numbers. C++ provides several integer types with different sizes and ranges.",
    ),
    DataTypeTutorialSection(
      title: "🔢 Floating Point",
      subtitle: "Decimal numbers and precision!",
      content: "Floating-point types are used to store decimal numbers. They provide different levels of precision.",
    ),
    DataTypeTutorialSection(
      title: "📝 Character Types",
      subtitle: "Working with characters and text!",
      content: "Character types are used to store individual characters and strings of text.",
    ),
    DataTypeTutorialSection(
      title: "✅ Boolean Type",
      subtitle: "True and false values!",
      content: "Boolean type is used to store logical values - either true or false.",
    ),
    DataTypeTutorialSection(
      title: "🎯 Type Conversion",
      subtitle: "Converting between different data types!",
      content: "Type conversion allows you to convert values from one data type to another.",
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
    return Scaffold(
      backgroundColor: _isDarkMode 
          ? TutorialTheme.darkTutorialBackground 
          : TutorialTheme.lightTutorialBackground,
      appBar: AppBar(
        title: Text(
          '🏷️ C++ Data Types Tutorial',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
          isDarkMode: _isDarkMode,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tutorialSections.map((section) => _buildSectionContent(section)).toList(),
      ),
    );
  }

  Widget _buildSectionContent(DataTypeTutorialSection section) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          TutorialHeader(
            title: section.title,
            subtitle: section.subtitle,
            isDarkMode: _isDarkMode,
          ),
          const SizedBox(height: 24),
          
          // Info card
          TutorialCard(
            title: 'Overview',
            content: section.content,
            icon: Icons.info_outline,
            iconColor: TutorialTheme.tutorialInfo,
            isDarkMode: _isDarkMode,
          ),
          const SizedBox(height: 20),
          
          // Code example
          TutorialCodeBlock(
            title: '💻 Code Example',
            code: _getCodeExample(section.title),
            isDarkMode: _isDarkMode,
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
          _buildKeyPoints(section.title),
        ],
      ),
    );
  }

  String _getCodeExample(String title) {
    switch (title) {
      case "🔢 Basic Data Types":
        return '''#include <iostream>
using namespace std;

int main() {
    // Basic data types
    int age = 25;
    double height = 5.9;
    char grade = 'A';
    bool isStudent = true;
    string name = "Alice";
    
    cout << "Name: " << name << endl;
    cout << "Age: " << age << endl;
    cout << "Height: " << height << endl;
    cout << "Grade: " << grade << endl;
    cout << "Is Student: " << isStudent << endl;
    
    return 0;
}''';
      case "📏 Integer Types":
        return '''#include <iostream>
using namespace std;

int main() {
    // Different integer types
    short smallNum = 100;
    int normalNum = 1000000;
    long bigNum = 1000000000L;
    long long hugeNum = 1000000000000LL;
    
    cout << "Short: " << smallNum << endl;
    cout << "Int: " << normalNum << endl;
    cout << "Long: " << bigNum << endl;
    cout << "Long Long: " << hugeNum << endl;
    
    // Size of each type
    cout << "Size of short: " << sizeof(short) << " bytes" << endl;
    cout << "Size of int: " << sizeof(int) << " bytes" << endl;
    cout << "Size of long: " << sizeof(long) << " bytes" << endl;
    cout << "Size of long long: " << sizeof(long long) << " bytes" << endl;
    
    return 0;
}''';
      case "🔢 Floating Point":
        return '''#include <iostream>
#include <iomanip>
using namespace std;

int main() {
    // Floating point types
    float price = 19.99f;
    double pi = 3.14159265359;
    long double precise = 3.141592653589793238L;
    
    cout << fixed << setprecision(2);
    cout << "Price: $" << price << endl;
    cout << setprecision(10);
    cout << "Pi (double): " << pi << endl;
    cout << setprecision(15);
    cout << "Pi (long double): " << precise << endl;
    
    // Size of each type
    cout << "Size of float: " << sizeof(float) << " bytes" << endl;
    cout << "Size of double: " << sizeof(double) << " bytes" << endl;
    cout << "Size of long double: " << sizeof(long double) << " bytes" << endl;
    
    return 0;
}''';
      case "📝 Character Types":
        return '''#include <iostream>
using namespace std;

int main() {
    // Character types
    char letter = 'A';
    char digit = '5';
    char symbol = '@';
    
    // String type
    string name = "Hello World";
    string message = "C++ Programming";
    
    cout << "Letter: " << letter << endl;
    cout << "Digit: " << digit << endl;
    cout << "Symbol: " << symbol << endl;
    cout << "Name: " << name << endl;
    cout << "Message: " << message << endl;
    
    // ASCII values
    cout << "ASCII value of 'A': " << (int)letter << endl;
    cout << "ASCII value of '5': " << (int)digit << endl;
    
    return 0;
}''';
      case "✅ Boolean Type":
        return '''#include <iostream>
using namespace std;

int main() {
    // Boolean variables
    bool isStudent = true;
    bool isWorking = false;
    bool hasLicense = true;
    
    cout << "Is Student: " << isStudent << endl;
    cout << "Is Working: " << isWorking << endl;
    cout << "Has License: " << hasLicense << endl;
    
    // Boolean operations
    bool canDrive = hasLicense && !isStudent;
    bool isBusy = isStudent || isWorking;
    
    cout << "Can Drive: " << canDrive << endl;
    cout << "Is Busy: " << isBusy << endl;
    
    // Boolean expressions
    int age = 20;
    bool isAdult = age >= 18;
    cout << "Is Adult: " << isAdult << endl;
    
    return 0;
}''';
      case "🎯 Type Conversion":
        return '''#include <iostream>
using namespace std;

int main() {
    // Implicit conversion
    int num1 = 10;
    double num2 = 3.14;
    double result1 = num1 + num2;  // int to double
    
    cout << "Implicit conversion: " << result1 << endl;
    
    // Explicit conversion (C-style cast)
    double pi = 3.14159;
    int truncated = (int)pi;
    cout << "Truncated pi: " << truncated << endl;
    
    // Explicit conversion (C++ style cast)
    int value = 100;
    double converted = static_cast<double>(value);
    cout << "Converted value: " << converted << endl;
    
    // String to number conversion
    string str = "123";
    int number = stoi(str);  // string to int
    cout << "String to int: " << number << endl;
    
    // Number to string conversion
    int num = 456;
    string strNum = to_string(num);  // int to string
    cout << "Int to string: " << strNum << endl;
    
    return 0;
}''';
      default:
        return '''#include <iostream>
using namespace std;

int main() {
    cout << "Learning C++ Data Types!" << endl;
    return 0;
}''';
    }
  }

  Widget _buildKeyPoints(String sectionTitle) {
    List<String> keyPoints = [];
    
    switch (sectionTitle) {
      case "🔢 Basic Data Types":
        keyPoints = [
          "int: whole numbers",
          "double: decimal numbers with high precision",
          "char: single character",
          "bool: true or false values",
          "string: sequence of characters",
          "Each type has different size and range"
        ];
        break;
      case "📏 Integer Types":
        keyPoints = [
          "short: 2 bytes, -32,768 to 32,767",
          "int: 4 bytes, -2,147,483,648 to 2,147,483,647",
          "long: 4-8 bytes, larger range than int",
          "long long: 8 bytes, very large range",
          "Use appropriate type for memory efficiency",
          "Unsigned versions available for positive numbers only"
        ];
        break;
      case "🔢 Floating Point":
        keyPoints = [
          "float: 4 bytes, 6-7 decimal digits precision",
          "double: 8 bytes, 15-16 decimal digits precision",
          "long double: 10-16 bytes, highest precision",
          "Use double for most calculations",
          "Be aware of precision limitations",
          "Use fixed notation for consistent output"
        ];
        break;
      case "📝 Character Types":
        keyPoints = [
          "char: single character, 1 byte",
          "string: sequence of characters",
          "Characters have ASCII values",
          "Use single quotes for char: 'A'",
          "Use double quotes for string: \"Hello\"",
          "String class provides many useful methods"
        ];
        break;
      case "✅ Boolean Type":
        keyPoints = [
          "bool: true or false values",
          "1 byte in memory",
          "Used in conditional statements",
          "Logical operators: &&, ||, !",
          "Comparison operators return bool",
          "Default value is false"
        ];
        break;
      case "🎯 Type Conversion":
        keyPoints = [
          "Implicit: automatic conversion",
          "Explicit: manual conversion using casts",
          "C-style cast: (type)value",
          "C++ style cast: static_cast<type>(value)",
          "String conversion: stoi(), to_string()",
          "Be careful with data loss during conversion"
        ];
        break;
    }

    return TutorialCard(
      title: '🔑 Key Points',
      content: keyPoints.map((point) => '• $point').join('\n'),
      icon: Icons.lightbulb_outline,
      iconColor: TutorialTheme.tutorialWarning,
      isDarkMode: _isDarkMode,
    );
  }
}

class DataTypeTutorialSection {
  final String title;
  final String subtitle;
  final String content;

  DataTypeTutorialSection({
    required this.title,
    required this.subtitle,
    required this.content,
  });
}