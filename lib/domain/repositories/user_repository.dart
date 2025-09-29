import '../entities/user_profile.dart';

/// Abstract repository interface for user profile operations
abstract class UserRepository {
  /// Gets the current user profile
  Future<UserProfile> getCurrentUser();

  /// Updates the user profile
  Future<void> updateUserProfile(UserProfile profile);

  /// Updates user name
  Future<void> updateUserName(String name);

  /// Updates user email
  Future<void> updateUserEmail(String email);

  /// Updates user avatar
  Future<void> updateUserAvatar(String avatar);

  /// Adds experience points
  Future<void> addXP(int xp);

  /// Completes a lesson and updates stats
  Future<void> completeLesson();

  /// Passes a quiz and updates stats
  Future<void> passQuiz();

  /// Loses a heart
  Future<void> loseHeart();

  /// Restores all hearts
  Future<void> restoreHearts();

  /// Unlocks an achievement
  Future<void> unlockAchievement(String achievementId);

  /// Updates the theme mode
  Future<void> updateThemeMode(String themeMode);

  /// Sets first launch status
  Future<void> setFirstLaunch(bool isFirst);

  /// Resets all user progress
  Future<void> resetProgress();

  /// Gets user statistics
  Future<Map<String, dynamic>> getUserStatistics();
}
