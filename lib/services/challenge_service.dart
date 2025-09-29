import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

/// Challenge Service
/// 
/// Handles daily coding challenges, project-based learning,
/// and peer comparison features
class ChallengeService {
  static final ChallengeService _instance = ChallengeService._internal();
  factory ChallengeService() => _instance;
  ChallengeService._internal();

  bool _isInitialized = false;
  final List<Map<String, dynamic>> _dailyChallenges = [];
  final List<Map<String, dynamic>> _projects = [];
  final Map<String, dynamic> _leaderboard = {};

  /// Initialize challenge service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _generateDailyChallenges();
      await _generateProjects();
      await _loadLeaderboard();
      
      _isInitialized = true;
      Logger.info('Challenge service initialized');
    } catch (e) {
      Logger.error('Failed to initialize challenge service', e);
    }
  }

  /// Generate daily challenges
  Future<void> _generateDailyChallenges() async {
    _dailyChallenges.clear();
    
    // Generate challenges for the next 30 days
    for (int i = 0; i < 30; i++) {
      final date = DateTime.now().add(Duration(days: i));
      final challenge = _generateChallengeForDate(date);
      _dailyChallenges.add(challenge);
    }
  }

  /// Generate challenge for specific date
  Map<String, dynamic> _generateChallengeForDate(DateTime date) {
    final challenges = [
      {
        'id': 'variable_swap',
        'title': 'Variable Swap Challenge',
        'description': 'Write a program to swap two variables without using a temporary variable.',
        'difficulty': 'Easy',
        'points': 10,
        'timeLimit': 10,
        'starterCode': '''
#include <iostream>
using namespace std;

int main() {
    int a = 5, b = 10;
    
    // Your code here - swap a and b without using temp variable
    
    cout << "a = " << a << ", b = " << b << endl;
    return 0;
}''',
        'expectedOutput': 'a = 10, b = 5',
        'testCases': [
          {'input': 'a=5, b=10', 'expected': 'a = 10, b = 5'},
          {'input': 'a=100, b=200', 'expected': 'a = 200, b = 100'},
        ],
        'hints': [
          'Use arithmetic operations',
          'Think about addition and subtraction',
        ],
      },
      {
        'id': 'fibonacci_sequence',
        'title': 'Fibonacci Sequence',
        'description': 'Generate the first n numbers in the Fibonacci sequence.',
        'difficulty': 'Medium',
        'points': 20,
        'timeLimit': 15,
        'starterCode': '''
#include <iostream>
using namespace std;

int main() {
    int n;
    cout << "Enter number of terms: ";
    cin >> n;
    
    // Your code here - generate Fibonacci sequence
    
    return 0;
}''',
        'expectedOutput': '0 1 1 2 3 5 8 13...',
        'testCases': [
          {'input': 'n=5', 'expected': '0 1 1 2 3'},
          {'input': 'n=10', 'expected': '0 1 1 2 3 5 8 13 21 34'},
        ],
        'hints': [
          'Start with 0 and 1',
          'Each number is the sum of the two preceding ones',
        ],
      },
      {
        'id': 'prime_checker',
        'title': 'Prime Number Checker',
        'description': 'Check if a given number is prime and find all prime numbers up to n.',
        'difficulty': 'Medium',
        'points': 25,
        'timeLimit': 20,
        'starterCode': '''
#include <iostream>
using namespace std;

bool isPrime(int n) {
    // Your code here - check if n is prime
    
}

int main() {
    int n;
    cout << "Enter a number: ";
    cin >> n;
    
    if (isPrime(n)) {
        cout << n << " is prime" << endl;
    } else {
        cout << n << " is not prime" << endl;
    }
    
    return 0;
}''',
        'expectedOutput': 'Prime or not prime',
        'testCases': [
          {'input': 'n=17', 'expected': '17 is prime'},
          {'input': 'n=15', 'expected': '15 is not prime'},
        ],
        'hints': [
          'A prime number is only divisible by 1 and itself',
          'Check divisibility up to sqrt(n)',
        ],
      },
      {
        'id': 'string_reverse',
        'title': 'String Reversal',
        'description': 'Reverse a string without using built-in functions.',
        'difficulty': 'Easy',
        'points': 15,
        'timeLimit': 10,
        'starterCode': '''
#include <iostream>
#include <string>
using namespace std;

int main() {
    string str;
    cout << "Enter a string: ";
    getline(cin, str);
    
    // Your code here - reverse the string
    
    cout << "Reversed: " << str << endl;
    return 0;
}''',
        'expectedOutput': 'Reversed string',
        'testCases': [
          {'input': 'hello', 'expected': 'olleh'},
          {'input': 'world', 'expected': 'dlrow'},
        ],
        'hints': [
          'Use two pointers approach',
          'Swap characters from both ends',
        ],
      },
      {
        'id': 'array_sort',
        'title': 'Array Sorting',
        'description': 'Sort an array of integers using bubble sort algorithm.',
        'difficulty': 'Medium',
        'points': 30,
        'timeLimit': 25,
        'starterCode': '''
#include <iostream>
using namespace std;

void bubbleSort(int arr[], int n) {
    // Your code here - implement bubble sort
    
}

int main() {
    int n;
    cout << "Enter array size: ";
    cin >> n;
    
    int arr[n];
    cout << "Enter " << n << " elements: ";
    for (int i = 0; i < n; i++) {
        cin >> arr[i];
    }
    
    bubbleSort(arr, n);
    
    cout << "Sorted array: ";
    for (int i = 0; i < n; i++) {
        cout << arr[i] << " ";
    }
    cout << endl;
    
    return 0;
}''',
        'expectedOutput': 'Sorted array in ascending order',
        'testCases': [
          {'input': '[5, 2, 8, 1, 9]', 'expected': '[1, 2, 5, 8, 9]'},
          {'input': '[3, 1, 4, 1, 5]', 'expected': '[1, 1, 3, 4, 5]'},
        ],
        'hints': [
          'Compare adjacent elements',
          'Swap if they are in wrong order',
          'Repeat until no swaps needed',
        ],
      },
    ];

    final random = Random();
    final challenge = challenges[random.nextInt(challenges.length)];
    
    return {
      ...challenge,
      'date': date.toIso8601String().split('T')[0],
      'id': '${challenge['id']}_${date.millisecondsSinceEpoch}',
    };
  }

  /// Generate projects
  Future<void> _generateProjects() async {
    _projects.clear();
    
    _projects.addAll([
      {
        'id': 'calculator',
        'title': 'Calculator App',
        'description': 'Build a command-line calculator with basic arithmetic operations.',
        'difficulty': 'Beginner',
        'estimatedTime': 120,
        'points': 50,
        'requirements': [
          'Support addition, subtraction, multiplication, division',
          'Handle division by zero',
          'Display results with proper formatting',
          'Allow continuous calculations',
        ],
        'starterCode': '''
#include <iostream>
using namespace std;

int main() {
    // Your calculator implementation here
    
    return 0;
}''',
        'testCases': [
          {'operation': '5 + 3', 'expected': '8'},
          {'operation': '10 / 2', 'expected': '5'},
          {'operation': '7 * 4', 'expected': '28'},
        ],
        'bonusFeatures': [
          'Support parentheses',
          'Memory functions (M+, M-, MR, MC)',
          'History of calculations',
        ],
      },
      {
        'id': 'file_manager',
        'title': 'File Manager',
        'description': 'Create a simple file manager with basic file operations.',
        'difficulty': 'Intermediate',
        'estimatedTime': 180,
        'points': 75,
        'requirements': [
          'List files in a directory',
          'Create new files and directories',
          'Delete files and directories',
          'Copy and move files',
        ],
        'starterCode': '''
#include <iostream>
#include <filesystem>
using namespace std;
using namespace std::filesystem;

int main() {
    // Your file manager implementation here
    
    return 0;
}''',
        'testCases': [
          {'operation': 'list files', 'expected': 'Display file list'},
          {'operation': 'create file', 'expected': 'File created successfully'},
        ],
        'bonusFeatures': [
          'File search functionality',
          'File permissions management',
          'Recursive directory operations',
        ],
      },
      {
        'id': 'data_structures',
        'title': 'Data Structures Library',
        'description': 'Implement common data structures like linked list, stack, and queue.',
        'difficulty': 'Advanced',
        'estimatedTime': 300,
        'points': 100,
        'requirements': [
          'Implement linked list with insert, delete, search',
          'Implement stack with push, pop, peek',
          'Implement queue with enqueue, dequeue',
          'Include proper error handling',
        ],
        'starterCode': '''
#include <iostream>
using namespace std;

// Your data structure implementations here

int main() {
    // Test your data structures here
    
    return 0;
}''',
        'testCases': [
          {'structure': 'linked_list', 'operation': 'insert', 'expected': 'Element inserted'},
          {'structure': 'stack', 'operation': 'push_pop', 'expected': 'LIFO behavior'},
        ],
        'bonusFeatures': [
          'Generic templates for any data type',
          'Iterator support',
          'Performance benchmarking',
        ],
      },
      {
        'id': 'game_engine',
        'title': 'Simple Game Engine',
        'description': 'Build a basic game engine with game loop, entities, and collision detection.',
        'difficulty': 'Advanced',
        'estimatedTime': 480,
        'points': 150,
        'requirements': [
          'Implement game loop with fixed timestep',
          'Create entity system with position, velocity, acceleration',
          'Add collision detection between entities',
          'Include basic physics simulation',
        ],
        'starterCode': '''
#include <iostream>
#include <vector>
using namespace std;

class Entity {
    // Your entity class implementation
};

class GameEngine {
    // Your game engine implementation
};

int main() {
    // Your game implementation here
    
    return 0;
}''',
        'testCases': [
          {'test': 'entity_movement', 'expected': 'Smooth movement'},
          {'test': 'collision_detection', 'expected': 'Accurate collision detection'},
        ],
        'bonusFeatures': [
          'Sprite rendering system',
          'Sound effects integration',
          'Save/load game state',
        ],
      },
    ]);
  }

  /// Load leaderboard data
  Future<void> _loadLeaderboard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final leaderboardData = prefs.getString('leaderboard');
      
      if (leaderboardData != null) {
        // Parse leaderboard data (simplified)
        _leaderboard['daily'] = [];
        _leaderboard['weekly'] = [];
        _leaderboard['monthly'] = [];
        _leaderboard['all_time'] = [];
      }
    } catch (e) {
      Logger.error('Failed to load leaderboard', e);
    }
  }

  /// Get today's challenge
  Map<String, dynamic> getTodaysChallenge() {
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    for (final challenge in _dailyChallenges) {
      if (challenge['date'] == today) {
        return challenge;
      }
    }
    
    // Return first challenge if today's not found
    return _dailyChallenges.isNotEmpty ? _dailyChallenges.first : {};
  }

  /// Get all projects
  List<Map<String, dynamic>> getAllProjects() {
    return List.from(_projects);
  }

  /// Get projects by difficulty
  List<Map<String, dynamic>> getProjectsByDifficulty(String difficulty) {
    return _projects.where((project) => 
      project['difficulty'].toLowerCase() == difficulty.toLowerCase()
    ).toList();
  }

  /// Submit challenge solution
  Future<Map<String, dynamic>> submitChallengeSolution(
    String challengeId, 
    String solution,
    {int? timeSpent}
  ) async {
    try {
      final challenge = _dailyChallenges.firstWhere(
        (c) => c['id'] == challengeId,
        orElse: () => {},
      );

      if (challenge.isEmpty) {
        return {
          'success': false,
          'message': 'Challenge not found',
        };
      }

      // Simulate solution validation
      final result = await _validateSolution(challenge, solution);
      
      if (result['success']) {
        await _updateChallengeProgress(challengeId, timeSpent: timeSpent);
      }

      return result;
    } catch (e) {
      Logger.error('Failed to submit challenge solution', e);
      return {
        'success': false,
        'message': 'Error submitting solution',
      };
    }
  }

  /// Validate solution
  Future<Map<String, dynamic>> _validateSolution(
    Map<String, dynamic> challenge, 
    String solution
  ) async {
    // Simulate code execution and validation
    await Future.delayed(const Duration(seconds: 2));
    
    // For demo purposes, assume solution is correct if it contains key elements
    final testCases = challenge['testCases'] as List<dynamic>;
    bool allTestsPassed = true;
    
    for (final testCase in testCases) {
      // Simplified validation - in real implementation, this would execute the code
      if (!solution.contains('cout') || !solution.contains('return 0')) {
        allTestsPassed = false;
        break;
      }
    }

    return {
      'success': allTestsPassed,
      'message': allTestsPassed ? 'Solution accepted!' : 'Some test cases failed',
      'testResults': testCases.map((tc) => {
        'input': tc['input'],
        'expected': tc['expected'],
        'passed': allTestsPassed,
      }).toList(),
      'points': allTestsPassed ? challenge['points'] : 0,
    };
  }

  /// Update challenge progress
  Future<void> _updateChallengeProgress(String challengeId, {int? timeSpent}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Update daily challenge completion
      final completedChallenges = prefs.getStringList('completedChallenges') ?? [];
      if (!completedChallenges.contains(challengeId)) {
        completedChallenges.add(challengeId);
        await prefs.setStringList('completedChallenges', completedChallenges);
      }
      
      // Update points
      final totalPoints = prefs.getInt('totalPoints') ?? 0;
      final challenge = _dailyChallenges.firstWhere(
        (c) => c['id'] == challengeId,
        orElse: () => {'points': 0},
      );
      await prefs.setInt('totalPoints', totalPoints + challenge['points']);
      
      // Update streak
      await _updateChallengeStreak();
      
      Logger.info('Challenge progress updated: $challengeId');
    } catch (e) {
      Logger.error('Failed to update challenge progress', e);
    }
  }

  /// Update challenge streak
  Future<void> _updateChallengeStreak() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().split('T')[0];
      final lastChallengeDate = prefs.getString('lastChallengeDate');
      
      int currentStreak = prefs.getInt('challengeStreak') ?? 0;
      
      if (lastChallengeDate == today) {
        // Already completed today
        return;
      } else if (lastChallengeDate != null) {
        final lastDate = DateTime.parse(lastChallengeDate);
        final todayDate = DateTime.now();
        final daysDifference = todayDate.difference(lastDate).inDays;
        
        if (daysDifference == 1) {
          // Consecutive day
          currentStreak++;
        } else if (daysDifference > 1) {
          // Streak broken
          currentStreak = 1;
        }
      } else {
        // First challenge
        currentStreak = 1;
      }
      
      await prefs.setInt('challengeStreak', currentStreak);
      await prefs.setString('lastChallengeDate', today);
      
      Logger.info('Challenge streak updated: $currentStreak');
    } catch (e) {
      Logger.error('Failed to update challenge streak', e);
    }
  }

  /// Get user statistics
  Map<String, dynamic> getUserStatistics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      return {
        'totalPoints': prefs.getInt('totalPoints') ?? 0,
        'challengeStreak': prefs.getInt('challengeStreak') ?? 0,
        'completedChallenges': prefs.getStringList('completedChallenges')?.length ?? 0,
        'completedProjects': prefs.getStringList('completedProjects')?.length ?? 0,
        'lastChallengeDate': prefs.getString('lastChallengeDate'),
      };
    } catch (e) {
      Logger.error('Failed to get user statistics', e);
      return {};
    }
  }

  /// Get leaderboard
  Map<String, dynamic> getLeaderboard() {
    return Map.from(_leaderboard);
  }

  /// Submit project
  Future<Map<String, dynamic>> submitProject(
    String projectId, 
    String solution,
    {int? timeSpent}
  ) async {
    try {
      final project = _projects.firstWhere(
        (p) => p['id'] == projectId,
        orElse: () => {},
      );

      if (project.isEmpty) {
        return {
          'success': false,
          'message': 'Project not found',
        };
      }

      // Simulate project validation
      final result = await _validateProject(project, solution);
      
      if (result['success']) {
        await _updateProjectProgress(projectId, timeSpent: timeSpent);
      }

      return result;
    } catch (e) {
      Logger.error('Failed to submit project', e);
      return {
        'success': false,
        'message': 'Error submitting project',
      };
    }
  }

  /// Validate project
  Future<Map<String, dynamic>> _validateProject(
    Map<String, dynamic> project, 
    String solution
  ) async {
    // Simulate project validation
    await Future.delayed(const Duration(seconds: 3));
    
    // For demo purposes, assume project is valid if it meets basic criteria
    final requirements = project['requirements'] as List<dynamic>;
    bool meetsRequirements = true;
    
    for (final requirement in requirements) {
      // Simplified validation
      if (!solution.toLowerCase().contains('main') || 
          !solution.toLowerCase().contains('cout')) {
        meetsRequirements = false;
        break;
      }
    }

    return {
      'success': meetsRequirements,
      'message': meetsRequirements ? 'Project completed successfully!' : 'Project needs more work',
      'points': meetsRequirements ? project['points'] : 0,
      'feedback': meetsRequirements ? 
        'Great job! Your project meets all requirements.' : 
        'Try to implement all the required features.',
    };
  }

  /// Update project progress
  Future<void> _updateProjectProgress(String projectId, {int? timeSpent}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Update project completion
      final completedProjects = prefs.getStringList('completedProjects') ?? [];
      if (!completedProjects.contains(projectId)) {
        completedProjects.add(projectId);
        await prefs.setStringList('completedProjects', completedProjects);
      }
      
      // Update points
      final totalPoints = prefs.getInt('totalPoints') ?? 0;
      final project = _projects.firstWhere(
        (p) => p['id'] == projectId,
        orElse: () => {'points': 0},
      );
      await prefs.setInt('totalPoints', totalPoints + project['points']);
      
      Logger.info('Project progress updated: $projectId');
    } catch (e) {
      Logger.error('Failed to update project progress', e);
    }
  }
}