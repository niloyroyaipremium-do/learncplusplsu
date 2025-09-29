import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/local_storage_datasource.dart';
import '../models/lesson_model.dart';
import '../../data/grade6_lessons.dart';

/// Implementation of lesson repository
class LessonRepositoryImpl implements LessonRepository {
  final LocalStorageDataSource _localStorage;

  LessonRepositoryImpl(this._localStorage);

  @override
  Future<List<Lesson>> getAllLessons() async {
    try {
      final lessons = await _localStorage.getLessons();
      if (lessons.isEmpty) {
        // Load default lessons if none saved
        final defaultLessons = Grade6Lessons.getLessons()
            .map((lesson) => LessonModel.fromEntity(lesson))
            .toList();
        await _localStorage.saveLessons(defaultLessons);
        return defaultLessons.map((lesson) => lesson.toEntity()).toList();
      }
      return lessons.map((lesson) => lesson.toEntity()).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get all lessons',
        originalException: e,
      );
    }
  }

  @override
  Future<Lesson?> getLessonById(String id) async {
    try {
      final lessons = await getAllLessons();
      return lessons.where((lesson) => lesson.id == id).firstOrNull;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get lesson by ID: $id',
        originalException: e,
      );
    }
  }

  @override
  Future<List<Lesson>> getLessonsByDifficulty(String difficulty) async {
    try {
      final lessons = await getAllLessons();
      return lessons
          .where((lesson) => lesson.difficulty == difficulty)
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get lessons by difficulty: $difficulty',
        originalException: e,
      );
    }
  }

  @override
  Future<List<Lesson>> getCompletedLessons() async {
    try {
      final progress = await _localStorage.getLessonProgress();
      final lessons = await getAllLessons();
      return lessons.where((lesson) => progress[lesson.id] == true).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get completed lessons',
        originalException: e,
      );
    }
  }

  @override
  Future<List<Lesson>> searchLessons(String query) async {
    try {
      final lessons = await getAllLessons();
      if (query.isEmpty) return lessons;

      final lowercaseQuery = query.toLowerCase();
      return lessons.where((lesson) {
        return lesson.title.toLowerCase().contains(lowercaseQuery) ||
            lesson.description.toLowerCase().contains(lowercaseQuery) ||
            lesson.difficulty.toLowerCase().contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to search lessons',
        originalException: e,
      );
    }
  }

  @override
  Future<Lesson?> getNextLesson(String currentLessonId) async {
    try {
      final lessons = await getAllLessons();
      final currentIndex = lessons.indexWhere(
        (lesson) => lesson.id == currentLessonId,
      );
      if (currentIndex == -1 || currentIndex >= lessons.length - 1) {
        return null;
      }
      return lessons[currentIndex + 1];
    } catch (e) {
      throw CacheException(
        message: 'Failed to get next lesson',
        originalException: e,
      );
    }
  }

  @override
  Future<Lesson?> getPreviousLesson(String currentLessonId) async {
    try {
      final lessons = await getAllLessons();
      final currentIndex = lessons.indexWhere(
        (lesson) => lesson.id == currentLessonId,
      );
      if (currentIndex <= 0) {
        return null;
      }
      return lessons[currentIndex - 1];
    } catch (e) {
      throw CacheException(
        message: 'Failed to get previous lesson',
        originalException: e,
      );
    }
  }

  @override
  Future<List<Lesson>> getLessonsByTimeRange(
    int minMinutes,
    int maxMinutes,
  ) async {
    try {
      final lessons = await getAllLessons();
      return lessons.where((lesson) {
        return lesson.estimatedTimeMinutes >= minMinutes &&
            lesson.estimatedTimeMinutes <= maxMinutes;
      }).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get lessons by time range',
        originalException: e,
      );
    }
  }

  @override
  Future<Lesson?> getRandomLesson() async {
    try {
      final lessons = await getAllLessons();
      if (lessons.isEmpty) return null;
      final random = DateTime.now().millisecondsSinceEpoch % lessons.length;
      return lessons[random];
    } catch (e) {
      throw CacheException(
        message: 'Failed to get random lesson',
        originalException: e,
      );
    }
  }

  @override
  Future<void> markLessonAsCompleted(String lessonId) async {
    try {
      final progress = await _localStorage.getLessonProgress();
      progress[lessonId] = true;
      await _localStorage.saveLessonProgress(progress);
    } catch (e) {
      throw CacheException(
        message: 'Failed to mark lesson as completed',
        originalException: e,
      );
    }
  }

  @override
  Future<bool> isLessonCompleted(String lessonId) async {
    try {
      final progress = await _localStorage.getLessonProgress();
      return progress[lessonId] ?? false;
    } catch (e) {
      throw CacheException(
        message: 'Failed to check if lesson is completed',
        originalException: e,
      );
    }
  }

  @override
  Future<double> getProgressPercentage() async {
    try {
      final lessons = await getAllLessons();
      if (lessons.isEmpty) return 0.0;

      final progress = await _localStorage.getLessonProgress();
      final completedCount = lessons
          .where((lesson) => progress[lesson.id] == true)
          .length;
      return (completedCount / lessons.length) * 100;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get progress percentage',
        originalException: e,
      );
    }
  }

  @override
  Future<void> addCustomLesson(Lesson lesson) async {
    try {
      final lessons = await _localStorage.getLessons();
      final lessonModel = LessonModel.fromEntity(lesson);
      lessons.add(lessonModel);
      await _localStorage.saveLessons(lessons);
    } catch (e) {
      throw CacheException(
        message: 'Failed to add custom lesson',
        originalException: e,
      );
    }
  }

  @override
  Future<void> removeCustomLesson(String lessonId) async {
    try {
      final lessons = await _localStorage.getLessons();
      lessons.removeWhere((lesson) => lesson.id == lessonId);
      await _localStorage.saveLessons(lessons);
    } catch (e) {
      throw CacheException(
        message: 'Failed to remove custom lesson',
        originalException: e,
      );
    }
  }

  @override
  Future<void> resetProgress() async {
    try {
      await _localStorage.saveLessonProgress({});
    } catch (e) {
      throw CacheException(
        message: 'Failed to reset progress',
        originalException: e,
      );
    }
  }

  @override
  Future<Map<String, int>> getLessonStatistics() async {
    try {
      final lessons = await getAllLessons();
      final progress = await _localStorage.getLessonProgress();

      final total = lessons.length;
      final completed = lessons
          .where((lesson) => progress[lesson.id] == true)
          .length;
      final beginner = lessons
          .where((lesson) => lesson.difficulty == 'Beginner')
          .length;
      final intermediate = lessons
          .where((lesson) => lesson.difficulty == 'Intermediate')
          .length;
      final advanced = lessons
          .where((lesson) => lesson.difficulty == 'Advanced')
          .length;

      return {
        'total': total,
        'completed': completed,
        'beginner': beginner,
        'intermediate': intermediate,
        'advanced': advanced,
      };
    } catch (e) {
      throw CacheException(
        message: 'Failed to get lesson statistics',
        originalException: e,
      );
    }
  }

  @override
  Future<int> getCompletionStreak() async {
    try {
      final lessons = await getAllLessons();
      final progress = await _localStorage.getLessonProgress();

      int streak = 0;
      for (final lesson in lessons) {
        if (progress[lesson.id] == true) {
          streak++;
        } else {
          break;
        }
      }
      return streak;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get completion streak',
        originalException: e,
      );
    }
  }

  @override
  Future<bool> areAllLessonsCompleted() async {
    try {
      final lessons = await getAllLessons();
      final progress = await _localStorage.getLessonProgress();

      return lessons.isNotEmpty &&
          lessons.every((lesson) => progress[lesson.id] == true);
    } catch (e) {
      throw CacheException(
        message: 'Failed to check if all lessons are completed',
        originalException: e,
      );
    }
  }
}
