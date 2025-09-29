import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/background_service.dart';
import '../services/notification_service.dart';
import '../utils/logger.dart';

/// Background Mode Settings Widget
///
/// Allows users to configure background processing settings
class BackgroundModeSettings extends StatefulWidget {
  const BackgroundModeSettings({Key? key}) : super(key: key);

  @override
  State<BackgroundModeSettings> createState() => _BackgroundModeSettingsState();
}

class _BackgroundModeSettingsState extends State<BackgroundModeSettings> {
  bool _isBackgroundModeEnabled = false;
  bool _isDailyRemindersEnabled = false;
  bool _isStreakTrackingEnabled = false;
  bool _isProgressSyncEnabled = false;
  int _reminderHour = 9;
  int _reminderMinute = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Load current settings from SharedPreferences
  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        _isBackgroundModeEnabled =
            prefs.getBool('background_mode_enabled') ?? false;
        _isDailyRemindersEnabled =
            prefs.getBool('daily_reminders_enabled') ?? true;
        _isStreakTrackingEnabled =
            prefs.getBool('streak_tracking_enabled') ?? true;
        _isProgressSyncEnabled = prefs.getBool('progress_sync_enabled') ?? true;
        _reminderHour = prefs.getInt('reminder_hour') ?? 9;
        _reminderMinute = prefs.getInt('reminder_minute') ?? 0;
      });
    } catch (e) {
      Logger.error('Failed to load background settings', e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('background_mode_enabled', _isBackgroundModeEnabled);
      await prefs.setBool('daily_reminders_enabled', _isDailyRemindersEnabled);
      await prefs.setBool('streak_tracking_enabled', _isStreakTrackingEnabled);
      await prefs.setBool('progress_sync_enabled', _isProgressSyncEnabled);
      await prefs.setInt('reminder_hour', _reminderHour);
      await prefs.setInt('reminder_minute', _reminderMinute);

      // Apply settings to background service
      await _applyBackgroundSettings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Background settings saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      Logger.error('Failed to save background settings', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Apply background settings to the service
  Future<void> _applyBackgroundSettings() async {
    final backgroundService = BackgroundService();

    if (_isBackgroundModeEnabled) {
      await backgroundService.start();
    } else {
      await backgroundService.stop();
    }

    // Configure notifications
    final notificationService = NotificationService();
    await notificationService.initialize();

    if (_isDailyRemindersEnabled) {
      await notificationService.scheduleDailyReminder(
        hour: _reminderHour,
        minute: _reminderMinute,
        message: 'Time to learn C++! Keep your streak alive! 🚀',
      );
    } else {
      await notificationService.cancelNotification(0);
    }
  }

  /// Show time picker for reminder time
  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _reminderHour, minute: _reminderMinute),
    );

    if (picked != null) {
      setState(() {
        _reminderHour = picked.hour;
        _reminderMinute = picked.minute;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Background Mode Settings',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Background Mode Toggle
            SwitchListTile(
              title: const Text('Enable Background Mode'),
              subtitle: const Text('Allow app to run tasks in the background'),
              value: _isBackgroundModeEnabled,
              onChanged: (value) {
                setState(() {
                  _isBackgroundModeEnabled = value;
                });
              },
            ),

            if (_isBackgroundModeEnabled) ...[
              const Divider(),

              // Daily Reminders Toggle
              SwitchListTile(
                title: const Text('Daily Learning Reminders'),
                subtitle: const Text(
                  'Get notified to maintain your learning streak',
                ),
                value: _isDailyRemindersEnabled,
                onChanged: (value) {
                  setState(() {
                    _isDailyRemindersEnabled = value;
                  });
                },
              ),

              // Reminder Time Selection
              if (_isDailyRemindersEnabled) ...[
                ListTile(
                  title: const Text('Reminder Time'),
                  subtitle: Text(
                    '${_reminderHour.toString().padLeft(2, '0')}:${_reminderMinute.toString().padLeft(2, '0')}',
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: _selectReminderTime,
                ),
              ],

              const Divider(),

              // Streak Tracking Toggle
              SwitchListTile(
                title: const Text('Streak Tracking'),
                subtitle: const Text(
                  'Automatically track your daily learning streak',
                ),
                value: _isStreakTrackingEnabled,
                onChanged: (value) {
                  setState(() {
                    _isStreakTrackingEnabled = value;
                  });
                },
              ),

              // Progress Sync Toggle
              SwitchListTile(
                title: const Text('Progress Sync'),
                subtitle: const Text('Sync your progress across devices'),
                value: _isProgressSyncEnabled,
                onChanged: (value) {
                  setState(() {
                    _isProgressSyncEnabled = value;
                  });
                },
              ),
            ],

            const SizedBox(height: 16),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveSettings,
                icon: const Icon(Icons.save),
                label: const Text('Save Settings'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 8),

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
                      'Background mode helps maintain your learning streak and keeps you motivated with timely reminders.',
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
