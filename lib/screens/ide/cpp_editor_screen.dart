import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/cpp_execution_service.dart';
import '../../utils/logger.dart';
import '../../widgets/syntax_highlighted_editor.dart';

class CppEditorScreen extends StatefulWidget {
  final String? initialCode;
  final String? lessonTitle;

  const CppEditorScreen({super.key, this.initialCode, this.lessonTitle});

  @override
  State<CppEditorScreen> createState() => _CppEditorScreenState();
}

class _CppEditorScreenState extends State<CppEditorScreen>
    with TickerProviderStateMixin {
  late TextEditingController _codeController;
  late TextEditingController _inputController;
  CppExecutionResult? _lastResult;
  bool _isExecuting = false;
  bool _showInput = false;
  String _selectedTheme = 'light';
  double _fontSize = 22.0;
  bool _isDarkMode = false;

  late AnimationController _buttonAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _loadingAnimation;

  final List<String> _themes = [
    'light',
    'dark',
    'monokai',
    'solarized',
    'dracula',
  ];
  final List<double> _fontSizes = [
    16.0,
    18.0,
    20.0,
    22.0,
    24.0,
    26.0,
    28.0,
    30.0,
  ];

  final List<String> _codeTemplates = [
    'Hello World',
    'Variables and Data Types',
    'Input/Output',
    'Loops',
    'Functions',
    'Arrays',
    'Pointers',
    'Classes',
  ];

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(
      text: widget.initialCode ?? _getDefaultCode(),
    );
    _inputController = TextEditingController();

    _buttonAnimationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _loadingAnimationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _inputController.dispose();
    _buttonAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  String _getDefaultCode() {
    return '''#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    return 0;
}''';
  }

  String _getTemplateCode(String template) {
    switch (template) {
      case 'Hello World':
        return _getDefaultCode();
      case 'Variables and Data Types':
        return '''#include <iostream>
using namespace std;

int main() {
    int age = 25;
    double height = 5.9;
    char grade = 'A';
    string name = "John";
    
    cout << "Name: " << name << endl;
    cout << "Age: " << age << endl;
    cout << "Height: " << height << " feet" << endl;
    cout << "Grade: " << grade << endl;
    
    return 0;
}''';
      case 'Input/Output':
        return '''#include <iostream>
using namespace std;

int main() {
    int number;
    cout << "Enter a number: ";
    cin >> number;
    cout << "You entered: " << number << endl;
    return 0;
}''';
      case 'Loops':
        return '''#include <iostream>
using namespace std;

int main() {
    cout << "Counting from 1 to 5:" << endl;
    for (int i = 1; i <= 5; i++) {
        cout << i << " ";
    }
    cout << endl;
    return 0;
}''';
      case 'Functions':
        return '''#include <iostream>
using namespace std;

int add(int a, int b) {
    return a + b;
}

int main() {
    int result = add(5, 3);
    cout << "5 + 3 = " << result << endl;
    return 0;
}''';
      case 'Arrays':
        return '''#include <iostream>
using namespace std;

int main() {
    int numbers[5] = {10, 20, 30, 40, 50};
    
    cout << "Array elements: ";
    for (int i = 0; i < 5; i++) {
        cout << numbers[i] << " ";
    }
    cout << endl;
    return 0;
}''';
      case 'Pointers':
        return '''#include <iostream>
using namespace std;

int main() {
    int number = 42;
    int* ptr = &number;
    
    cout << "Value: " << number << endl;
    cout << "Address: " << ptr << endl;
    cout << "Value via pointer: " << *ptr << endl;
    
    return 0;
}''';
      case 'Classes':
        return '''#include <iostream>
using namespace std;

class Student {
private:
    string name;
    int age;
    
public:
    Student(string n, int a) : name(n), age(a) {}
    
    void display() {
        cout << "Name: " << name << ", Age: " << age << endl;
    }
};

int main() {
    Student student("Alice", 20);
    student.display();
    return 0;
}''';
      default:
        return _getDefaultCode();
    }
  }

  Future<void> _executeCode() async {
    if (_isExecuting) return;

    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });

    setState(() {
      _isExecuting = true;
      _lastResult = null;
    });

    _loadingAnimationController.repeat();

    try {
      final result = await CppExecutionService.executeCode(
        _codeController.text,
        input: _inputController.text.isNotEmpty ? _inputController.text : null,
      );

      setState(() {
        _lastResult = result;
        _isExecuting = false;
      });

      _loadingAnimationController.stop();
      Logger.info('Code execution completed: ${result.success}');
    } catch (e) {
      setState(() {
        _lastResult = CppExecutionResult(
          success: false,
          output: '',
          error: 'Execution failed: ${e.toString()}',
          executionTime: 0,
        );
        _isExecuting = false;
      });
      _loadingAnimationController.stop();
    }
  }

  Future<void> _validateCode() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 16),
            Text('Validating code with Python compiler...'),
          ],
        ),
      ),
    );

    try {
      final validation = await CppExecutionService.validateCode(
        _codeController.text,
      );

      // Check if widget is still mounted before using BuildContext
      if (!mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                validation.isValid ? Icons.check_circle : Icons.warning,
                color: validation.isValid ? Colors.green : Colors.orange,
              ),
              SizedBox(width: 8),
              Text(
                validation.isValid ? 'Code is Valid!' : 'Code Issues Found',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (validation.issues.isNotEmpty) ...[
                  Text(
                    'Issues:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...validation.issues.map(
                    (issue) => Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 16,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Expanded(child: Text('• $issue')),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                if (validation.suggestions.isNotEmpty) ...[
                  Text(
                    'Suggestions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...validation.suggestions.map(
                    (suggestion) => Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 16,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 8),
                          Expanded(child: Text('• $suggestion')),
                        ],
                      ),
                    ),
                  ),
                ],
                if (validation.isValid) ...[
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your C++ code is ready to compile and run!',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Check if widget is still mounted before using BuildContext
      if (!mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Validation Error'),
            ],
          ),
          content: Text('Failed to validate code: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _loadTemplate(String template) {
    _codeController.text = _getTemplateCode(template);
  }

  void _clearCode() {
    _codeController.clear();
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _codeController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 8),
            Text('Code copied to clipboard'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Color _getThemeBackgroundColor() {
    switch (_selectedTheme) {
      case 'dark':
        return Color(0xFF1E1E1E);
      case 'monokai':
        return Color(0xFF272822);
      case 'solarized':
        return Color(0xFFFDF6E3);
      case 'dracula':
        return Color(0xFF282A36);
      default:
        return _isDarkMode ? Color(0xFF2D2D2D) : Color(0xFFF8F9FA);
    }
  }

  Widget _buildSyntaxHighlightedCode() {
    return SyntaxHighlightedEditor(
      controller: _codeController,
      language: 'cpp',
      fontSize: _fontSize,
      isDarkMode: _isDarkMode,
      theme: _selectedTheme,
      onChanged: () {
        // Trigger rebuild for syntax highlighting
        setState(() {});
      },
    );
  }

  Widget _buildRunButton() {
    return AnimatedBuilder(
      animation: _buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF667eea).withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _isExecuting ? null : _executeCode,
              icon: _isExecuting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(Icons.play_arrow, size: 24),
              label: Text(
                _isExecuting ? 'Running...' : 'Run Code',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorOutput() {
    if (_lastResult == null) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _lastResult!.success
              ? [
                  Color(0xFF4CAF50).withValues(alpha: 0.1),
                  Color(0xFF8BC34A).withValues(alpha: 0.1),
                ]
              : [
                  Color(0xFFF44336).withValues(alpha: 0.1),
                  Color(0xFFE57373).withValues(alpha: 0.1),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _lastResult!.success ? Color(0xFF4CAF50) : Color(0xFFF44336),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                (_lastResult!.success ? Color(0xFF4CAF50) : Color(0xFFF44336))
                    .withValues(alpha: 0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _lastResult!.success
                  ? Color(0xFF4CAF50)
                  : Color(0xFFF44336),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _lastResult!.success ? Icons.check_circle : Icons.error,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  _lastResult!.success ? 'Output' : 'Error',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                if (_lastResult!.executionTime > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_lastResult!.executionTime}ms',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  _lastResult!.hasError
                      ? _lastResult!.error
                      : _lastResult!.output,
                  style: TextStyle(
                    fontFamily: 'Consolas',
                    fontSize: 18, // Increased font size
                    color: _lastResult!.success
                        ? Color(0xFF2E7D32)
                        : Color(0xFFD32F2F),
                    height: 1.6, // Increased line height
                    fontWeight: FontWeight.w500, // Added font weight
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (!_isExecuting) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF667eea).withValues(alpha: 0.1),
            Color(0xFF764ba2).withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF667eea).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _loadingAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _loadingAnimation.value,
                backgroundColor: Color(0xFF667eea).withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                minHeight: 6,
              );
            },
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Executing your C++ code...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF667eea),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xFF121212) : Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          widget.lessonTitle ?? 'C++ Code Editor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _isDarkMode ? Color(0xFF1E1E1E) : Color(0xFF667eea),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Theme Switcher
          IconButton(
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: _isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
          // Font Size
          PopupMenuButton<double>(
            onSelected: (size) => setState(() => _fontSize = size),
            itemBuilder: (context) => _fontSizes.map((size) {
              return PopupMenuItem(
                value: size,
                child: Text('${size.toInt()}px'),
              );
            }).toList(),
            tooltip: 'Font Size',
            child: Icon(Icons.text_fields),
          ),
          // Code Templates
          PopupMenuButton<String>(
            onSelected: _loadTemplate,
            itemBuilder: (context) => _codeTemplates.map((template) {
              return PopupMenuItem(
                value: template,
                child: Row(
                  children: [
                    Icon(Icons.code, size: 20),
                    SizedBox(width: 8),
                    Text(template),
                  ],
                ),
              );
            }).toList(),
            tooltip: 'Code Templates',
            child: Icon(Icons.code),
          ),
          // Theme Colors
          PopupMenuButton<String>(
            onSelected: (theme) => setState(() => _selectedTheme = theme),
            itemBuilder: (context) => _themes.map((theme) {
              return PopupMenuItem(
                value: theme,
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _getThemeBackgroundColor(),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(theme.toUpperCase()),
                  ],
                ),
              );
            }).toList(),
            tooltip: 'Editor Theme',
            child: Icon(Icons.palette),
          ),
        ],
      ),
      body: Column(
        children: [
          // Code Editor
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.all(16),
              child: _buildSyntaxHighlightedCode(),
            ),
          ),

          // Input Section
          if (_showInput)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _isDarkMode ? Color(0xFF2D2D2D) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _inputController,
                style: TextStyle(
                  fontFamily: 'Consolas',
                  fontSize: _fontSize,
                  color: _isDarkMode ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: 'Input (optional)',
                  labelStyle: TextStyle(
                    color: _isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.all(20),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => setState(() => _showInput = false),
                  ),
                ),
              ),
            ),

          // Loading Indicator
          _buildLoadingIndicator(),

          // Control Buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: _buildRunButton()),
                SizedBox(width: 12),
                // Action Buttons
                _buildActionButton(
                  icon: Icons.check_circle,
                  onPressed: _validateCode,
                  tooltip: 'Validate Code',
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.input,
                  onPressed: () => setState(() => _showInput = !_showInput),
                  tooltip: 'Toggle Input',
                  color: Colors.blue,
                ),
                SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.copy,
                  onPressed: _copyCode,
                  tooltip: 'Copy Code',
                  color: Colors.orange,
                ),
                SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.clear,
                  onPressed: _clearCode,
                  tooltip: 'Clear Code',
                  color: Colors.red,
                ),
              ],
            ),
          ),

          // Output Section
          if (_lastResult != null)
            Expanded(flex: 2, child: _buildErrorOutput()),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        tooltip: tooltip,
        style: IconButton.styleFrom(padding: EdgeInsets.all(12)),
      ),
    );
  }
}
