// File: C++ Data Types Tutorial - Comprehensive Guide
import 'package:flutter/material.dart';

class CppDataTypesTutorial extends StatefulWidget {
  const CppDataTypesTutorial({super.key});

  @override
  State<CppDataTypesTutorial> createState() => _CppDataTypesTutorialState();
}

class _CppDataTypesTutorialState extends State<CppDataTypesTutorial>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _currentPage = 0;
  bool _isDarkMode = true;
  double _fontSize = 20.0;

  late List<DataTypeTutorialSection> _tutorialSections;

  @override
  void initState() {
    super.initState();

    _tutorialSections = [
      DataTypeTutorialSection(
        title: "🔢 Basic Data Types",
        subtitle: "Understanding fundamental data types in C++!",
        content: _basicDataTypesContent,
      ),
      DataTypeTutorialSection(
        title: "📏 Integer Types",
        subtitle: "Different integer types and their ranges!",
        content: _integerTypesContent,
      ),
      DataTypeTutorialSection(
        title: "🔢 Floating Point",
        subtitle: "Decimal numbers and precision!",
        content: _floatingPointContent,
      ),
      DataTypeTutorialSection(
        title: "📝 Character Types",
        subtitle: "Working with characters and text!",
        content: _characterTypesContent,
      ),
      DataTypeTutorialSection(
        title: "✅ Boolean Type",
        subtitle: "True and false values!",
        content: _booleanTypeContent,
      ),
      DataTypeTutorialSection(
        title: "🎯 Type Modifiers",
        subtitle: "Modifying data types with keywords!",
        content: _typeModifiersContent,
      ),
      DataTypeTutorialSection(
        title: "📊 Type Conversion",
        subtitle: "Converting between different data types!",
        content: _typeConversionContent,
      ),
      DataTypeTutorialSection(
        title: "💡 Best Practices",
        subtitle: "Choosing the right data type!",
        content: _bestPracticesContent,
      ),
    ];

    _tabController = TabController(
      length: _tutorialSections.length,
      vsync: this,
    );
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          '🔢 C++ Data Types Tutorial',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: _isDarkMode
            ? const Color(0xFF2A2A2A)
            : const Color(0xFF1A73E8),
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
          PopupMenuButton<double>(
            onSelected: (size) => setState(() => _fontSize = size),
            itemBuilder: (context) =>
                [16.0, 18.0, 20.0, 22.0, 24.0, 26.0, 28.0, 30.0]
                    .map(
                      (size) => PopupMenuItem(
                        value: size,
                        child: Text('${size.toInt()}px'),
                      ),
                    )
                    .toList(),
            tooltip: 'Font Size',
            child: const Icon(Icons.text_fields),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          tabs: _tutorialSections
              .map(
                (section) => Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          section.title.split(' ')[0], // Emoji
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          section.title.split(' ').skip(1).join(' '),
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / _tutorialSections.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF1A73E8),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${_currentPage + 1} / ${_tutorialSections.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Page content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                _tabController.animateTo(index);
              },
              itemCount: _tutorialSections.length,
              itemBuilder: (context, index) {
                return _buildTutorialPage(_tutorialSections[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialPage(DataTypeTutorialSection section) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A73E8), Color(0xFF4285F4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A73E8).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  section.subtitle,
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Content
          section.content(context, _isDarkMode, _fontSize),
        ],
      ),
    );
  }
}

class DataTypeTutorialSection {
  final String title;
  final String subtitle;
  final Widget Function(BuildContext, bool, double) content;

  const DataTypeTutorialSection({
    required this.title,
    required this.subtitle,
    required this.content,
  });
}

// Basic Data Types Content
Widget _basicDataTypesContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🔢 What are Data Types?",
        "Data types define the type of data a variable can store. C++ has several built-in data types to handle different kinds of information efficiently.",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "🌟 Basic Data Types Example",
        '''#include &lt;iostream&gt;
using namespace std;

int main() {
    // Integer types
    int age = 25;
    short smallNumber = 100;
    long bigNumber = 1000000L;
    
    // Floating point types
    float price = 19.99f;
    double pi = 3.14159265359;
    
    // Character type
    char grade = 'A';
    
    // Boolean type
    bool isStudent = true;
    
    // Display values
    cout << "Age: " << age << endl;
    cout << "Small Number: " << smallNumber << endl;
    cout << "Big Number: " << bigNumber << endl;
    cout << "Price: " << price << endl;
    cout << "Pi: " << pi << endl;
    cout << "Grade: " << grade << endl;
    cout << "Is Student: " << isStudent << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "📋 Main Data Type Categories",
        "• **Integer Types** - Whole numbers (int, short, long)\n• **Floating Point** - Decimal numbers (float, double)\n• **Character** - Single characters (char)\n• **Boolean** - True/false values (bool)\n• **Void** - No value (void)",
        isDarkMode,
      ),
    ],
  );
}

// Integer Types Content
Widget _integerTypesContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "📏 Integer Data Types",
        "Integer types store whole numbers without decimal points. C++ provides different integer types with varying sizes and ranges.",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "🔢 Integer Types Example",
        '''#include &lt;iostream&gt;
#include &lt;climits&gt;
using namespace std;

int main() {
    // Different integer types
    char c = 'A';           // 1 byte, -128 to 127
    short s = 1000;         // 2 bytes, -32,768 to 32,767
    int i = 100000;         // 4 bytes, -2,147,483,648 to 2,147,483,647
    long l = 1000000L;      // 4-8 bytes, varies by system
    long long ll = 1000000000LL; // 8 bytes, very large range
    
    // Unsigned versions (only positive numbers)
    unsigned char uc = 200;
    unsigned short us = 50000;
    unsigned int ui = 3000000000U;
    unsigned long ul = 4000000000UL;
    unsigned long long ull = 9000000000000000000ULL;
    
    cout << "Char: " << c << " (size: " << sizeof(c) << " bytes)" << endl;
    cout << "Short: " << s << " (size: " << sizeof(s) << " bytes)" << endl;
    cout << "Int: " << i << " (size: " << sizeof(i) << " bytes)" << endl;
    cout << "Long: " << l << " (size: " << sizeof(l) << " bytes)" << endl;
    cout << "Long Long: " << ll << " (size: " << sizeof(ll) << " bytes)" << endl;
    
    cout << "\\nUnsigned versions:" << endl;
    cout << "Unsigned Char: " << (int)uc << endl;
    cout << "Unsigned Short: " << us << endl;
    cout << "Unsigned Int: " << ui << endl;
    cout << "Unsigned Long: " << ul << endl;
    cout << "Unsigned Long Long: " << ull << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "📊 Integer Type Ranges",
        "• **char** - 1 byte, -128 to 127\n• **short** - 2 bytes, -32,768 to 32,767\n• **int** - 4 bytes, -2,147,483,648 to 2,147,483,647\n• **long** - 4-8 bytes, varies by system\n• **long long** - 8 bytes, very large range\n\n**Unsigned versions** can store only positive numbers with double the positive range.",
        isDarkMode,
      ),
    ],
  );
}

// Floating Point Content
Widget _floatingPointContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🔢 Floating Point Types",
        "Floating point types store decimal numbers with different precision levels. They're essential for calculations involving fractions and real numbers.",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "🔢 Floating Point Example",
        '''#include &lt;iostream&gt;
#include &lt;iomanip&gt;
using namespace std;

int main() {
    // Float - single precision (7 decimal digits)
    float f = 3.14159f;
    
    // Double - double precision (15 decimal digits)
    double d = 3.141592653589793;
    
    // Long double - extended precision
    long double ld = 3.141592653589793238L;
    
    // Scientific notation
    float scientific = 1.23e4f;  // 12300.0
    double bigNumber = 1.23e-4;  // 0.000123
    
    cout << "Float: " << f << " (size: " << sizeof(f) << " bytes)" << endl;
    cout << "Double: " << d << " (size: " << sizeof(d) << " bytes)" << endl;
    cout << "Long Double: " << ld << " (size: " << sizeof(ld) << " bytes)" << endl;
    
    cout << "\\nScientific notation:" << endl;
    cout << "1.23e4 = " << scientific << endl;
    cout << "1.23e-4 = " << bigNumber << endl;
    
    // Precision demonstration
    cout << "\\nPrecision comparison:" << endl;
    cout << fixed << setprecision(10);
    cout << "Float precision: " << f << endl;
    cout << "Double precision: " << d << endl;
    cout << "Long double precision: " << ld << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "📊 Floating Point Characteristics",
        "• **float** - 4 bytes, 7 decimal digits precision\n• **double** - 8 bytes, 15 decimal digits precision\n• **long double** - 10-16 bytes, 19+ decimal digits precision\n\n**Note:** Use double for most calculations, float only when memory is critical.",
        isDarkMode,
      ),
    ],
  );
}

// Character Types Content
Widget _characterTypesContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "📝 Character Data Types",
        "Character types store individual characters and are fundamental for text processing. C++ supports both single-byte and multi-byte character types.",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "📝 Character Types Example",
        '''#include &lt;iostream&gt;
#include &lt;string&gt;
using namespace std;

int main() {
    // Basic char type
    char letter = 'A';
    char digit = '5';
    char symbol = '@';
    
    // Wide character type
    wchar_t wideChar = L'Ω';
    
    // Character arrays (strings)
    char name[] = "John";
    char message[50] = "Hello, World!";
    
    // String class
    string fullName = "John Doe";
    
    cout << "Letter: " << letter << endl;
    cout << "Digit: " << digit << endl;
    cout << "Symbol: " << symbol << endl;
    cout << "Wide char: " << (char)wideChar << endl;
    
    cout << "\\nCharacter arrays:" << endl;
    cout << "Name: " << name << endl;
    cout << "Message: " << message << endl;
    
    cout << "\\nString class:" << endl;
    cout << "Full name: " << fullName << endl;
    cout << "Length: " << fullName.length() << endl;
    
    // ASCII values
    cout << "\\nASCII values:" << endl;
    cout << "A = " << (int)'A' << endl;
    cout << "a = " << (int)'a' << endl;
    cout << "0 = " << (int)'0' << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "🔤 Character Type Details",
        "• **char** - 1 byte, stores ASCII characters (0-255)\n• **wchar_t** - 2-4 bytes, stores Unicode characters\n• **char16_t** - 2 bytes, UTF-16 characters\n• **char32_t** - 4 bytes, UTF-32 characters\n\n**ASCII Range:** 0-127 (printable: 32-126)",
        isDarkMode,
      ),
    ],
  );
}

// Boolean Type Content
Widget _booleanTypeContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "✅ Boolean Data Type",
        "Boolean type stores logical values: true or false. It's essential for conditional statements and logical operations.",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "✅ Boolean Type Example",
        '''#include &lt;iostream&gt;
using namespace std;

int main() {
    // Boolean variables
    bool isStudent = true;
    bool isWorking = false;
    bool hasLicense = true;
    
    // Boolean expressions
    bool canDrive = hasLicense && !isStudent;
    bool isEligible = isStudent || isWorking;
    
    // Comparison results
    int age = 20;
    bool isAdult = age >= 18;
    bool isTeenager = age >= 13 && age <= 19;
    
    cout << "Is Student: " << isStudent << endl;
    cout << "Is Working: " << isWorking << endl;
    cout << "Has License: " << hasLicense << endl;
    
    cout << "\\nLogical operations:" << endl;
    cout << "Can Drive: " << canDrive << endl;
    cout << "Is Eligible: " << isEligible << endl;
    
    cout << "\\nAge comparisons:" << endl;
    cout << "Age: " << age << endl;
    cout << "Is Adult: " << isAdult << endl;
    cout << "Is Teenager: " << isTeenager << endl;
    
    // Boolean arithmetic
    cout << "\\nBoolean arithmetic:" << endl;
    cout << "true + true = " << (true + true) << endl;
    cout << "true + false = " << (true + false) << endl;
    cout << "false + false = " << (false + false) << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "🎯 Boolean Characteristics",
        "• **Size:** 1 byte (but only uses 1 bit)\n• **Values:** true (1) or false (0)\n• **Usage:** Conditional statements, loops, logical operations\n• **Conversion:** Any non-zero value converts to true, zero converts to false",
        isDarkMode,
      ),
    ],
  );
}

// Type Modifiers Content
Widget _typeModifiersContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🎯 Type Modifiers",
        "Type modifiers change the properties of basic data types. They control size, sign, and storage class of variables.",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "🎯 Type Modifiers Example",
        '''#include &lt;iostream&gt;
using namespace std;

int main() {
    // Size modifiers
    short int si = 100;
    long int li = 1000000L;
    long long int lli = 1000000000LL;
    
    // Sign modifiers
    signed int s = -100;        // Can be positive or negative
    unsigned int u = 200U;      // Only positive values
    
    // Combined modifiers
    unsigned short us = 50000;
    signed long sl = -1000000L;
    unsigned long long ull = 9000000000000000000ULL;
    
    // Const modifier (read-only)
    const int MAX_SIZE = 100;
    const double PI = 3.14159;
    
    // Volatile modifier (can change unexpectedly)
    volatile int counter = 0;
    
    cout << "Size modifiers:" << endl;
    cout << "Short int: " << si << " (size: " << sizeof(si) << " bytes)" << endl;
    cout << "Long int: " << li << " (size: " << sizeof(li) << " bytes)" << endl;
    cout << "Long long int: " << lli << " (size: " << sizeof(lli) << " bytes)" << endl;
    
    cout << "\\nSign modifiers:" << endl;
    cout << "Signed int: " << s << endl;
    cout << "Unsigned int: " << u << endl;
    
    cout << "\\nCombined modifiers:" << endl;
    cout << "Unsigned short: " << us << endl;
    cout << "Signed long: " << sl << endl;
    cout << "Unsigned long long: " << ull << endl;
    
    cout << "\\nConst values:" << endl;
    cout << "MAX_SIZE: " << MAX_SIZE << endl;
    cout << "PI: " << PI << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "🔧 Common Type Modifiers",
        "• **short** - Reduces size (usually 2 bytes)\n• **long** - Increases size (usually 4-8 bytes)\n• **signed** - Can store positive and negative values\n• **unsigned** - Only positive values, double the positive range\n• **const** - Read-only, cannot be modified\n• **volatile** - Can change unexpectedly (hardware, interrupts)",
        isDarkMode,
      ),
    ],
  );
}

// Type Conversion Content
Widget _typeConversionContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "📊 Type Conversion",
        "Type conversion allows you to convert values from one data type to another. C++ supports both implicit (automatic) and explicit (manual) conversions.",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "📊 Type Conversion Example",
        '''#include &lt;iostream&gt;
using namespace std;

int main() {
    // Implicit conversion (automatic)
    int i = 10;
    double d = i;        // int to double
    float f = 3.14f;
    int j = f;           // float to int (truncation)
    
    cout << "Implicit conversion:" << endl;
    cout << "int to double: " << i << " -> " << d << endl;
    cout << "float to int: " << f << " -> " << j << endl;
    
    // Explicit conversion (manual)
    double pi = 3.14159;
    int truncated = (int)pi;                    // C-style cast
    int rounded = static_cast<int>(pi + 0.5);   // C++ style cast
    
    cout << "\\nExplicit conversion:" << endl;
    cout << "Original: " << pi << endl;
    cout << "Truncated: " << truncated << endl;
    cout << "Rounded: " << rounded << endl;
    
    // Character conversion
    char c = 'A';
    int ascii = (int)c;
    char back = (char)(ascii + 1);
    
    cout << "\\nCharacter conversion:" << endl;
    cout << "Char: " << c << endl;
    cout << "ASCII: " << ascii << endl;
    cout << "Next char: " << back << endl;
    
    // String conversion
    string str = "123";
    int number = stoi(str);        // string to int
    string backStr = to_string(number);  // int to string
    
    cout << "\\nString conversion:" << endl;
    cout << "String: " << str << endl;
    cout << "Number: " << number << endl;
    cout << "Back to string: " << backStr << endl;
    
    // Boolean conversion
    int zero = 0;
    int nonZero = 42;
    bool boolZero = (bool)zero;
    bool boolNonZero = (bool)nonZero;
    
    cout << "\\nBoolean conversion:" << endl;
    cout << "0 -> bool: " << boolZero << endl;
    cout << "42 -> bool: " << boolNonZero << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "⚠️ Conversion Rules",
        "• **Implicit:** Automatic, safe conversions (int to double)\n• **Explicit:** Manual, potentially unsafe (double to int)\n• **Truncation:** Decimal part is lost when converting to integer\n• **Overflow:** Value too large for target type\n• **Underflow:** Value too small for target type",
        isDarkMode,
      ),
    ],
  );
}

// Best Practices Content
Widget _bestPracticesContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "💡 Data Type Best Practices",
        "Choosing the right data type is crucial for efficient and correct programs. Here are some guidelines to help you make the best choices.",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "💡 Best Practices Example",
        '''#include &lt;iostream&gt;
#include &lt;climits&gt;
using namespace std;

int main() {
    // 1. Use appropriate integer types
    unsigned int age = 25;           // Age can't be negative
    int temperature = -10;           // Temperature can be negative
    unsigned long population = 8000000000UL;  // Large positive number
    
    // 2. Use double for most floating-point calculations
    double price = 19.99;            // More precision than float
    double interest = 0.05;          // Financial calculations need precision
    
    // 3. Use const for values that don't change
    const double PI = 3.14159265359;
    const int MAX_STUDENTS = 100;
    
    // 4. Use meaningful variable names
    int studentCount = 0;
    double averageGrade = 0.0;
    bool isPassing = true;
    
    // 5. Initialize variables
    int sum = 0;                     // Always initialize
    double result = 0.0;             // Avoid garbage values
    
    // 6. Use size_t for array indices and sizes
    size_t arraySize = 10;
    size_t index = 0;
    
    // 7. Use bool for logical values
    bool isValid = true;
    bool isComplete = false;
    
    cout << "Best practices demonstration:" << endl;
    cout << "Age: " << age << " (unsigned int)" << endl;
    cout << "Temperature: " << temperature << " (signed int)" << endl;
    cout << "Population: " << population << " (unsigned long)" << endl;
    cout << "Price: " << price << " (double)" << endl;
    cout << "PI: " << PI << " (const double)" << endl;
    cout << "Student Count: " << studentCount << endl;
    cout << "Array Size: " << arraySize << " (size_t)" << endl;
    cout << "Is Valid: " << isValid << " (bool)" << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "🎯 Choosing the Right Type",
        "• **Integers:** Use int for most cases, unsigned for positive-only values\n• **Floating-point:** Use double for precision, float only for memory-critical applications\n• **Characters:** Use char for single characters, string for text\n• **Booleans:** Use bool for true/false values\n• **Constants:** Use const for values that don't change\n• **Sizes:** Use size_t for array indices and sizes",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "⚠️ Common Pitfalls",
        "• **Overflow:** Using too small a type for large values\n• **Underflow:** Using unsigned types for values that can be negative\n• **Precision loss:** Using float when double is needed\n• **Uninitialized variables:** Always initialize variables\n• **Type mixing:** Be careful when mixing different types in expressions",
        isDarkMode,
      ),
    ],
  );
}

// Helper functions for building UI components
Widget _buildInfoCard(String title, String content, bool isDarkMode) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDarkMode ? const Color(0xFF404040) : Colors.grey[300]!,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: isDarkMode ? Colors.grey[300] : Colors.black87,
          ),
        ),
      ],
    ),
  );
}

Widget _buildCodeExample(
  String title,
  String code,
  bool isDarkMode,
  double fontSize,
) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF8F9FA),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDarkMode ? const Color(0xFF404040) : Colors.grey[300]!,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF2D2D2D)
                : const Color(0xFFE9ECEF),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SelectableText(
              code,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: fontSize,
                color: isDarkMode
                    ? const Color(0xFFD4D4D4)
                    : const Color(0xFF2D3748),
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
