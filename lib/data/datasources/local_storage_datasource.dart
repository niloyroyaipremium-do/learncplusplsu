import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../models/lesson_model.dart';
import '../models/user_profile_model.dart';
import '../../core/errors/exceptions.dart';

/// Abstract interface for local storage operations
abstract class LocalStorageDataSource {
  Future<void> saveUserProfile(UserProfileModel profile);
  Future<UserProfileModel?> getUserProfile();
  Future<void> saveLessons(List<LessonModel> lessons);
  Future<List<LessonModel>> getLessons();
  Future<void> saveLessonProgress(Map<String, bool> progress);
  Future<Map<String, bool>> getLessonProgress();
  Future<void> saveThemeMode(String themeMode);
  Future<String?> getThemeMode();
  Future<void> clearAllData();
}

/// Implementation of local storage using SharedPreferences
class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  final SharedPreferences _prefs;

  LocalStorageDataSourceImpl(this._prefs);

  @override
  Future<void> saveUserProfile(UserProfileModel profile) async {
    try {
      final profileJson = json.encode(profile.toJson());
      await _prefs.setString('user_profile', profileJson);
    } catch (e) {
      throw CacheException(message: 'Failed to save user profile', originalException: e);
    }
  }

  @override
  Future<UserProfileModel?> getUserProfile() async {
    try {
      final profileJson = _prefs.getString('user_profile');
      if (profileJson == null) return null;

      final profileData = json.decode(profileJson) as Map<String, dynamic>;
      return UserProfileModel.fromJson(profileData);
    } catch (e) {
      throw CacheException(message: 'Failed to get user profile', originalException: e);
    }
  }

  @override
  Future<void> saveLessons(List<LessonModel> lessons) async {
    try {
      final lessonsJson = json.encode(
        lessons.map((lesson) => lesson.toJson()).toList(),
      );
      await _prefs.setString(AppConstants.savedLessonsKey, lessonsJson);
    } catch (e) {
      throw CacheException(message: 'Failed to save lessons', originalException: e);
    }
  }

  @override
  Future<List<LessonModel>> getLessons() async {
    try {
      final lessonsJson = _prefs.getString(AppConstants.savedLessonsKey);
      if (lessonsJson == null) return [];

      final List<dynamic> lessonsList = json.decode(lessonsJson);
      return lessonsList
          .map((lessonData) => LessonModel.fromJson(lessonData))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get lessons', originalException: e);
    }
  }

  @override
  Future<void> saveLessonProgress(Map<String, bool> progress) async {
    try {
      final progressJson = json.encode(progress);
      await _prefs.setString(AppConstants.lessonProgressKey, progressJson);
    } catch (e) {
      throw CacheException(message: 'Failed to save lesson progress', originalException: e);
    }
  }

  @override
  Future<Map<String, bool>> getLessonProgress() async {
    try {
      final progressJson = _prefs.getString(AppConstants.lessonProgressKey);
      if (progressJson == null) return {};

      final Map<String, dynamic> progressMap = json.decode(progressJson);
      return progressMap.map((key, value) => MapEntry(key, value as bool));
    } catch (e) {
      throw CacheException(message: 'Failed to get lesson progress', originalException: e);
    }
  }

  @override
  Future<void> saveThemeMode(String themeMode) async {
    try {
      await _prefs.setString(AppConstants.themeModeKey, themeMode);
    } catch (e) {
      throw CacheException(message: 'Failed to save theme mode', originalException: e);
    }
  }

  @override
  Future<String?> getThemeMode() async {
    try {
      return _prefs.getString(AppConstants.themeModeKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get theme mode', originalException: e);
    }
  }

  @override
  Future<void> clearAllData() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear all data', originalException: e);
    }
  }
}
