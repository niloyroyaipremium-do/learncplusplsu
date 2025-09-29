import '../entities/lesson.dart';

/// Abstract repository interface for lesson operations
abstract class LessonRepository {
  /// Gets all available lessons
  Future<List<Lesson>> getAllLessons();

  /// Gets a lesson by its ID
  Future<Lesson?> getLessonById(String id);

  /// Gets lessons by difficulty level
  Future<List<Lesson>> getLessonsByDifficulty(String difficulty);

  /// Gets completed lessons
  Future<List<Lesson>> getCompletedLessons();

  /// Searches lessons by query
  Future<List<Lesson>> searchLessons(String query);

  /// Gets the next lesson after the given lesson
  Future<Lesson?> getNextLesson(String currentLessonId);

  /// Gets the previous lesson before the given lesson
  Future<Lesson?> getPreviousLesson(String currentLessonId);

  /// Gets lessons by time range
  Future<List<Lesson>> getLessonsByTimeRange(int minMinutes, int maxMinutes);

  /// Gets a random lesson
  Future<Lesson?> getRandomLesson();

  /// Marks a lesson as completed
  Future<void> markLessonAsCompleted(String lessonId);

  /// Checks if a lesson is completed
  Future<bool> isLessonCompleted(String lessonId);

  /// Gets overall progress percentage
  Future<double> getProgressPercentage();

  /// Adds a custom lesson
  Future<void> addCustomLesson(Lesson lesson);

  /// Removes a custom lesson
  Future<void> removeCustomLesson(String lessonId);

  /// Resets all progress
  Future<void> resetProgress();

  /// Gets lesson statistics
  Future<Map<String, int>> getLessonStatistics();

  /// Gets completion streak
  Future<int> getCompletionStreak();

  /// Checks if all lessons are completed
  Future<bool> areAllLessonsCompleted();
}
