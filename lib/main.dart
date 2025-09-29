/// CodeLingo - C++ Learning App
///
/// A comprehensive Flutter application for learning C++ programming
/// with an integrated IDE, interactive tutorials, and gamified learning experience.
///
/// This file contains the main entry point and application configuration.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

// Core
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';

// Domain
import 'domain/repositories/lesson_repository.dart';
import 'domain/repositories/user_repository.dart';

// Data
import 'data/datasources/local_storage_datasource.dart';
import 'data/repositories/lesson_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';

// Presentation
import 'presentation/providers/user_provider.dart';
import 'providers/app_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/lesson_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lesson_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/ide/cpp_editor_screen.dart';
import 'screens/ide/simple_ide_screen.dart';
import 'screens/tutorials/tutorial_navigation_screen.dart';
import 'screens/tutorials/string_tutorial.dart';
import 'screens/tutorials/oop_tutorial.dart';
import 'screens/test_screen.dart';
import 'screens/provider_test_screen.dart';
import 'widgets/responsive_wrapper.dart';

// Services
import 'services/app_initialization_service.dart';

/// Main entry point of the application
///
/// Initializes the Flutter app with all necessary dependencies and services.
/// Sets up the dependency injection container and starts the app.
///
/// The initialization process includes:
/// - Flutter binding initialization
/// - App services initialization
/// - Dependency injection setup
/// - Repository initialization
/// - App startup
void main() async {
  // Ensure Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core app services (logging, error handling, etc.)
  await AppInitializationService().initialize();

  // Initialize dependencies for dependency injection
  final sharedPreferences = await SharedPreferences.getInstance();
  final localStorage = LocalStorageDataSourceImpl(sharedPreferences);
  final lessonRepository = LessonRepositoryImpl(localStorage);
  final userRepository = UserRepositoryImpl(localStorage);

  // Start the application with injected dependencies
  runApp(
    LearnCppApp(
      lessonRepository: lessonRepository,
      userRepository: userRepository,
    ),
  );
}

/// Main application widget
///
/// The root widget of the CodeLingo app that sets up the overall app structure,
/// theme, routing, and state management providers.
///
/// This widget is responsible for:
/// - Setting up the MaterialApp with theme configuration
/// - Configuring the routing system with GoRouter
/// - Setting up state management providers
/// - Handling responsive design across different screen sizes
class LearnCppApp extends StatelessWidget {
  /// Repository for lesson-related operations
  final LessonRepository lessonRepository;

  /// Repository for user profile operations
  final UserRepository userRepository;

  /// Creates the main application widget
  ///
  /// [lessonRepository] - Repository for lesson data operations
  /// [userRepository] - Repository for user profile operations
  const LearnCppApp({
    super.key,
    required this.lessonRepository,
    required this.userRepository,
  });

  /// Builds the main application widget
  ///
  /// Sets up the provider tree with all necessary state management providers
  /// and configures the MaterialApp with routing and theming.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Global app state provider
        ChangeNotifierProvider(create: (_) => AppProvider()),
        // User profile state provider
        ChangeNotifierProvider(create: (_) => UserProvider(userRepository)),
        // Progress tracking provider
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        // Lesson management provider
        ChangeNotifierProvider(create: (_) => LessonProvider()),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return ResponsiveWrapper(
            child: MaterialApp.router(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: userProvider.themeMode,
              routerConfig: _createRouter(),
            ),
          );
        },
      ),
    );
  }

  /// Creates the application router configuration
  ///
  /// Sets up all the routes for the application using GoRouter.
  /// Includes routes for all screens including tutorials, IDE, and user management.
  ///
  /// Returns a configured GoRouter instance with all application routes.
  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/lesson/:lessonId',
          builder: (context, state) {
            final lessonId = state.pathParameters['lessonId']!;
            return LessonScreen(lessonId: lessonId);
          },
        ),
        GoRoute(path: '/quiz', builder: (context, state) => const QuizScreen()),
        GoRoute(
          path: '/code-editor',
          builder: (context, state) => const CppEditorScreen(),
        ),
        GoRoute(
          path: '/ide',
          builder: (context, state) => const SimpleIDEScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/tutorial',
          builder: (context, state) => const TutorialNavigationScreen(),
        ),
        GoRoute(
          path: '/string-tutorial',
          builder: (context, state) => const CppStringTutorial(),
        ),
        GoRoute(
          path: '/oop-tutorial',
          builder: (context, state) => const OopTutorialScreen(),
        ),
        GoRoute(path: '/test', builder: (context, state) => const TestScreen()),
        GoRoute(path: '/provider-test', builder: (context, state) => const ProviderTestScreen()),
      ],
    );
  }
}
