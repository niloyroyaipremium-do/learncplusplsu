// File: C++ String Data Type Tutorial - Comprehensive Guide
import 'package:flutter/material.dart';

class CppStringTutorial extends StatefulWidget {
  const CppStringTutorial({super.key});

  @override
  State<CppStringTutorial> createState() => _CppStringTutorialState();
}

class _CppStringTutorialState extends State<CppStringTutorial>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _currentPage = 0;
  bool _isDarkMode = true;
  double _fontSize = 20.0;

  final List<StringTutorialSection> _tutorialSections = [
    StringTutorialSection(
      title: "📝 String Basics",
      subtitle: "Understanding what strings are and how to use them!",
      content: _stringBasicsContent,
    ),
    StringTutorialSection(
      title: "🔤 String Declaration",
      subtitle: "Different ways to create and initialize strings!",
      content: _stringDeclarationContent,
    ),
    StringTutorialSection(
      title: "🔧 String Methods",
      subtitle: "Powerful functions to manipulate strings!",
      content: _stringMethodsContent,
    ),
    StringTutorialSection(
      title: "🔗 String Concatenation",
      subtitle: "Combining strings together!",
      content: _stringConcatenationContent,
    ),
    StringTutorialSection(
      title: "🔍 String Operations",
      subtitle: "Searching, comparing, and modifying strings!",
      content: _stringOperationsContent,
    ),
    StringTutorialSection(
      title: "🎯 String Examples",
      subtitle: "Real-world examples and practice problems!",
      content: _stringExamplesContent,
    ),
  ];

  @override
  void initState() {
    super.initState();
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
      backgroundColor: _isDarkMode ? Color(0xFF1A1A1A) : Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          '📝 C++ String Tutorial',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: _isDarkMode ? Color(0xFF2A2A2A) : Color(0xFF1A73E8),
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
            child: Icon(Icons.text_fields),
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
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          tabs: _tutorialSections
              .map(
                (section) => Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          section.title.split(' ')[0], // Emoji
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 4),
                        Text(
                          section.title.split(' ').skip(1).join(' '),
                          style: TextStyle(fontSize: 12),
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
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / _tutorialSections.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF1A73E8),
                    ),
                  ),
                ),
                SizedBox(width: 16),
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

  Widget _buildTutorialPage(StringTutorialSection section) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A73E8), Color(0xFF4285F4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF1A73E8).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  section.subtitle,
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          // Content
          section.content(context, _isDarkMode, _fontSize),
        ],
      ),
    );
  }
}

class StringTutorialSection {
  final String title;
  final String subtitle;
  final Widget Function(BuildContext, bool, double) content;

  const StringTutorialSection({
    required this.title,
    required this.subtitle,
    required this.content,
  });
}

// String Basics Content
Widget _stringBasicsContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "📝 What are Strings?",
        "A string in C++ is a sequence of characters. It's like a word, sentence, or any text that you want to store and manipulate in your program. Strings are essential for handling text data!",
        isDarkMode,
      ),
      SizedBox(height: 20),
      _buildCodeExample(
        "🌟 Basic String Example",
        '''#include <iostream>
#include <string>
using namespace std;

int main() {
    // Creating a string
    string greeting = "Hello, World!";
    
    // Displaying the string
    cout << greeting << endl;
    
    // String length
    cout << "Length: " << greeting.length() << endl;
    
    // Accessing individual characters
    cout << "First character: " << greeting[0] << endl;
    cout << "Last character: " << greeting[greeting.length()-1] << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      SizedBox(height: 20),
      _buildInfoCard(
        "🔑 Key Points",
        "• **String is a data type** for storing text\n• **Must include <string>** header\n• **Can be empty** or contain any text\n• **Have a length** that can be checked\n• **Characters can be accessed** by index\n• **Are mutable** - can be changed",
        isDarkMode,
      ),
    ],
  );
}

// String Declaration Content
Widget _stringDeclarationContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🔤 Different Ways to Declare Strings",
        "There are several ways to create and initialize strings in C++. Each method has its own use case and advantages!",
        isDarkMode,
      ),
      SizedBox(height: 20),
      _buildCodeExample(
        "📋 String Declaration Methods",
        '''#include <iostream>
#include <string>
using namespace std;

int main() {
    // Method 1: Empty string
    string str1;
    cout << "Empty string: '" << str1 << "'" << endl;
    
    // Method 2: Initialize with text
    string str2 = "Hello";
    cout << "Initialized: '" << str2 << "'" << endl;
    
    // Method 3: Copy constructor
    string str3(str2);
    cout << "Copied: '" << str3 << "'" << endl;
    
    // Method 4: Multiple characters
    string str4(5, 'A');
    cout << "Repeated: '" << str4 << "'" << endl;
    
    // Method 5: From C-string
    string str5("C++ Programming");
    cout << "From C-string: '" << str5 << "'" << endl;
    
    // Method 6: Substring
    string str6(str5, 0, 3);
    cout << "Substring: '" << str6 << "'" << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      SizedBox(height: 20),
      _buildInfoCard(
        "💡 Declaration Tips",
        "• **Use = \"text\"** for simple initialization\n• **Use empty declaration** when size is unknown\n• **Use copy constructor** to duplicate strings\n• **Use (n, char)** to repeat characters\n• **Always include <string>** header",
        isDarkMode,
      ),
    ],
  );
}

// String Methods Content
Widget _stringMethodsContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🔧 Essential String Methods",
        "C++ strings come with many built-in methods that make text manipulation easy and efficient. These methods help you work with strings like a pro!",
        isDarkMode,
      ),
      SizedBox(height: 20),
      _buildCodeExample(
        "🛠️ String Methods in Action",
        '''#include <iostream>
#include <string>
using namespace std;

int main() {
    string text = "Hello World";
    
    // Length and size
    cout << "Length: " << text.length() << endl;
    cout << "Size: " << text.size() << endl;
    
    // Check if empty
    cout << "Is empty: " << (text.empty() ? "Yes" : "No") << endl;
    
    // Access characters
    cout << "First char: " << text[0] << endl;
    cout << "Last char: " << text.back() << endl;
    
    // Find characters
    cout << "Position of 'o': " << text.find('o') << endl;
    cout << "Position of 'World': " << text.find("World") << endl;
    
    // Substring
    cout << "Substring (0,5): " << text.substr(0, 5) << endl;
    
    // Replace
    text.replace(6, 5, "C++");
    cout << "After replace: " << text << endl;
    
    // Insert
    text.insert(5, " Beautiful");
    cout << "After insert: " << text << endl;
    
    // Erase
    text.erase(5, 10);
    cout << "After erase: " << text << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      SizedBox(height: 20),
      _buildInfoCard(
        "📚 Common String Methods",
        "• **length()** - Get string length\n• **empty()** - Check if string is empty\n• **find()** - Find character or substring\n• **substr()** - Extract substring\n• **replace()** - Replace part of string\n• **insert()** - Insert text at position\n• **erase()** - Remove characters\n• **back()** - Get last character\n• **front()** - Get first character",
        isDarkMode,
      ),
    ],
  );
}

// String Concatenation Content
Widget _stringConcatenationContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🔗 String Concatenation",
        "Concatenation means joining strings together. C++ provides several ways to combine strings, making it easy to build complex text from smaller parts!",
        isDarkMode,
      ),
      SizedBox(height: 20),
      _buildCodeExample(
        "🔗 Concatenation Methods",
        '''#include <iostream>
#include <string>
using namespace std;

int main() {
    string first = "Hello";
    string last = "World";
    string space = " ";
    
    // Method 1: Using + operator
    string result1 = first + space + last;
    cout << "Method 1: " << result1 << endl;
    
    // Method 2: Using += operator
    string result2 = first;
    result2 += space;
    result2 += last;
    cout << "Method 2: " << result2 << endl;
    
    // Method 3: Using append()
    string result3 = first;
    result3.append(space);
    result3.append(last);
    cout << "Method 3: " << result3 << endl;
    
    // Method 4: Multiple concatenations
    string name = "Alice";
    string age = "25";
    string info = "Name: " + name + ", Age: " + age;
    cout << "Info: " << info << endl;
    
    // Method 5: With numbers
    int year = 2024;
    string message = "Welcome to " + to_string(year) + "!";
    cout << "Message: " << message << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      SizedBox(height: 20),
      _buildInfoCard(
        "💡 Concatenation Tips",
        "• **Use +** for simple concatenation\n• **Use +=** for building strings gradually\n• **Use append()** for more control\n• **Convert numbers** with to_string()\n• **Be careful with types** - only strings can be concatenated\n• **Consider performance** for large strings",
        isDarkMode,
      ),
    ],
  );
}

// String Operations Content
Widget _stringOperationsContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🔍 Advanced String Operations",
        "Beyond basic manipulation, strings support powerful operations like searching, comparing, and transforming text. These operations make strings incredibly versatile!",
        isDarkMode,
      ),
      SizedBox(height: 20),
      _buildCodeExample(
        "🔍 String Operations Demo",
        '''#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

int main() {
    string text = "Hello World Programming";
    
    // Searching
    cout << "Text: " << text << endl;
    cout << "Contains 'World': " << (text.find("World") != string::npos ? "Yes" : "No") << endl;
    cout << "Starts with 'Hello': " << (text.substr(0, 5) == "Hello" ? "Yes" : "No") << endl;
    
    // Comparing
    string str1 = "apple";
    string str2 = "banana";
    cout << "apple < banana: " << (str1 < str2 ? "True" : "False") << endl;
    cout << "apple == apple: " << (str1 == "apple" ? "True" : "False") << endl;
    
    // Case conversion
    string mixed = "HeLLo WoRLd";
    cout << "Original: " << mixed << endl;
    
    // Convert to lowercase
    transform(mixed.begin(), mixed.end(), mixed.begin(), ::tolower);
    cout << "Lowercase: " << mixed << endl;
    
    // Convert to uppercase
    transform(mixed.begin(), mixed.end(), mixed.begin(), ::toupper);
    cout << "Uppercase: " << mixed << endl;
    
    // String splitting (manual)
    string sentence = "Hello World C++";
    size_t pos = 0;
    cout << "Words: ";
    while ((pos = sentence.find(' ')) != string::npos) {
        cout << "[" << sentence.substr(0, pos) << "] ";
        sentence.erase(0, pos + 1);
    }
    cout << "[" << sentence << "]" << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      SizedBox(height: 20),
      _buildInfoCard(
        "🎯 Operation Types",
        "• **Searching** - find(), rfind(), find_first_of()\n• **Comparing** - ==, !=, <, >, <=, >=\n• **Case conversion** - tolower(), toupper()\n• **Splitting** - Manual or with algorithms\n• **Validation** - Check patterns or formats\n• **Transformation** - Modify string content",
        isDarkMode,
      ),
    ],
  );
}

// String Examples Content
Widget _stringExamplesContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🎯 Real-World String Examples",
        "Let's see how strings are used in practical programming scenarios. These examples will help you understand how to apply string concepts in real projects!",
        isDarkMode,
      ),
      SizedBox(height: 20),
      _buildCodeExample(
        "📧 Email Validator",
        '''#include <iostream>
#include <string>
using namespace std;

bool isValidEmail(const string& email) {
    // Check if email contains @ and .
    if (email.find('@') == string::npos) return false;
    if (email.find('.') == string::npos) return false;
    
    // Check if @ is not at the beginning or end
    if (email[0] == '@' || email.back() == '@') return false;
    if (email[0] == '.' || email.back() == '.') return false;
    
    return true;
}

int main() {
    string email;
    cout << "Enter email address: ";
    getline(cin, email);
    
    if (isValidEmail(email)) {
        cout << "Valid email address!" << endl;
    } else {
        cout << "Invalid email address!" << endl;
    }
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      SizedBox(height: 20),
      _buildCodeExample(
        "📝 Text Processor",
        '''#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

int main() {
    string text;
    cout << "Enter a sentence: ";
    getline(cin, text);
    
    cout << "\\nOriginal: " << text << endl;
    cout << "Length: " << text.length() << " characters" << endl;
    
    // Count words
    int wordCount = 1;
    for (char c : text) {
        if (c == ' ') wordCount++;
    }
    cout << "Words: " << wordCount << endl;
    
    // Count vowels
    int vowels = 0;
    for (char c : text) {
        char lower = tolower(c);
        if (lower == 'a' || lower == 'e' || lower == 'i' || lower == 'o' || lower == 'u') {
            vowels++;
        }
    }
    cout << "Vowels: " << vowels << endl;
    
    // Reverse the text
    string reversed = text;
    reverse(reversed.begin(), reversed.end());
    cout << "Reversed: " << reversed << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      SizedBox(height: 20),
      _buildInfoCard(
        "🚀 Practice Projects",
        "• **Password Generator** - Create random passwords\n• **Text Analyzer** - Count words, characters, sentences\n• **String Reverser** - Reverse words or entire text\n• **Name Formatter** - Capitalize names properly\n• **URL Parser** - Extract parts of URLs\n• **Chat Bot** - Process user input and respond",
        isDarkMode,
      ),
    ],
  );
}

// Helper function to build colorful info cards
Widget _buildInfoCard(String title, String content, bool isDarkMode) {
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDarkMode ? Color(0xFF2A2A2A) : Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDarkMode ? Color(0xFF1A73E8) : Color(0xFFE3F2FD),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: (isDarkMode ? Color(0xFF1A73E8) : Color(0xFF4D96FF))
              .withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 4),
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
            color: isDarkMode ? Color(0xFF1A73E8) : Color(0xFF4D96FF),
          ),
        ),
        SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: isDarkMode ? Color(0xFFFFFFFF) : Color(0xFF2D3748),
          ),
        ),
      ],
    ),
  );
}

// Helper function to build colorful code examples
Widget _buildCodeExample(
  String title,
  String code,
  bool isDarkMode,
  double fontSize,
) {
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: (isDarkMode ? Color(0xFF1A73E8) : Color(0xFF4D96FF))
              .withOpacity(0.2),
          blurRadius: 15,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF1A73E8) : Color(0xFF4D96FF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.code, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF1E1E1E) : Color(0xFFF8F9FA),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: SelectableText(
            code,
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: fontSize,
              color: isDarkMode ? Colors.white : Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}
