import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../domain/entities/lesson.dart';
import '../data/models/lesson_model.dart';
import '../core/errors/error_handler.dart';
import '../utils/logger.dart';
import '../data/grade6_lessons.dart';

class LessonProvider extends ChangeNotifier {
  static const String dollarSign = '\$';
  static const String _lessonsKey = 'saved_lessons';
  static const String _progressKey = 'lesson_progress';

  List<Lesson> _lessons = [];
  Map<String, bool> _lessonProgress = {};
  bool _isInitialized = false;

  LessonProvider() {
    // Initialize synchronously with default lessons first
    _loadDefaultLessons();
    // Then initialize asynchronously
    _initializeLessons();
  }

  Future<void> _initializeLessons() async {
    if (_isInitialized) return;

    try {
      await _loadProgress();
      // Default lessons are already loaded in constructor
      _isInitialized = true;
      notifyListeners(); // Notify listeners that initialization is complete
      Logger.info(
        'Lesson provider initialized with ${_lessons.length} lessons',
      );
    } catch (e) {
      await ErrorHandler.handleDataError(
        'Failed to initialize lesson provider',
        code: 'lesson_provider_init_error',
        details: e.toString(),
      );
      // Default lessons are already loaded in constructor
      _isInitialized = true;
      notifyListeners(); // Notify listeners that initialization is complete
    }
  }

  void _loadDefaultLessons() {
    _lessons = Grade6Lessons.getLessons();
  }

  // Getters
  List<Lesson> get lessons => _lessons;
  List<Lesson> get completedLessons =>
      _lessons.where((lesson) => _lessonProgress[lesson.id] ?? false).toList();
  List<Lesson> get beginnerLessons =>
      _lessons.where((lesson) => lesson.difficulty == 'Beginner').toList();
  List<Lesson> get intermediateLessons =>
      _lessons.where((lesson) => lesson.difficulty == 'Intermediate').toList();
  List<Lesson> get advancedLessons =>
      _lessons.where((lesson) => lesson.difficulty == 'Advanced').toList();

  Lesson? getLessonById(String id) {
    try {
      return _lessons.firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }

  void markLessonAsCompleted(String lessonId) {
    _lessonProgress[lessonId] = true;
    notifyListeners();
    _saveProgress();
  }

  bool isLessonCompleted(String lessonId) {
    return _lessonProgress[lessonId] ?? false;
  }

  double getProgressPercentage() {
    if (_lessons.isEmpty) return 0.0;
    final completedCount = _lessons
        .where((lesson) => _lessonProgress[lesson.id] ?? false)
        .length;
    return (completedCount / _lessons.length) * 100;
  }

  Future<void> resetProgress() async {
    _lessonProgress.clear();
    notifyListeners();
    await _saveProgress();
  }

  void addCustomLesson(Lesson lesson) {
    _lessons.add(lesson);
    notifyListeners();
    _saveLessons();
  }

  void removeCustomLesson(String lessonId) {
    _lessons.removeWhere((lesson) => lesson.id == lessonId);
    notifyListeners();
    _saveLessons();
  }

  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString(_progressKey);
      if (progressJson != null) {
        final Map<String, dynamic> progressMap = json.decode(progressJson);
        _lessonProgress = progressMap.map(
          (key, value) => MapEntry(key, value as bool),
        );
      }
    } catch (e) {
      Logger.error('Failed to load lesson progress: $e');
    }
  }

  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = json.encode(_lessonProgress);
      await prefs.setString(_progressKey, progressJson);
    } catch (e) {
      Logger.error('Failed to save lesson progress: $e');
    }
  }

  Future<void> _saveLessons() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lessonsJson = json.encode(
        _lessons
            .map((lesson) => LessonModel.fromEntity(lesson).toJson())
            .toList(),
      );
      await prefs.setString(_lessonsKey, lessonsJson);
    } catch (e) {
      Logger.error('Failed to save lessons: $e');
    }
  }

  // Search functionality
  List<Lesson> searchLessons(String query) {
    if (query.isEmpty) return _lessons;

    final lowercaseQuery = query.toLowerCase();
    return _lessons.where((lesson) {
      return lesson.title.toLowerCase().contains(lowercaseQuery) ||
          lesson.description.toLowerCase().contains(lowercaseQuery) ||
          lesson.difficulty.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Filter by difficulty
  List<Lesson> getLessonsByDifficulty(String difficulty) {
    return _lessons.where((lesson) => lesson.difficulty == difficulty).toList();
  }

  // Get next lesson
  Lesson? getNextLesson(String currentLessonId) {
    final currentIndex = _lessons.indexWhere(
      (lesson) => lesson.id == currentLessonId,
    );
    if (currentIndex == -1 || currentIndex >= _lessons.length - 1) {
      return null;
    }
    return _lessons[currentIndex + 1];
  }

  // Get previous lesson
  Lesson? getPreviousLesson(String currentLessonId) {
    final currentIndex = _lessons.indexWhere(
      (lesson) => lesson.id == currentLessonId,
    );
    if (currentIndex <= 0) {
      return null;
    }
    return _lessons[currentIndex - 1];
  }

  // Get lessons by estimated time
  List<Lesson> getLessonsByTimeRange(int minMinutes, int maxMinutes) {
    return _lessons.where((lesson) {
      final time = lesson.estimatedTimeMinutes;
      return time >= minMinutes && time <= maxMinutes;
    }).toList();
  }

  // Get random lesson
  Lesson? getRandomLesson() {
    if (_lessons.isEmpty) return null;
    final random = DateTime.now().millisecondsSinceEpoch % _lessons.length;
    return _lessons[random];
  }

  // Get lesson statistics
  Map<String, int> getLessonStatistics() {
    final total = _lessons.length;
    final completed = _lessons
        .where((lesson) => _lessonProgress[lesson.id] ?? false)
        .length;
    final beginner = _lessons
        .where((lesson) => lesson.difficulty == 'Beginner')
        .length;
    final intermediate = _lessons
        .where((lesson) => lesson.difficulty == 'Intermediate')
        .length;
    final advanced = _lessons
        .where((lesson) => lesson.difficulty == 'Advanced')
        .length;

    return {
      'total': total,
      'completed': completed,
      'beginner': beginner,
      'intermediate': intermediate,
      'advanced': advanced,
    };
  }

  // Check if all lessons are completed
  bool get allLessonsCompleted {
    return _lessons.isNotEmpty &&
        _lessons.every((lesson) => _lessonProgress[lesson.id] ?? false);
  }

  // Get completion streak
  int getCompletionStreak() {
    int streak = 0;
    for (final lesson in _lessons) {
      if (_lessonProgress[lesson.id] ?? false) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}
