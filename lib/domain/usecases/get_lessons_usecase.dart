import '../entities/lesson.dart';
import '../repositories/lesson_repository.dart';
import '../../core/errors/failures.dart';

/// Use case for getting all lessons
class GetLessonsUseCase {
  final LessonRepository _repository;

  GetLessonsUseCase(this._repository);

  /// Executes the use case to get all lessons
  Future<List<Lesson>> call() async {
    try {
      return await _repository.getAllLessons();
    } catch (e) {
      throw GenericFailure(message: 'Failed to get lessons: ${e.toString()}');
    }
  }
}
