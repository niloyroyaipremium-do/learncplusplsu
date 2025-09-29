import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/lesson_provider.dart';
import '../providers/progress_provider.dart';
import '../services/notification_service.dart';
import '../services/analytics_service.dart';
import '../services/error_service.dart';
import '../services/database_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/modern_progress_indicator.dart';
import '../widgets/animated_lesson_card.dart';
import '../domain/entities/lesson.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final NotificationService _notificationService = NotificationService();
  final AnalyticsService _analyticsService = AnalyticsService();
  final ErrorService _errorService = ErrorService();
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    setState(() => _isLoading = true);
    try {
      await _notificationService.initialize();
      await _analyticsService.initialize();
      await _databaseService.database; // Initialize database
    } catch (e) {
      _errorService.reportException(
        e,
        message: 'Failed to initialize services',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('CodeLingo Test Screen'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: LoadingWidget(message: 'Initializing services...', size: 60),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CodeLingo Test Screen'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeServices,
            tooltip: 'Refresh Services',
          ),
        ],
      ),
      body: Consumer3<AppProvider, LessonProvider, ProgressProvider>(
        builder: (context, appProvider, lessonProvider, progressProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Status
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'App Status',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'User: ${appProvider.userName.isEmpty ? "Not set" : appProvider.userName}',
                        ),
                        Text('Level: ${appProvider.level}'),
                        Text('XP: ${appProvider.totalXP}'),
                        Text('Streak: ${appProvider.currentStreak}'),
                        Text('Hearts: ${appProvider.hearts}'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Gamification Tests
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gamification Tests',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                appProvider.addXP(50);
                                _analyticsService.logXPEarned(50, 'test');
                              },
                              child: const Text('Add 50 XP'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                appProvider.completeLesson();
                                _analyticsService.logLessonCompleted(
                                  'test_lesson',
                                  'Test Lesson',
                                  duration: 60,
                                );
                              },
                              child: const Text('Complete Lesson'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                appProvider.passQuiz();
                                _analyticsService.logQuizCompleted(
                                  'test_quiz',
                                  'Test Quiz',
                                  score: 8,
                                  totalQuestions: 10,
                                );
                              },
                              child: const Text('Pass Quiz'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                appProvider.loseHeart();
                              },
                              child: const Text('Lose Heart'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                appProvider.restoreHearts();
                              },
                              child: const Text('Restore Hearts'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                appProvider.addXP(100);
                                _analyticsService.logXPEarned(
                                  100,
                                  'achievement_test',
                                );
                              },
                              child: const Text('Add 100 XP'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Notification Tests
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notification Tests',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );
                                await _notificationService.scheduleDailyReminder(
                                  hour: 9,
                                  minute: 0,
                                  message:
                                      'Time to learn! Complete a lesson to maintain your streak.',
                                );
                                if (mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Daily reminder scheduled'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Schedule Daily Reminder'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );
                                await _notificationService
                                    .scheduleStreakReminder();
                                if (mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Streak reminder scheduled',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Schedule Streak Reminder'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );
                                await _notificationService
                                    .scheduleAchievementNotification(
                                      'Test Achievement',
                                    );
                                if (mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Achievement notification sent',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Send Achievement Notification',
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );
                                await _notificationService
                                    .scheduleLevelUpNotification(
                                      appProvider.level + 1,
                                    );
                                if (mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Level up notification sent',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Send Level Up Notification'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Analytics Tests
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analytics Tests',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _analyticsService.logAppOpened();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('App opened event logged'),
                                  ),
                                );
                              },
                              child: const Text('Log App Opened'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _analyticsService.logScreenView('test_screen');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Screen view logged'),
                                  ),
                                );
                              },
                              child: const Text('Log Screen View'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _analyticsService.logCustomEvent('test_event', {
                                  'test_param': 'test_value',
                                  'user_level': appProvider.level,
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Custom event logged'),
                                  ),
                                );
                              },
                              child: const Text('Log Custom Event'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // UI Components Test
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'UI Components Test',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        // Progress Indicators
                        Text(
                          'Progress Indicators',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ModernProgressIndicator(
                              progress: appProvider.totalXP / 1000.0,
                              size: 80,
                              label: 'XP Progress',
                            ),
                            const SizedBox(width: 20),
                            ModernLinearProgressIndicator(
                              progress:
                                  lessonProvider.getProgressPercentage() /
                                  100.0,
                              height: 12,
                              label: 'Lesson Progress',
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Loading Widgets
                        Text(
                          'Loading Widgets',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const LoadingWidget(size: 40),
                            const SizedBox(width: 20),
                            const SimpleLoadingWidget(size: 30),
                            const SizedBox(width: 20),
                            ShimmerLoadingWidget(
                              isLoading: true,
                              child: Container(
                                width: 100,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Database Tests
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Database Tests',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );
                                try {
                                  final stats = await _databaseService
                                      .getStatistics();
                                  if (mounted) {
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(
                                        content: Text('Database stats: $stats'),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  _errorService.reportException(e);
                                }
                              },
                              child: const Text('Get Stats'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );
                                try {
                                  final lessons = await _databaseService
                                      .getAllLessons();
                                  if (mounted) {
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Found ${lessons.length} lessons',
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  _errorService.reportException(e);
                                }
                              },
                              child: const Text('Get Lessons'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );
                                try {
                                  await _databaseService.clearAllData();
                                  if (mounted) {
                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(
                                        content: Text('Database cleared'),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  _errorService.reportException(e);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Clear DB'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Error Handling Tests
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Error Handling Tests',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _errorService.reportError(
                                  'Test error message',
                                  type: ErrorType.validation,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Validation error reported'),
                                  ),
                                );
                              },
                              child: const Text('Report Error'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _errorService.reportNetworkError(
                                  'Test network error',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Network error reported'),
                                  ),
                                );
                              },
                              child: const Text('Network Error'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _errorService.clearErrors();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Errors cleared'),
                                  ),
                                );
                              },
                              child: const Text('Clear Errors'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Error Count: ${_errorService.errors.length}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Lesson Provider Tests
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lesson Provider Tests',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );
                                lessonProvider.markLessonAsCompleted('1');
                                if (mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Lesson 1 marked as completed',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Complete Lesson 1'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );
                                await lessonProvider.resetProgress();
                                if (mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Lesson progress reset'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Reset Lessons'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );
                                final customLesson = Lesson(
                                  id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                                  title: 'Custom Test Lesson',
                                  description:
                                      'This is a custom lesson for testing',
                                  duration: '10 min',
                                  difficulty: 'Beginner',
                                  isCompleted: false,
                                  content: 'Test content',
                                  codeExample: 'Test code',
                                );
                                lessonProvider.addCustomLesson(customLesson);
                                if (mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Custom lesson added'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Add Custom Lesson'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Total Lessons: ${lessonProvider.lessons.length}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Completed: ${lessonProvider.completedLessons.length}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Animated Lesson Cards Preview
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Animated Lesson Cards Preview',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: lessonProvider.lessons.take(3).length,
                            itemBuilder: (context, index) {
                              final lesson = lessonProvider.lessons[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: AnimatedLessonCard(
                                  lesson: lesson,
                                  index: index,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Reset Tests
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reset Tests',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                appProvider.resetProgress();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Progress reset'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Reset All Progress'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );
                                await lessonProvider.resetProgress();
                                if (mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Lesson progress reset'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Reset Lessons'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _errorService.clearErrors();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Errors cleared'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Clear Errors'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
