import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/user_profile.dart';
import '../core/errors/error_handler.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 16.0;
  bool _isFirstLaunch = true;
  String _userName = '';
  String _userEmail = '';
  String _userAvatar = '';

  // Gamification features
  int _totalXP = 0;
  int _currentStreak = 0;
  int _longestStreak = 0;
  int _level = 1;
  int _hearts = 5; // Lives system like Duolingo
  DateTime? _lastActiveDate;
  int _lessonsCompletedToday = 0;
  int _quizzesPassedToday = 0;
  int _xpToday = 0;

  // Getters
  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;
  bool get isFirstLaunch => _isFirstLaunch;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userAvatar => _userAvatar;
  int get totalXP => _totalXP;
  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  int get level => _level;
  int get hearts => _hearts;
  int get lessonsCompleted => _lessonsCompletedToday;
  int get quizzesPassed => _quizzesPassedToday;
  int get xpToday => _xpToday;

  // Calculated properties
  int get xpForNextLevel => (_level * 100);
  int get xpToNextLevel => xpForNextLevel - _totalXP;
  double get currentLevelProgress => (_totalXP - ((_level - 1) * 100)) / 100;
  bool get hasFullHearts => _hearts >= 5;
  bool get isStreakActive =>
      _lastActiveDate != null &&
      DateTime.now().difference(_lastActiveDate!).inDays <= 1;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  UserProfile get userProfile => getUserProfile();

  // Streak management
  bool get isStreakBroken =>
      _lastActiveDate != null &&
      DateTime.now().difference(_lastActiveDate!).inDays > 1;

  // Initialize app state
  Future<void> initialize() async {
    await _loadUserData();
    _checkStreak();
    await _loadSettings();
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('user_name') ?? '';
      _userEmail = prefs.getString('user_email') ?? '';
      _userAvatar = prefs.getString('user_avatar') ?? '';
      _totalXP = prefs.getInt('total_xp') ?? 0;
      _currentStreak = prefs.getInt('current_streak') ?? 0;
      _longestStreak = prefs.getInt('longest_streak') ?? 0;
      _level = prefs.getInt('level') ?? 1;
      _hearts = prefs.getInt('hearts') ?? 5;
      _lastActiveDate = prefs.getString('last_active_date') != null
          ? DateTime.parse(prefs.getString('last_active_date')!)
          : null;
      _isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
      _lessonsCompletedToday = prefs.getInt('lessons_completed_today') ?? 0;
      _quizzesPassedToday = prefs.getInt('quizzes_passed_today') ?? 0;
      _xpToday = prefs.getInt('xp_today') ?? 0;

      // Calculate level based on XP
      _level = (_totalXP ~/ 100) + 1;
      notifyListeners();
    } catch (e) {
      await ErrorHandler.handleStorageError(
        'Failed to load user data',
        code: 'load_user_data_error',
        details: e.toString(),
      );
      // Set default values on error
      _setDefaultValues();
    }
  }

  // Set default values when loading fails
  void _setDefaultValues() {
    _userName = '';
    _userEmail = '';
    _userAvatar = '';
    _totalXP = 0;
    _currentStreak = 0;
    _longestStreak = 0;
    _level = 1;
    _hearts = 5;
    _lastActiveDate = null;
    _isFirstLaunch = true;
    _lessonsCompletedToday = 0;
    _quizzesPassedToday = 0;
    _xpToday = 0;
    notifyListeners();
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _userName);
      await prefs.setString('user_email', _userEmail);
      await prefs.setString('user_avatar', _userAvatar);
      await prefs.setInt('total_xp', _totalXP);
      await prefs.setInt('current_streak', _currentStreak);
      await prefs.setInt('longest_streak', _longestStreak);
      await prefs.setInt('level', _level);
      await prefs.setInt('hearts', _hearts);
      await prefs.setString(
        'last_active_date',
        _lastActiveDate?.toIso8601String() ?? '',
      );
      await prefs.setBool('is_first_launch', _isFirstLaunch);
      await prefs.setInt('lessons_completed_today', _lessonsCompletedToday);
      await prefs.setInt('quizzes_passed_today', _quizzesPassedToday);
      await prefs.setInt('xp_today', _xpToday);
    } catch (e) {
      await ErrorHandler.handleStorageError(
        'Failed to save user data',
        code: 'save_user_data_error',
        details: e.toString(),
      );
    }
  }

  // Load app settings
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('theme_mode');
    _themeMode = themeModeString != null
        ? ThemeMode.values.firstWhere(
            (mode) => mode.toString() == 'ThemeMode.$themeModeString',
            orElse: () => ThemeMode.system,
          )
        : ThemeMode.system;
    _fontSize = prefs.getDouble('font_size') ?? 16.0;
    notifyListeners();
  }

  // Save app settings
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _themeMode.toString().split('.').last);
    await prefs.setDouble('font_size', _fontSize);
  }

  // Check and update streak
  void _checkStreak() {
    final now = DateTime.now();
    if (_lastActiveDate == null) {
      _lastActiveDate = now;
      _saveUserData();
      return;
    }

    final daysDifference = now.difference(_lastActiveDate!).inDays;
    if (daysDifference > 1) {
      // Streak broken
      _currentStreak = 0;
      _hearts = 5; // Reset hearts when streak breaks
    } else if (daysDifference == 1) {
      // Continue streak
      _currentStreak++;
      if (_currentStreak > _longestStreak) {
        _longestStreak = _currentStreak;
      }
    }

    _lastActiveDate = now;
    _saveUserData();
  }

  // Theme management
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveSettings();
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    _saveSettings();
    notifyListeners();
  }

  // Font size management
  void setFontSize(double size) {
    _fontSize = size;
    _saveSettings();
    notifyListeners();
  }

  // User profile management
  void updateUserProfile({String? name, String? email, String? avatar}) {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    if (avatar != null) _userAvatar = avatar;
    _saveUserData();
    notifyListeners();
  }

  // XP and level management
  void addXP(int xp) {
    _totalXP += xp;
    _xpToday += xp;

    // Check for level up
    final newLevel = (_totalXP ~/ 100) + 1;
    if (newLevel > _level) {
      _level = newLevel;
      _hearts = 5; // Full hearts on level up
    }

    _saveUserData();
    notifyListeners();
  }

  // Hearts management
  void loseHeart() {
    if (_hearts > 0) {
      _hearts--;
      _saveUserData();
      notifyListeners();
    }
  }

  void restoreHeart() {
    if (_hearts < 5) {
      _hearts++;
      _saveUserData();
      notifyListeners();
    }
  }

  void restoreAllHearts() {
    _hearts = 5;
    _saveUserData();
    notifyListeners();
  }

  void restoreHearts() {
    restoreAllHearts();
  }

  // Lesson and quiz completion
  void completeLesson() {
    _lessonsCompletedToday++;
    addXP(10); // 10 XP per lesson
    _saveUserData();
    notifyListeners();
  }

  void passQuiz() {
    _quizzesPassedToday++;
    addXP(20); // 20 XP per quiz
    _saveUserData();
    notifyListeners();
  }

  // Reset daily counters (call at midnight)
  void resetDailyCounters() {
    _lessonsCompletedToday = 0;
    _quizzesPassedToday = 0;
    _xpToday = 0;
    _saveUserData();
    notifyListeners();
  }

  // First launch management
  void completeFirstLaunch() {
    _isFirstLaunch = false;
    _saveUserData();
    notifyListeners();
  }

  // Reset all progress
  void resetProgress() {
    _totalXP = 0;
    _currentStreak = 0;
    _longestStreak = 0;
    _level = 1;
    _hearts = 5;
    _lessonsCompletedToday = 0;
    _quizzesPassedToday = 0;
    _xpToday = 0;
    _saveUserData();
    notifyListeners();
  }

  // Get user profile entity
  UserProfile getUserProfile() {
    return UserProfile(
      id: _userEmail.isNotEmpty
          ? _userEmail
          : 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: _userName,
      email: _userEmail,
      avatar: _userAvatar,
      level: _level,
      totalXP: _totalXP,
      currentStreak: _currentStreak,
      longestStreak: _longestStreak,
      hearts: _hearts,
      lessonsCompleted: _lessonsCompletedToday,
      quizzesPassed: _quizzesPassedToday,
      lastActiveDate: _lastActiveDate,
      isFirstLaunch: _isFirstLaunch,
      joinedDate: DateTime.now(),
      lastUpdatedDate: DateTime.now(),
      isGuest: _userEmail.isEmpty,
      preferences: {},
      completedLessons: [],
      completedQuizzes: [],
    );
  }

  // Update from user profile entity
  void updateFromUserProfile(UserProfile profile) {
    _userName = profile.name;
    _userEmail = profile.email;
    _userAvatar = profile.avatar ?? '';
    _level = profile.level;
    _totalXP = profile.totalXP;
    _currentStreak = profile.currentStreak;
    _longestStreak = profile.longestStreak;
    _hearts = profile.hearts;
    _lessonsCompletedToday = profile.lessonsCompleted;
    _quizzesPassedToday = profile.quizzesPassed;
    _lastActiveDate = profile.lastActiveDate;
    _isFirstLaunch = profile.isFirstLaunch;
    _saveUserData();
    notifyListeners();
  }

  // Daily reset timer
  Timer? _dailyResetTimer;

  void startDailyResetTimer() {
    _dailyResetTimer?.cancel();

    // Calculate time until next midnight
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = tomorrow.difference(now);

    _dailyResetTimer = Timer(timeUntilMidnight, () {
      resetDailyCounters();
      startDailyResetTimer(); // Restart timer for next day
    });
  }

  @override
  void dispose() {
    _dailyResetTimer?.cancel();
    super.dispose();
  }
}
