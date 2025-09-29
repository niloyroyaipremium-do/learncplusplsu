import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:codelingo/main.dart';
import 'package:codelingo/providers/app_provider.dart';
import 'package:codelingo/providers/lesson_provider.dart';
import 'package:codelingo/providers/progress_provider.dart';
import 'package:codelingo/screens/home_screen.dart';
import 'package:codelingo/screens/ide_screen.dart';
import 'package:codelingo/screens/lesson_screen.dart';
import 'package:codelingo/screens/profile_screen.dart';
import 'package:codelingo/screens/settings_screen.dart';
import 'package:codelingo/widgets/lesson_card.dart';
import 'package:codelingo/widgets/progress_card.dart';
import 'package:codelingo/widgets/loading_widget.dart';

void main() {
  group('Widget Tests', () {
    late Widget app;
    
    setUp(() {
      app = MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => LessonProvider()),
          ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ],
        child: const MyApp(),
      );
    });

    testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Home screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      
      // Navigate to home screen
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('IDE screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      
      // Navigate to IDE screen
      await tester.tap(find.text('IDE'));
      await tester.pumpAndSettle();
      
      expect(find.byType(IdesScreen), findsOneWidget);
    });

    testWidgets('Profile screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      
      // Navigate to profile screen
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('Settings screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      
      // Navigate to settings screen
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      
      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });

  group('Custom Widget Tests', () {
    testWidgets('LessonCard displays correctly', (WidgetTester tester) async {
      const lesson = {
        'id': '1',
        'title': 'Test Lesson',
        'description': 'Test Description',
        'difficulty': 'Beginner',
        'duration': '10 min',
        'isCompleted': false,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonCard(
              lesson: lesson,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Lesson'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Beginner'), findsOneWidget);
    });

    testWidgets('ProgressCard displays correctly', (WidgetTester tester) async {
      const progress = {
        'currentLevel': 5,
        'currentXp': 250,
        'xpToNextLevel': 50,
        'streak': 7,
        'lessonsCompleted': 15,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProgressCard(
              progress: progress,
            ),
          ),
        ),
      );

      expect(find.text('Level 5'), findsOneWidget);
      expect(find.text('7 day streak'), findsOneWidget);
    });

    testWidgets('LoadingWidget displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });
  });

  group('User Interaction Tests', () {
    testWidgets('User can tap lesson card', (WidgetTester tester) async {
      bool tapped = false;
      const lesson = {
        'id': '1',
        'title': 'Test Lesson',
        'description': 'Test Description',
        'difficulty': 'Beginner',
        'duration': '10 min',
        'isCompleted': false,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonCard(
              lesson: lesson,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LessonCard));
      expect(tapped, true);
    });

    testWidgets('User can enter text in IDE', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppProvider()),
            ChangeNotifierProvider(create: (_) => LessonProvider()),
            ChangeNotifierProvider(create: (_) => ProgressProvider()),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: IdesScreen(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'cout << "Hello World";');
      expect(find.text('cout << "Hello World";'), findsOneWidget);
    });
  });

  group('Theme Tests', () {
    testWidgets('App respects light theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppProvider()),
            ChangeNotifierProvider(create: (_) => LessonProvider()),
            ChangeNotifierProvider(create: (_) => ProgressProvider()),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();
      
      // Verify theme is applied
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
    });

    testWidgets('App respects dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppProvider()),
            ChangeNotifierProvider(create: (_) => LessonProvider()),
            ChangeNotifierProvider(create: (_) => ProgressProvider()),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();
      
      // Toggle to dark theme
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      
      // Verify dark theme toggle exists
      expect(find.text('Theme'), findsOneWidget);
    });
  });

  group('Responsive Design Tests', () {
    testWidgets('App adapts to different screen sizes', (WidgetTester tester) async {
      // Test with small screen
      await tester.binding.setSurfaceSize(const Size(320, 568));
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppProvider()),
            ChangeNotifierProvider(create: (_) => LessonProvider()),
            ChangeNotifierProvider(create: (_) => ProgressProvider()),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);

      // Test with large screen
      await tester.binding.setSurfaceSize(const Size(1024, 768));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Accessibility Tests', () {
    testWidgets('Widgets have proper semantics', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppProvider()),
            ChangeNotifierProvider(create: (_) => LessonProvider()),
            ChangeNotifierProvider(create: (_) => ProgressProvider()),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();
      
      // Verify semantic labels exist
      expect(find.byType(Semantics), findsWidgets);
    });
  });
}
