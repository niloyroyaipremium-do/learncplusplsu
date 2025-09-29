import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/background_service.dart';
import '../services/notification_service.dart';
import '../utils/logger.dart';

/// Background Test Screen
/// 
/// Allows testing of background mode functionality
class BackgroundTestScreen extends StatefulWidget {
  const BackgroundTestScreen({Key? key}) : super(key: key);

  @override
  State<BackgroundTestScreen> createState() => _BackgroundTestScreenState();
}

class _BackgroundTestScreenState extends State<BackgroundTestScreen> {
  bool _isBackgroundModeEnabled = false;
  bool _isLoading = false;
  String _lastActivity = 'No activity yet';

  @override
  void initState() {
    super.initState();
    _loadBackgroundStatus();
  }

  /// Load current background mode status
  Future<void> _loadBackgroundStatus() async {
    setState(() => _isLoading = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isBackgroundModeEnabled = prefs.getBool('background_mode_enabled') ?? false;
      });
    } catch (e) {
      Logger.error('Failed to load background status', e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Toggle background mode
  Future<void> _toggleBackgroundMode() async {
    setState(() => _isLoading = true);
    
    try {
      final backgroundService = BackgroundService();
      
      if (_isBackgroundModeEnabled) {
        await backgroundService.stop();
        setState(() {
          _isBackgroundModeEnabled = false;
          _lastActivity = 'Background mode stopped at ${DateTime.now().toString()}';
        });
      } else {
        await backgroundService.start();
        setState(() {
          _isBackgroundModeEnabled = true;
          _lastActivity = 'Background mode started at ${DateTime.now().toString()}';
        });
      }
      
      // Save status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('background_mode_enabled', _isBackgroundModeEnabled);
      
    } catch (e) {
      Logger.error('Failed to toggle background mode', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Test notification
  Future<void> _testNotification() async {
    try {
      final notificationService = NotificationService();
      await notificationService.initialize();
      
      await notificationService.showNotification(
        id: 999,
        title: 'Background Mode Test',
        body: 'This is a test notification from background mode!',
        payload: 'test_notification',
      );
      
      setState(() {
        _lastActivity = 'Test notification sent at ${DateTime.now().toString()}';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test notification sent!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      Logger.error('Failed to send test notification', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send notification: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Test background task execution
  Future<void> _testBackgroundTask() async {
    try {
      // Simulate a background task
      setState(() {
        _lastActivity = 'Testing background task at ${DateTime.now().toString()}';
      });
      
      // This would normally be called by the background service
      // For testing, we'll just simulate it
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _lastActivity = 'Background task completed at ${DateTime.now().toString()}';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Background task test completed!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      Logger.error('Failed to test background task', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Background task test failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background Mode Test'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Background Mode Status',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                _isBackgroundModeEnabled
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: _isBackgroundModeEnabled
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isBackgroundModeEnabled
                                    ? 'Enabled'
                                    : 'Disabled',
                                style: TextStyle(
                                  color: _isBackgroundModeEnabled
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Control Buttons
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Controls',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Toggle Background Mode
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _toggleBackgroundMode,
                              icon: Icon(
                                _isBackgroundModeEnabled
                                    ? Icons.stop
                                    : Icons.play_arrow,
                              ),
                              label: Text(
                                _isBackgroundModeEnabled
                                    ? 'Stop Background Mode'
                                    : 'Start Background Mode',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isBackgroundModeEnabled
                                    ? Colors.red
                                    : Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Test Notification
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _testNotification,
                              icon: const Icon(Icons.notifications),
                              label: const Text('Test Notification'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Test Background Task
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _testBackgroundTask,
                              icon: const Icon(Icons.work),
                              label: const Text('Test Background Task'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Activity Log
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Activity Log',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _lastActivity,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Background mode allows the app to send reminders, track streaks, and sync progress even when the app is not in use.',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
