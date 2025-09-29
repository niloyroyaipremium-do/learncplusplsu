import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class BackgroundModeSettings extends StatelessWidget {
  const BackgroundModeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                'Background Mode',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable Background Learning'),
                    subtitle: const Text(
                      'Continue learning even when the app is in the background',
                    ),
                    value: true, // This would be connected to actual settings
                    onChanged: (value) {
                      // Handle background mode toggle
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Daily Reminders'),
                    subtitle: const Text(
                      'Get notified to continue your learning streak',
                    ),
                    value: true, // This would be connected to actual settings
                    onChanged: (value) {
                      // Handle daily reminders toggle
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}