import '../repositories/lesson_repository.dart';
import '../repositories/user_repository.dart';
import '../../core/errors/failures.dart';

/// Use case for completing a lesson
class CompleteLessonUseCase {
  final LessonRepository _lessonRepository;
  final UserRepository _userRepository;

  CompleteLessonUseCase(this._lessonRepository, this._userRepository);

  /// Executes the use case to complete a lesson
  Future<void> call(String lessonId) async {
    try {
      // Mark lesson as completed
      await _lessonRepository.markLessonAsCompleted(lessonId);

      // Update user progress
      await _userRepository.completeLesson();
    } catch (e) {
      throw GenericFailure(
        message: 'Failed to complete lesson: ${e.toString()}',
      );
    }
  }
}
