import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/lesson_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/app_provider.dart';
import '../widgets/animated_lesson_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CodeLingo'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.go('/profile'),
            tooltip: 'Profile',
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            onPressed: () => context.go('/achievements'),
            tooltip: 'Achievements',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.bug_report_outlined),
            onPressed: () => context.go('/test'),
            tooltip: 'Test Screen',
          ),
        ],
      ),
      body: Consumer3<LessonProvider, ProgressProvider, AppProvider>(
        builder: (context, lessonProvider, progressProvider, appProvider, child) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Welcome Section with better visual hierarchy
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back! 👋',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Ready to continue your C++ journey?',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildEnhancedStatCard(
                              context,
                              '${lessonProvider.completedLessons.length}',
                              'Lessons\nCompleted',
                              Icons.check_circle_outline,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildEnhancedStatCard(
                              context,
                              '${lessonProvider.getCompletionStreak()}',
                              'Day\nStreak',
                              Icons.local_fire_department,
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildEnhancedStatCard(
                              context,
                              '${lessonProvider.getProgressPercentage().toInt()}%',
                              'Overall\nProgress',
                              Icons.trending_up,
                              Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Actions
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        context,
                        'Continue Learning',
                        'Pick up where you left off',
                        Icons.play_arrow,
                        Colors.blue,
                        () {
                          final nextLesson = lessonProvider.lessons
                              .where((lesson) => !lesson.isCompleted)
                              .firstOrNull;
                          if (nextLesson != null) {
                            context.go('/lesson/${nextLesson.id}');
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionCard(
                        context,
                        'Practice Code',
                        'Open the IDE',
                        Icons.code,
                        Colors.green,
                        () => context.go('/ide'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        context,
                        'Take Quiz',
                        'Test your knowledge',
                        Icons.quiz,
                        Colors.orange,
                        () {
                          final randomLesson = lessonProvider.getRandomLesson();
                          if (randomLesson != null) {
                            context.go('/quiz/${randomLesson.id}');
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionCard(
                        context,
                        'Tutorials',
                        'Learn step by step',
                        Icons.school,
                        Colors.purple,
                        () => context.go('/tutorial'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Lessons by Difficulty
                Text(
                  'Lessons by Difficulty',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Beginner Lessons
                if (lessonProvider.beginnerLessons.isNotEmpty) ...[
                  _buildDifficultySection(
                    context,
                    'Beginner',
                    lessonProvider.beginnerLessons,
                    Colors.green,
                    Icons.school,
                  ),
                  const SizedBox(height: 16),
                ],

                // Intermediate Lessons
                if (lessonProvider.intermediateLessons.isNotEmpty) ...[
                  _buildDifficultySection(
                    context,
                    'Intermediate',
                    lessonProvider.intermediateLessons,
                    Colors.orange,
                    Icons.trending_up,
                  ),
                  const SizedBox(height: 16),
                ],

                // Advanced Lessons
                if (lessonProvider.advancedLessons.isNotEmpty) ...[
                  _buildDifficultySection(
                    context,
                    'Advanced',
                    lessonProvider.advancedLessons,
                    Colors.red,
                    Icons.rocket_launch,
                  ),
                  const SizedBox(height: 16),
                ],

                // Recent Achievements
                if (lessonProvider.completedLessons.isNotEmpty) ...[
                  Text(
                    'Recent Achievements',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: lessonProvider.completedLessons.length,
                      itemBuilder: (context, index) {
                        final lesson = lessonProvider.completedLessons[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SizedBox(
                            width: 120,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      lesson.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Completed ${lesson.difficulty} lesson',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accentColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultySection(
    BuildContext context,
    String difficulty,
    List lessons,
    Color color,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              difficulty,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // Navigate to difficulty filter
              },
              child: Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AnimatedLessonCard(lesson: lesson, index: index),
              );
            },
          ),
        ),
      ],
    );
  }
}
