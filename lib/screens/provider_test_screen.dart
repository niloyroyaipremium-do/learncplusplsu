import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lesson_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/app_provider.dart';

class ProviderTestScreen extends StatelessWidget {
  const ProviderTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Test'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer3<LessonProvider, ProgressProvider, AppProvider>(
        builder: (context, lessonProvider, progressProvider, appProvider, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Providers Working!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text('Lesson Count: ${lessonProvider.lessons.length}'),
                Text('Progress Points: ${progressProvider.totalPoints}'),
                Text('App Theme: ${appProvider.themeMode}'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All providers are accessible!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Test Success'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}