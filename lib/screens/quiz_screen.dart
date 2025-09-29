import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/progress_provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  int _score = 0;
  bool _isQuizCompleted = false;

  final List<QuizQuestion> _questions = [
    QuizQuestion(
      question: 'What is the correct way to declare a variable in C++?',
      options: [
        'int variable = 5;',
        'variable int = 5;',
        'int = 5 variable;',
        'declare int variable = 5;',
      ],
      correctAnswer: 0,
      explanation:
          'In C++, you declare a variable by specifying the type followed by the variable name and optionally an initial value.',
    ),
    QuizQuestion(
      question: 'Which keyword is used to include a header file in C++?',
      options: ['#import', '#include', '#using', '#require'],
      correctAnswer: 1,
      explanation:
          '#include is the preprocessor directive used to include header files in C++.',
    ),
    QuizQuestion(
      question: 'What is the output of: cout << "Hello" << "World";',
      options: [
        'Hello World',
        'HelloWorld',
        'Hello World ',
        'Compilation error',
      ],
      correctAnswer: 1,
      explanation:
          'The << operator concatenates strings without adding spaces, so "Hello" and "World" are printed together.',
    ),
    QuizQuestion(
      question: 'Which data type is used to store whole numbers in C++?',
      options: ['float', 'double', 'int', 'char'],
      correctAnswer: 2,
      explanation:
          'int is the primary data type for storing whole numbers in C++.',
    ),
    QuizQuestion(
      question: 'What does the ++ operator do?',
      options: [
        'Decrements by 1',
        'Increments by 1',
        'Multiplies by 2',
        'Divides by 2',
      ],
      correctAnswer: 1,
      explanation: 'The ++ operator increments a variable by 1.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('C++ Quiz'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (!_isQuizCompleted)
            TextButton(
              onPressed: _resetQuiz,
              child: const Text('Reset', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Consumer2<AppProvider, ProgressProvider>(
        builder: (context, appProvider, progressProvider, child) {
          if (_isQuizCompleted) {
            return _buildQuizResult(context, appProvider, progressProvider);
          }

          return _buildQuizQuestion(context, appProvider);
        },
      ),
    );
  }

  Widget _buildQuizQuestion(BuildContext context, AppProvider appProvider) {
    final question = _questions[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),

          const SizedBox(height: 20),

          // Question counter
          Text(
            'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),

          const SizedBox(height: 16),

          // Question
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                question.question,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Answer options
          Expanded(
            child: ListView.builder(
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedAnswer == index;
                // final isCorrect = index == question.correctAnswer;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(question.options[index]),
                    leading: Radio<int>(
                      value: index,
                      groupValue: _selectedAnswer,
                      onChanged: (value) {
                        setState(() {
                          _selectedAnswer = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _selectedAnswer = index;
                      });
                    },
                    tileColor: isSelected
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : null,
                  ),
                );
              },
            ),
          ),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentQuestionIndex > 0)
                ElevatedButton(
                  onPressed: _previousQuestion,
                  child: const Text('Previous'),
                )
              else
                const SizedBox.shrink(),

              ElevatedButton(
                onPressed: _selectedAnswer != null ? _nextQuestion : null,
                child: Text(
                  _currentQuestionIndex == _questions.length - 1
                      ? 'Finish Quiz'
                      : 'Next',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizResult(
    BuildContext context,
    AppProvider appProvider,
    ProgressProvider progressProvider,
  ) {
    final percentage = (_score / _questions.length * 100).round();
    final isPassed = percentage >= 70;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Result icon
          Icon(
            isPassed ? Icons.celebration : Icons.sentiment_dissatisfied,
            size: 80,
            color: isPassed ? Colors.green : Colors.red,
          ),

          const SizedBox(height: 20),

          // Result title
          Text(
            isPassed ? 'Congratulations!' : 'Keep Learning!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPassed ? Colors.green : Colors.red,
            ),
          ),

          const SizedBox(height: 16),

          // Score
          Text(
            'You scored $percentage%',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 8),

          Text(
            '$_score out of ${_questions.length} questions correct',
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          const SizedBox(height: 30),

          // Action buttons
          Column(
            children: [
              ElevatedButton.icon(
                onPressed: _resetQuiz,
                icon: const Icon(Icons.refresh),
                label: const Text('Take Quiz Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    if (_selectedAnswer == null) return;

    // Check if answer is correct
    if (_selectedAnswer == _questions[_currentQuestionIndex].correctAnswer) {
      _score++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      });
    } else {
      _finishQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = null;
      });
    }
  }

  void _finishQuiz() {
    setState(() {
      _isQuizCompleted = true;
    });

    // Add points and update progress
    final percentage = (_score / _questions.length * 100).round();
    final points = (percentage / 10).round() * 10; // 10 points per 10%

    context.read<ProgressProvider>().addPoints(points);

    if (percentage >= 70) {
      context.read<AppProvider>().passQuiz();
    }

    // Show result dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(percentage >= 70 ? 'Quiz Passed!' : 'Quiz Failed'),
        content: Text('You scored $percentage% and earned $points points!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _selectedAnswer = null;
      _score = 0;
      _isQuizCompleted = false;
    });
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}
