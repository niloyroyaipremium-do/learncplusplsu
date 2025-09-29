import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

/// Learning Path Service
/// 
/// Handles personalized learning recommendations, adaptive difficulty,
/// and progress-based content unlocking
class LearningPathService {
  static final LearningPathService _instance = LearningPathService._internal();
  factory LearningPathService() => _instance;
  LearningPathService._internal();

  bool _isInitialized = false;
  final Map<String, dynamic> _userProfile = {};
  final List<Map<String, dynamic>> _learningPaths = [];
  final Map<String, int> _difficultyScores = {};

  /// Initialize learning path service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadUserProfile();
      await _generateLearningPaths();
      await _calculateDifficultyScores();
      
      _isInitialized = true;
      Logger.info('Learning path service initialized');
    } catch (e) {
      Logger.error('Failed to initialize learning path service', e);
    }
  }

  /// Load user profile from storage
  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _userProfile['currentLevel'] = prefs.getInt('currentLevel') ?? 1;
      _userProfile['totalXpEarned'] = prefs.getInt('totalXpEarned') ?? 0;
      _userProfile['lessonsCompleted'] = prefs.getInt('lessonsCompleted') ?? 0;
      _userProfile['learningStyle'] = prefs.getString('learningStyle') ?? 'balanced';
      _userProfile['preferredDifficulty'] = prefs.getString('preferredDifficulty') ?? 'medium';
      _userProfile['timePerSession'] = prefs.getInt('timePerSession') ?? 30;
      _userProfile['weakAreas'] = prefs.getStringList('weakAreas') ?? [];
      _userProfile['strongAreas'] = prefs.getStringList('strongAreas') ?? [];
      
      Logger.info('User profile loaded: $_userProfile');
    } catch (e) {
      Logger.error('Failed to load user profile', e);
    }
  }

  /// Generate personalized learning paths
  Future<void> _generateLearningPaths() async {
    _learningPaths.clear();
    
    // Beginner Path
    _learningPaths.add({
      'id': 'beginner',
      'name': 'C++ Fundamentals',
      'description': 'Start your C++ journey with the basics',
      'difficulty': 'beginner',
      'estimatedTime': 120,
      'lessons': [
        'variables_and_data_types',
        'operators',
        'input_output',
        'control_structures',
        'functions_basics',
      ],
      'prerequisites': [],
      'targetAudience': 'Complete beginners',
    });

    // Intermediate Path
    _learningPaths.add({
      'id': 'intermediate',
      'name': 'Object-Oriented Programming',
      'description': 'Master OOP concepts in C++',
      'difficulty': 'intermediate',
      'estimatedTime': 180,
      'lessons': [
        'classes_and_objects',
        'inheritance',
        'polymorphism',
        'encapsulation',
        'constructors_destructors',
      ],
      'prerequisites': ['beginner'],
      'targetAudience': 'Those familiar with basic C++',
    });

    // Advanced Path
    _learningPaths.add({
      'id': 'advanced',
      'name': 'Advanced C++ Concepts',
      'description': 'Explore advanced C++ features',
      'difficulty': 'advanced',
      'estimatedTime': 240,
      'lessons': [
        'templates',
        'smart_pointers',
        'stl_containers',
        'algorithms',
        'memory_management',
      ],
      'prerequisites': ['intermediate'],
      'targetAudience': 'Experienced C++ developers',
    });

    // Project-Based Path
    _learningPaths.add({
      'id': 'projects',
      'name': 'C++ Projects',
      'description': 'Build real-world applications',
      'difficulty': 'intermediate',
      'estimatedTime': 300,
      'lessons': [
        'calculator_app',
        'file_manager',
        'data_structures',
        'gui_application',
        'game_development',
      ],
      'prerequisites': ['intermediate'],
      'targetAudience': 'Hands-on learners',
    });

    Logger.info('Generated ${_learningPaths.length} learning paths');
  }

  /// Calculate difficulty scores for lessons
  Future<void> _calculateDifficultyScores() async {
    final lessonDifficulties = {
      'variables_and_data_types': 1,
      'operators': 1,
      'input_output': 1,
      'control_structures': 2,
      'functions_basics': 2,
      'classes_and_objects': 3,
      'inheritance': 4,
      'polymorphism': 4,
      'encapsulation': 3,
      'constructors_destructors': 3,
      'templates': 5,
      'smart_pointers': 5,
      'stl_containers': 4,
      'algorithms': 5,
      'memory_management': 5,
    };

    _difficultyScores.addAll(lessonDifficulties);
  }

  /// Get recommended learning path for user
  Map<String, dynamic> getRecommendedPath() {
    final userLevel = _userProfile['currentLevel'] ?? 1;
    final learningStyle = _userProfile['learningStyle'] ?? 'balanced';
    
    // Filter paths based on user level
    List<Map<String, dynamic>> availablePaths = _learningPaths.where((path) {
      final pathDifficulty = _getDifficultyLevel(path['difficulty']);
      return pathDifficulty <= userLevel + 1; // Allow one level ahead
    }).toList();

    // Sort by relevance
    availablePaths.sort((a, b) {
      final aRelevance = _calculatePathRelevance(a);
      final bRelevance = _calculatePathRelevance(b);
      return bRelevance.compareTo(aRelevance);
    });

    return availablePaths.isNotEmpty ? availablePaths.first : _learningPaths.first;
  }

  /// Calculate path relevance score
  int _calculatePathRelevance(Map<String, dynamic> path) {
    int score = 0;
    
    // Level matching
    final userLevel = _userProfile['currentLevel'] ?? 1;
    final pathDifficulty = _getDifficultyLevel(path['difficulty']);
    if (pathDifficulty == userLevel) score += 10;
    else if (pathDifficulty == userLevel + 1) score += 5;
    
    // Learning style matching
    final learningStyle = _userProfile['learningStyle'] ?? 'balanced';
    if (learningStyle == 'hands_on' && path['id'] == 'projects') score += 15;
    if (learningStyle == 'theoretical' && path['id'] == 'advanced') score += 15;
    
    // Time availability
    final userTime = _userProfile['timePerSession'] ?? 30;
    final pathTime = path['estimatedTime'] ?? 120;
    if (pathTime <= userTime * 4) score += 5; // Can complete in 4 sessions
    
    // Weak areas focus
    final weakAreas = _userProfile['weakAreas'] ?? [];
    for (final lesson in path['lessons']) {
      if (weakAreas.contains(lesson)) score += 3;
    }
    
    return score;
  }

  /// Get difficulty level as integer
  int _getDifficultyLevel(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner': return 1;
      case 'intermediate': return 2;
      case 'advanced': return 3;
      default: return 1;
    }
  }

  /// Get next recommended lesson
  Map<String, dynamic> getNextLesson() {
    final recommendedPath = getRecommendedPath();
    final completedLessons = _userProfile['completedLessons'] ?? <String>[];
    
    // Find first uncompleted lesson in recommended path
    for (final lessonId in recommendedPath['lessons']) {
      if (!completedLessons.contains(lessonId)) {
        return _getLessonDetails(lessonId);
      }
    }
    
    // If all lessons completed, suggest next path
    return _getNextPathLesson();
  }

  /// Get lesson details
  Map<String, dynamic> _getLessonDetails(String lessonId) {
    // This would typically fetch from a database
    // For now, return mock data
    return {
      'id': lessonId,
      'title': _getLessonTitle(lessonId),
      'description': _getLessonDescription(lessonId),
      'difficulty': _getLessonDifficulty(lessonId),
      'estimatedTime': _getLessonTime(lessonId),
      'prerequisites': _getLessonPrerequisites(lessonId),
      'content': _getLessonContent(lessonId),
    };
  }

  /// Get next path lesson
  Map<String, dynamic> _getNextPathLesson() {
    final allPaths = _learningPaths;
    final currentPathId = _userProfile['currentPathId'] ?? 'beginner';
    
    // Find next path
    int currentIndex = allPaths.indexWhere((path) => path['id'] == currentPathId);
    if (currentIndex < allPaths.length - 1) {
      final nextPath = allPaths[currentIndex + 1];
      return _getLessonDetails(nextPath['lessons'].first);
    }
    
    // Return first lesson of first path if at end
    return _getLessonDetails(allPaths.first['lessons'].first);
  }

  /// Get lesson title
  String _getLessonTitle(String lessonId) {
    final titles = {
      'variables_and_data_types': 'Variables and Data Types',
      'operators': 'Operators and Expressions',
      'input_output': 'Input and Output',
      'control_structures': 'Control Structures',
      'functions_basics': 'Functions Basics',
      'classes_and_objects': 'Classes and Objects',
      'inheritance': 'Inheritance',
      'polymorphism': 'Polymorphism',
      'encapsulation': 'Encapsulation',
      'constructors_destructors': 'Constructors and Destructors',
      'templates': 'Templates',
      'smart_pointers': 'Smart Pointers',
      'stl_containers': 'STL Containers',
      'algorithms': 'STL Algorithms',
      'memory_management': 'Memory Management',
    };
    return titles[lessonId] ?? 'Unknown Lesson';
  }

  /// Get lesson description
  String _getLessonDescription(String lessonId) {
    final descriptions = {
      'variables_and_data_types': 'Learn about different data types and how to declare variables in C++.',
      'operators': 'Master arithmetic, logical, and comparison operators in C++.',
      'input_output': 'Understand how to get input from users and display output.',
      'control_structures': 'Learn about if-else statements, loops, and switch cases.',
      'functions_basics': 'Create and use functions to organize your code.',
    };
    return descriptions[lessonId] ?? 'Learn this important C++ concept.';
  }

  /// Get lesson difficulty
  String _getLessonDifficulty(String lessonId) {
    final score = _difficultyScores[lessonId] ?? 1;
    if (score <= 2) return 'Beginner';
    if (score <= 3) return 'Intermediate';
    return 'Advanced';
  }

  /// Get lesson time
  int _getLessonTime(String lessonId) {
    final times = {
      'variables_and_data_types': 15,
      'operators': 20,
      'input_output': 10,
      'control_structures': 25,
      'functions_basics': 30,
      'classes_and_objects': 45,
      'inheritance': 60,
      'polymorphism': 60,
      'encapsulation': 30,
      'constructors_destructors': 40,
      'templates': 90,
      'smart_pointers': 75,
      'stl_containers': 60,
      'algorithms': 90,
      'memory_management': 120,
    };
    return times[lessonId] ?? 30;
  }

  /// Get lesson prerequisites
  List<String> _getLessonPrerequisites(String lessonId) {
    final prerequisites = {
      'operators': ['variables_and_data_types'],
      'control_structures': ['operators'],
      'functions_basics': ['control_structures'],
      'classes_and_objects': ['functions_basics'],
      'inheritance': ['classes_and_objects'],
      'polymorphism': ['inheritance'],
      'templates': ['polymorphism'],
      'smart_pointers': ['templates'],
    };
    return prerequisites[lessonId] ?? [];
  }

  /// Get lesson content
  Map<String, dynamic> _getLessonContent(String lessonId) {
    // This would typically fetch from a database
    return {
      'theory': 'Lesson theory content...',
      'examples': ['Example 1', 'Example 2'],
      'exercises': ['Exercise 1', 'Exercise 2'],
      'codeSnippets': ['Code snippet 1', 'Code snippet 2'],
    };
  }

  /// Update user progress
  Future<void> updateProgress(String lessonId, {bool completed = false, int? timeSpent, int? attempts}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (completed) {
        final completedLessons = prefs.getStringList('completedLessons') ?? [];
        if (!completedLessons.contains(lessonId)) {
          completedLessons.add(lessonId);
          await prefs.setStringList('completedLessons', completedLessons);
          
          // Update user profile
          _userProfile['lessonsCompleted'] = (_userProfile['lessonsCompleted'] ?? 0) + 1;
          _userProfile['totalXpEarned'] = (_userProfile['totalXpEarned'] ?? 0) + _calculateXpReward(lessonId);
          
          // Check for level up
          await _checkLevelUp();
        }
      }
      
      // Update learning analytics
      await _updateLearningAnalytics(lessonId, timeSpent: timeSpent, attempts: attempts);
      
      Logger.info('Progress updated for lesson: $lessonId');
    } catch (e) {
      Logger.error('Failed to update progress', e);
    }
  }

  /// Calculate XP reward for lesson
  int _calculateXpReward(String lessonId) {
    final difficulty = _difficultyScores[lessonId] ?? 1;
    return difficulty * 10; // Base XP per difficulty level
  }

  /// Check for level up
  Future<void> _checkLevelUp() async {
    final currentLevel = _userProfile['currentLevel'] ?? 1;
    final totalXp = _userProfile['totalXpEarned'] ?? 0;
    final xpNeeded = currentLevel * 100; // 100 XP per level
    
    if (totalXp >= xpNeeded) {
      final newLevel = currentLevel + 1;
      _userProfile['currentLevel'] = newLevel;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentLevel', newLevel);
      
      Logger.info('Level up! New level: $newLevel');
    }
  }

  /// Update learning analytics
  Future<void> _updateLearningAnalytics(String lessonId, {int? timeSpent, int? attempts}) async {
    // Track learning patterns
    final analytics = {
      'lessonId': lessonId,
      'timeSpent': timeSpent,
      'attempts': attempts,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    // Store analytics data
    final prefs = await SharedPreferences.getInstance();
    final analyticsList = prefs.getStringList('learningAnalytics') ?? [];
    analyticsList.add(analytics.toString());
    await prefs.setStringList('learningAnalytics', analyticsList);
  }

  /// Get all available learning paths
  List<Map<String, dynamic>> getAllPaths() {
    return List.from(_learningPaths);
  }

  /// Get user's current progress
  Map<String, dynamic> getUserProgress() {
    return Map.from(_userProfile);
  }

  /// Set user learning preferences
  Future<void> setLearningPreferences({
    String? learningStyle,
    String? preferredDifficulty,
    int? timePerSession,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (learningStyle != null) {
        _userProfile['learningStyle'] = learningStyle;
        await prefs.setString('learningStyle', learningStyle);
      }
      
      if (preferredDifficulty != null) {
        _userProfile['preferredDifficulty'] = preferredDifficulty;
        await prefs.setString('preferredDifficulty', preferredDifficulty);
      }
      
      if (timePerSession != null) {
        _userProfile['timePerSession'] = timePerSession;
        await prefs.setInt('timePerSession', timePerSession);
      }
      
      Logger.info('Learning preferences updated');
    } catch (e) {
      Logger.error('Failed to update learning preferences', e);
    }
  }
}