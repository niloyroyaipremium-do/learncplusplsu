import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/local_storage_datasource.dart';
import '../models/user_profile_model.dart';

/// Implementation of user repository
class UserRepositoryImpl implements UserRepository {
  final LocalStorageDataSource _localStorage;

  UserRepositoryImpl(this._localStorage);

  @override
  Future<UserProfile> getCurrentUser() async {
    try {
      final userModel = await _localStorage.getUserProfile();
      if (userModel == null) {
        // Return default user profile
        return UserProfile(
          id: 'default',
          name: '',
          email: '',
          avatar: '',
          level: 1,
          totalXP: 0,
          joinedDate: DateTime(2024, 1, 1),
          currentStreak: 0,
          longestStreak: 0,
          hearts: 5,
          lessonsCompleted: 0,
          quizzesPassed: 0,
          achievements: [],
          isFirstLaunch: true,
        );
      }
      return userModel.toEntity();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get current user',
        originalException: e,
      );
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      final userModel = UserProfileModel.fromEntity(profile);
      await _localStorage.saveUserProfile(userModel);
    } catch (e) {
      throw CacheException(
        message: 'Failed to update user profile',
        originalException: e,
      );
    }
  }

  @override
  Future<void> updateUserName(String name) async {
    try {
      final currentUser = await getCurrentUser();
      final updatedUser = currentUser.copyWith(name: name);
      await updateUserProfile(updatedUser);
    } catch (e) {
      throw CacheException(
        message: 'Failed to update user name',
        originalException: e,
      );
    }
  }

  @override
  Future<void> updateUserEmail(String email) async {
    try {
      final currentUser = await getCurrentUser();
      final updatedUser = currentUser.copyWith(email: email);
      await updateUserProfile(updatedUser);
    } catch (e) {
      throw CacheException(
        message: 'Failed to update user email',
        originalException: e,
      );
    }
  }

  @override
  Future<void> updateUserAvatar(String avatar) async {
    try {
      final currentUser = await getCurrentUser();
      final updatedUser = currentUser.copyWith(avatar: avatar);
      await updateUserProfile(updatedUser);
    } catch (e) {
      throw CacheException(
        message: 'Failed to update user avatar',
        originalException: e,
      );
    }
  }

  @override
  Future<void> addXP(int xp) async {
    try {
      final currentUser = await getCurrentUser();
      final newTotalXP = currentUser.totalXP + xp;
      final newLevel = (newTotalXP ~/ 100) + 1;
      final updatedUser = currentUser.copyWith(
        totalXP: newTotalXP,
        level: newLevel,
      );
      await updateUserProfile(updatedUser);
    } catch (e) {
      throw CacheException(message: 'Failed to add XP', originalException: e);
    }
  }

  @override
  Future<void> completeLesson() async {
    try {
      final currentUser = await getCurrentUser();
      final newLessonsCompleted = currentUser.lessonsCompleted + 1;
      final newTotalXP = currentUser.totalXP + 10; // 10 XP per lesson
      final newLevel = (newTotalXP ~/ 100) + 1;

      final updatedUser = currentUser.copyWith(
        lessonsCompleted: newLessonsCompleted,
        totalXP: newTotalXP,
        level: newLevel,
      );
      await updateUserProfile(updatedUser);
    } catch (e) {
      throw CacheException(
        message: 'Failed to complete lesson',
        originalException: e,
      );
    }
  }

  @override
  Future<void> passQuiz() async {
    try {
      final currentUser = await getCurrentUser();
      final newQuizzesPassed = currentUser.quizzesPassed + 1;
      final newTotalXP = currentUser.totalXP + 20; // 20 XP per quiz
      final newLevel = (newTotalXP ~/ 100) + 1;

      final updatedUser = currentUser.copyWith(
        quizzesPassed: newQuizzesPassed,
        totalXP: newTotalXP,
        level: newLevel,
      );
      await updateUserProfile(updatedUser);
    } catch (e) {
      throw CacheException(
        message: 'Failed to pass quiz',
        originalException: e,
      );
    }
  }

  @override
  Future<void> loseHeart() async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser.hearts > 0) {
        final newHearts = currentUser.hearts - 1;
        final updatedUser = currentUser.copyWith(hearts: newHearts);
        await updateUserProfile(updatedUser);
      }
    } catch (e) {
      throw CacheException(
        message: 'Failed to lose heart',
        originalException: e,
      );
    }
  }

  @override
  Future<void> restoreHearts() async {
    try {
      final currentUser = await getCurrentUser();
      final updatedUser = currentUser.copyWith(hearts: 5);
      await updateUserProfile(updatedUser);
    } catch (e) {
      throw CacheException(
        message: 'Failed to restore hearts',
        originalException: e,
      );
    }
  }

  @override
  Future<void> unlockAchievement(String achievementId) async {
    try {
      final currentUser = await getCurrentUser();
      if (!currentUser.achievements.contains(achievementId)) {
        final newAchievements = [...currentUser.achievements, achievementId];
        final updatedUser = currentUser.copyWith(achievements: newAchievements);
        await updateUserProfile(updatedUser);
      }
    } catch (e) {
      throw CacheException(
        message: 'Failed to unlock achievement',
        originalException: e,
      );
    }
  }

  @override
  Future<void> updateThemeMode(String themeMode) async {
    try {
      await _localStorage.saveThemeMode(themeMode);
    } catch (e) {
      throw CacheException(
        message: 'Failed to update theme mode',
        originalException: e,
      );
    }
  }

  @override
  Future<void> setFirstLaunch(bool isFirst) async {
    try {
      final currentUser = await getCurrentUser();
      final updatedUser = currentUser.copyWith(isFirstLaunch: isFirst);
      await updateUserProfile(updatedUser);
    } catch (e) {
      throw CacheException(
        message: 'Failed to set first launch',
        originalException: e,
      );
    }
  }

  @override
  Future<void> resetProgress() async {
    try {
      final defaultUser = UserProfile(
        id: 'default',
        name: '',
        email: '',
        avatar: '',
        level: 1,
        totalXP: 0,
        joinedDate: DateTime(2024, 1, 1),
        currentStreak: 0,
        longestStreak: 0,
        hearts: 5,
        lessonsCompleted: 0,
        quizzesPassed: 0,
        achievements: [],
        isFirstLaunch: false,
      );
      await updateUserProfile(defaultUser);
    } catch (e) {
      throw CacheException(
        message: 'Failed to reset progress',
        originalException: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      final currentUser = await getCurrentUser();
      return {
        'name': currentUser.name,
        'email': currentUser.email,
        'level': currentUser.level,
        'totalXP': currentUser.totalXP,
        'currentStreak': currentUser.currentStreak,
        'longestStreak': currentUser.longestStreak,
        'hearts': currentUser.hearts,
        'lessonsCompleted': currentUser.lessonsCompleted,
        'quizzesPassed': currentUser.quizzesPassed,
        'achievements': currentUser.achievements,
        'isFirstLaunch': currentUser.isFirstLaunch,
      };
    } catch (e) {
      throw CacheException(
        message: 'Failed to get user statistics',
        originalException: e,
      );
    }
  }
}
