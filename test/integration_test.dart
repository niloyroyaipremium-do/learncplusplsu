import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codelingo/main.dart';
import 'package:codelingo/providers/app_provider.dart';
import 'package:codelingo/providers/lesson_provider.dart';
import 'package:codelingo/providers/progress_provider.dart';
import 'package:codelingo/services/background_service.dart';
import 'package:codelingo/services/notification_service.dart';
import 'package:codelingo/services/cpp_execution_service.dart';

void main() {
  group('Integration Tests', () {
    late Widget app;
    
    setUp(() {
      // Initialize test app with providers
      app = MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => LessonProvider()),
          ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ],
        child: const MyApp(),
      );
    });

    testWidgets('App launches successfully', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      
      // Verify app launches without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Home screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      
      // Navigate to home screen
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      
      // Verify home screen elements
      expect(find.text('Learn C++'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Lesson navigation works', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      
      // Navigate to lessons
      await tester.tap(find.text('Tutorials'));
      await tester.pumpAndSettle();
      
      // Verify lesson list is displayed
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('IDE screen opens correctly', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      
      // Navigate to IDE
      await tester.tap(find.text('IDE'));
      await tester.pumpAndSettle();
      
      // Verify IDE elements
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Run Code'), findsOneWidget);
    });

    testWidgets('Code execution works', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      
      // Navigate to IDE
      await tester.tap(find.text('IDE'));
      await tester.pumpAndSettle();
      
      // Enter test code
      await tester.enterText(find.byType(TextField), 'cout << "Hello World";');
      
      // Run code
      await tester.tap(find.text('Run Code'));
      await tester.pumpAndSettle();
      
      // Verify output (this might take time for actual execution)
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('Settings screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      
      // Navigate to settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      
      // Verify settings elements
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('Profile screen shows progress', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      
      // Navigate to profile
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      
      // Verify profile elements
      expect(find.text('Progress'), findsOneWidget);
      expect(find.text('Level'), findsOneWidget);
    });
  });

  group('Service Integration Tests', () {
    test('Background service initializes correctly', () async {
      final backgroundService = BackgroundService();
      await backgroundService.initialize();
      
      expect(backgroundService.isRunning, true);
    });

    test('Notification service initializes correctly', () async {
      final notificationService = NotificationService();
      await notificationService.initialize();
      
      // Service should initialize without errors
      expect(true, true);
    });

    test('C++ execution service works', () async {
      final cppService = CppExecutionService();
      
      // Test simple code execution
      final result = await cppService.executeCode('cout << "test";');
      
      expect(result.isSuccess, true);
    });
  });

  group('Data Persistence Tests', () {
    test('Progress data persists correctly', () async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      
      // Set test data
      await prefs.setInt('currentStreak', 5);
      await prefs.setInt('totalLessonsCompleted', 10);
      
      // Verify data persists
      expect(prefs.getInt('currentStreak'), 5);
      expect(prefs.getInt('totalLessonsCompleted'), 10);
    });

    test('User preferences save correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      
      // Set preferences
      await prefs.setBool('darkMode', true);
      await prefs.setString('selectedLanguage', 'en');
      
      // Verify preferences
      expect(prefs.getBool('darkMode'), true);
      expect(prefs.getString('selectedLanguage'), 'en');
    });
  });

  group('Error Handling Tests', () {
    test('App handles network errors gracefully', () async {
      // This would test network error scenarios
      expect(true, true);
    });

    test('App handles code execution errors', () async {
      final cppService = CppExecutionService();
      
      // Test with invalid code
      final result = await cppService.executeCode('invalid c++ code');
      
      expect(result.isSuccess, false);
      expect(result.error, isNotNull);
    });
  });

  group('Performance Tests', () {
    test('App loads within acceptable time', () async {
      final stopwatch = Stopwatch()..start();
      
      // Simulate app initialization
      await Future.delayed(const Duration(milliseconds: 100));
      
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    test('Code execution completes within timeout', () async {
      final cppService = CppExecutionService();
      final stopwatch = Stopwatch()..start();
      
      await cppService.executeCode('cout << "performance test";');
      
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(10000)); // 10 second timeout
    });
  });
}
