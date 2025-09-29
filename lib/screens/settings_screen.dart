import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../providers/app_provider.dart';
import '../providers/progress_provider.dart';
import '../services/progress_export_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Theme Section
              _buildSection(
                context,
                title: 'Appearance',
                children: [
                  _buildSwitchTile(
                    context,
                    title: 'Dark Mode',
                    subtitle: 'Switch between light and dark themes',
                    value: appProvider.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      appProvider.setThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                  ),
                  _buildListTile(
                    context,
                    title: 'Theme Mode',
                    subtitle: _getThemeModeText(appProvider.themeMode),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showThemeModeDialog(context, appProvider),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Learning Section
              _buildSection(
                context,
                title: 'Learning',
                children: [
                  _buildListTile(
                    context,
                    title: 'Reset Progress',
                    subtitle: 'Clear all your learning progress',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showResetProgressDialog(context, appProvider),
                  ),
                  _buildListTile(
                    context,
                    title: 'Export Progress',
                    subtitle: 'Save your progress data',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showExportProgressDialog(context),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // About Section
              _buildSection(
                context,
                title: 'About',
                children: [
                  _buildListTile(
                    context,
                    title: 'App Version',
                    subtitle: _appVersion,
                    trailing: const Icon(Icons.info_outline),
                  ),
                  _buildListTile(
                    context,
                    title: 'Rate App',
                    subtitle: 'Rate us on the Play Store',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _rateApp(context),
                  ),
                  _buildListTile(
                    context,
                    title: 'Share App',
                    subtitle: 'Tell your friends about Learn C++',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _shareApp(context),
                  ),
                  _buildListTile(
                    context,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showPrivacyPolicy(context),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Developer Section
              _buildSection(
                context,
                title: 'Developer',
                children: [
                  _buildListTile(
                    context,
                    title: 'Contact Us',
                    subtitle: 'Get in touch with our team',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _contactUs(context),
                  ),
                  _buildListTile(
                    context,
                    title: 'Open Source',
                    subtitle: 'View source code on GitHub',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _openGitHub(context),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Card(child: Column(children: children)),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeModeDialog(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: RadioGroup<ThemeMode>(
          groupValue: appProvider.themeMode,
          onChanged: (ThemeMode? value) {
            if (value != null) {
              appProvider.setThemeMode(value);
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Light'),
                value: ThemeMode.light,
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark'),
                value: ThemeMode.dark,
              ),
              RadioListTile<ThemeMode>(
                title: const Text('System'),
                value: ThemeMode.system,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetProgressDialog(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text(
          'Are you sure you want to reset all your learning progress? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appProvider.resetProgress();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Progress reset successfully')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showExportProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Progress'),
        content: const Text(
          'Export your learning progress to a JSON file. This includes your XP, level, streak, completed lessons, and quiz results.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _exportProgress(context),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportProgress(BuildContext context) async {
    Navigator.pop(context); // Close the dialog first

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Exporting progress...'),
          ],
        ),
      ),
    );

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final progressProvider = Provider.of<ProgressProvider>(
        context,
        listen: false,
      );

      // Check if there's progress to export
      final hasProgress = await ProgressExportService.hasProgressToExport(
        appProvider,
      );
      if (!hasProgress) {
        if (mounted) {
          navigator.pop(); // Close loading dialog
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text(
                'No progress data to export yet. Complete some lessons first!',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Export the progress
      final success = await ProgressExportService.exportProgress(
        appProvider: appProvider,
        progressProvider: progressProvider,
      );

      if (mounted) {
        navigator.pop(); // Close loading dialog

        if (success) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Progress exported successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Failed to export progress. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        navigator.pop(); // Close loading dialog
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error exporting progress: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _rateApp(BuildContext context) async {
    final Uri url = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.example.niloylearncplusplus',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(content: Text('Could not launch Play Store')),
        );
      }
    }
  }

  void _shareApp(BuildContext context) async {
    final Uri url = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.example.niloylearncplusplus',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(content: Text('Could not launch Play Store')),
        );
      }
    }
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Learn C++ respects your privacy. We do not collect personal data. All progress is stored locally on your device.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _contactUs(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@learncpp.app',
      query: 'subject=Learn C++ Feedback',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(content: Text('Could not launch email client')),
        );
      }
    }
  }

  void _openGitHub(BuildContext context) async {
    final Uri url = Uri.parse(
      'https://github.com/your_username/niloylearncplusplus',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(content: Text('Could not launch GitHub')),
        );
      }
    }
  }
}
