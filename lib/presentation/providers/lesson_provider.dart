import 'package:flutter/foundation.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/usecases/get_lessons_usecase.dart';
import '../../domain/usecases/complete_lesson_usecase.dart';
import '../../core/errors/failures.dart';

/// Provider for managing lesson state
class LessonProvider extends ChangeNotifier {
  final GetLessonsUseCase _getLessonsUseCase;
  final CompleteLessonUseCase _completeLessonUseCase;

  LessonProvider(this._getLessonsUseCase, this._completeLessonUseCase) {
    _initializeLessons();
  }

  List<Lesson> _lessons = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Lesson> get lessons => _lessons;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Lesson> get completedLessons =>
      _lessons.where((lesson) => lesson.isCompleted).toList();
  List<Lesson> get beginnerLessons =>
      _lessons.where((lesson) => lesson.difficulty == 'Beginner').toList();
  List<Lesson> get intermediateLessons =>
      _lessons.where((lesson) => lesson.difficulty == 'Intermediate').toList();
  List<Lesson> get advancedLessons =>
      _lessons.where((lesson) => lesson.difficulty == 'Advanced').toList();

  /// Initializes lessons by loading them from the repository
  Future<void> _initializeLessons() async {
    _setLoading(true);
    try {
      _lessons = await _getLessonsUseCase();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  /// Refreshes the lessons list
  Future<void> refreshLessons() async {
    await _initializeLessons();
  }

  /// Gets a lesson by its ID
  Lesson? getLessonById(String id) {
    try {
      return _lessons.firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Completes a lesson
  Future<void> completeLesson(String lessonId) async {
    try {
      await _completeLessonUseCase(lessonId);

      // Update local state
      final index = _lessons.indexWhere((lesson) => lesson.id == lessonId);
      if (index != -1) {
        _lessons[index] = _lessons[index].copyWith(isCompleted: true);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  /// Searches lessons by query
  List<Lesson> searchLessons(String query) {
    if (query.isEmpty) return _lessons;

    final lowercaseQuery = query.toLowerCase();
    return _lessons.where((lesson) {
      return lesson.title.toLowerCase().contains(lowercaseQuery) ||
          lesson.description.toLowerCase().contains(lowercaseQuery) ||
          lesson.difficulty.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Gets lessons by difficulty
  List<Lesson> getLessonsByDifficulty(String difficulty) {
    return _lessons.where((lesson) => lesson.difficulty == difficulty).toList();
  }

  /// Gets the next lesson after the given lesson
  Lesson? getNextLesson(String currentLessonId) {
    final currentIndex = _lessons.indexWhere(
      (lesson) => lesson.id == currentLessonId,
    );
    if (currentIndex == -1 || currentIndex >= _lessons.length - 1) {
      return null;
    }
    return _lessons[currentIndex + 1];
  }

  /// Gets the previous lesson before the given lesson
  Lesson? getPreviousLesson(String currentLessonId) {
    final currentIndex = _lessons.indexWhere(
      (lesson) => lesson.id == currentLessonId,
    );
    if (currentIndex <= 0) {
      return null;
    }
    return _lessons[currentIndex - 1];
  }

  /// Gets lessons by time range
  List<Lesson> getLessonsByTimeRange(int minMinutes, int maxMinutes) {
    return _lessons.where((lesson) {
      return lesson.estimatedTimeMinutes >= minMinutes &&
          lesson.estimatedTimeMinutes <= maxMinutes;
    }).toList();
  }

  /// Gets a random lesson
  Lesson? getRandomLesson() {
    if (_lessons.isEmpty) return null;
    final random = DateTime.now().millisecondsSinceEpoch % _lessons.length;
    return _lessons[random];
  }

  /// Gets overall progress percentage
  double getProgressPercentage() {
    if (_lessons.isEmpty) return 0.0;
    final completedCount = _lessons
        .where((lesson) => lesson.isCompleted)
        .length;
    return (completedCount / _lessons.length) * 100;
  }

  /// Gets lesson statistics
  Map<String, int> getLessonStatistics() {
    final total = _lessons.length;
    final completed = _lessons.where((lesson) => lesson.isCompleted).length;
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

  /// Gets completion streak
  int getCompletionStreak() {
    int streak = 0;
    for (final lesson in _lessons) {
      if (lesson.isCompleted) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  /// Checks if all lessons are completed
  bool get allLessonsCompleted {
    return _lessons.isNotEmpty &&
        _lessons.every((lesson) => lesson.isCompleted);
  }

  /// Sets loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Gets user-friendly error message
  String _getErrorMessage(dynamic error) {
    if (error is Failure) {
      return error.message;
    }
    return 'Something went wrong. Please try again.';
  }
}
