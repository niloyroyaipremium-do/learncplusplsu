import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/errors/failures.dart';

/// Provider for managing user state
class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository;

  UserProvider(this._userRepository) {
    _initializeUser();
  }

  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Computed properties
  String get userName => _userProfile?.name ?? '';
  String get userEmail => _userProfile?.email ?? '';
  String get userAvatar => _userProfile?.avatar ?? '';
  int get level => _userProfile?.level ?? 1;
  int get totalXP => _userProfile?.totalXP ?? 0;
  int get currentStreak => _userProfile?.currentStreak ?? 0;
  int get longestStreak => _userProfile?.longestStreak ?? 0;
  int get hearts => _userProfile?.hearts ?? 5;
  List<String> get achievements => _userProfile?.achievements ?? [];
  int get lessonsCompleted => _userProfile?.lessonsCompleted ?? 0;
  int get quizzesPassed => _userProfile?.quizzesPassed ?? 0;
  bool get isFirstLaunch => _userProfile?.isFirstLaunch ?? true;
  ThemeMode get themeMode => ThemeMode.system; // Default theme mode

  // Computed properties from UserProfile
  int get xpToNextLevel => _userProfile?.xpToNextLevel ?? 100;
  int get currentLevelProgress => _userProfile?.currentLevelProgress ?? 0;
  bool get hasFullHearts => _userProfile?.hasFullHearts ?? true;
  bool get isStreakActive => _userProfile?.isStreakActive ?? false;

  /// Initializes user by loading from repository
  Future<void> _initializeUser() async {
    _setLoading(true);
    try {
      _userProfile = await _userRepository.getCurrentUser();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  /// Refreshes user data
  Future<void> refreshUser() async {
    await _initializeUser();
  }

  /// Updates user name
  Future<void> updateUserName(String name) async {
    try {
      await _userRepository.updateUserName(name);
      await refreshUser();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  /// Updates user email
  Future<void> updateUserEmail(String email) async {
    try {
      await _userRepository.updateUserEmail(email);
      await refreshUser();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  /// Updates user avatar
  Future<void> updateUserAvatar(String avatar) async {
    try {
      await _userRepository.updateUserAvatar(avatar);
      await refreshUser();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  /// Adds experience points
  Future<void> addXP(int xp) async {
    try {
      await _userRepository.addXP(xp);
      await refreshUser();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  /// Completes a lesson
  Future<void> completeLesson() async {
    try {
      await _userRepository.completeLesson();
      await refreshUser();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  /// Passes a quiz
  Future<void> passQuiz() async {
    try {
      await _userRepository.passQuiz();
      await refreshUser();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  /// Loses a heart
  Future<void> loseHeart() async {
    try {
      await _userRepository.loseHeart();
      await refreshUser();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  /// Restores all hearts
  Future<void> restoreHearts() async {
    try {
      await _userRepository.restoreHearts();
      await refreshUser();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  /// Unlocks an achievement
  Future<void> unlockAchievement(String achievementId) async {
    try {
      await _userRepository.unlockAchievement(achievementId);
      await refreshUser();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  /// Updates theme mode
  Future<void> updateThemeMode(ThemeMode mode) async {
    try {
      await _userRepository.updateThemeMode(mode.name);
      // Note: This would need to be stored separately as it's not part of UserProfile
      notifyListeners();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  /// Sets first launch status
  Future<void> setFirstLaunch(bool isFirst) async {
    try {
      await _userRepository.setFirstLaunch(isFirst);
      await refreshUser();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  /// Resets all progress
  Future<void> resetProgress() async {
    try {
      await _userRepository.resetProgress();
      await refreshUser();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  /// Gets user statistics
  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      return await _userRepository.getUserStatistics();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return {};
    }
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
