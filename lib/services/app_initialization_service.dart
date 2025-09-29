import 'package:timezone/data/latest.dart' as tz;
import 'notification_service.dart';
import 'error_service.dart';
import '../utils/logger.dart';

class AppInitializationService {
  static final AppInitializationService _instance =
      AppInitializationService._internal();
  factory AppInitializationService() => _instance;
  AppInitializationService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone
      tz.initializeTimeZones();

      // Initialize error service first
      ErrorService();

      // Initialize other services
      final notificationService = NotificationService();
      await notificationService.requestPermissions();
      await notificationService.initialize();

      _isInitialized = true;
      Logger.info('App initialization completed successfully');
    } catch (e) {
      Logger.error('Failed to initialize app', e);
      // Don't rethrow to prevent app from crashing
      _isInitialized = true; // Mark as initialized even if some services fail
    }
  }

  bool get isInitialized => _isInitialized;
}
