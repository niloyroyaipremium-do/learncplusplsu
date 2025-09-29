import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressProvider extends ChangeNotifier {
  int _totalPoints = 0;
  int _streak = 0;
  int _lessonsCompleted = 0;
  int _quizzesPassed = 0;

  int get totalPoints => _totalPoints;
  int get streak => _streak;
  int get lessonsCompleted => _lessonsCompleted;
  int get quizzesPassed => _quizzesPassed;

  ProgressProvider() {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _totalPoints = prefs.getInt('total_points') ?? 0;
    _streak = prefs.getInt('streak') ?? 0;
    _lessonsCompleted = prefs.getInt('lessons_completed') ?? 0;
    _quizzesPassed = prefs.getInt('quizzes_passed') ?? 0;
    notifyListeners();
  }

  Future<void> addPoints(int points) async {
    _totalPoints += points;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_points', _totalPoints);
    notifyListeners();
  }

  Future<void> incrementStreak() async {
    _streak++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak', _streak);
    notifyListeners();
  }

  Future<void> resetStreak() async {
    _streak = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak', _streak);
    notifyListeners();
  }

  Future<void> incrementLessonsCompleted() async {
    _lessonsCompleted++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lessons_completed', _lessonsCompleted);
    notifyListeners();
  }

  Future<void> incrementQuizzesPassed() async {
    _quizzesPassed++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('quizzes_passed', _quizzesPassed);
    notifyListeners();
  }

  int getTotalStudyTime() {
    // This would be calculated based on lesson durations
    // For now, return a placeholder
    return _lessonsCompleted * 15; // 15 minutes per lesson average
  }
}
