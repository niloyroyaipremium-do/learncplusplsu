// Enhanced Tutorial Demo - Showcasing the new theme elements
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/tutorial_theme.dart';
import '../../widgets/tutorial_widgets.dart';

class EnhancedTutorialDemo extends StatefulWidget {
  const EnhancedTutorialDemo({super.key});

  @override
  State<EnhancedTutorialDemo> createState() => _EnhancedTutorialDemoState();
}

class _EnhancedTutorialDemoState extends State<EnhancedTutorialDemo>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isDarkMode = true;
  double _progress = 0.3;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode 
          ? TutorialTheme.darkTutorialBackground 
          : TutorialTheme.lightTutorialBackground,
      appBar: AppBar(
        title: Text(
          '🎨 Enhanced Tutorial Theme',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: _isDarkMode 
            ? TutorialTheme.darkTutorialPrimary 
            : TutorialTheme.tutorialPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: _isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
        ],
        bottom: TutorialTabBar(
          controller: _tabController,
          tabs: const ['Overview', 'Components', 'Examples'],
          isDarkMode: _isDarkMode,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildComponentsTab(),
          _buildExamplesTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          TutorialHeader(
            title: '🎨 Enhanced Tutorial Theme',
            subtitle: 'Experience the new Duolingo-inspired design system',
            isDarkMode: _isDarkMode,
          ),
          const SizedBox(height: 24),
          
          // Progress indicator
          TutorialProgressBar(
            progress: _progress,
            isDarkMode: _isDarkMode,
            label: 'Learning Progress',
          ),
          const SizedBox(height: 24),
          
          // Achievement badges
          TutorialAchievementBadge(
            title: 'Theme Master',
            description: 'Successfully implemented the new tutorial theme',
            icon: Icons.palette,
            isUnlocked: true,
          ),
          const SizedBox(height: 16),
          
          TutorialAchievementBadge(
            title: 'Code Explorer',
            description: 'Complete 5 more tutorials to unlock',
            icon: Icons.code,
            isUnlocked: false,
          ),
          const SizedBox(height: 24),
          
          // Floating cards
          TutorialFloatingCard(
            title: 'Color Palette',
            content: 'Beautiful Duolingo-inspired colors with perfect contrast ratios for both light and dark modes.',
            icon: Icons.color_lens,
            isDarkMode: _isDarkMode,
            iconColor: TutorialTheme.tutorialInfo,
          ),
          
          TutorialFloatingCard(
            title: 'Typography',
            content: 'Enhanced text styles with better readability and modern font choices.',
            icon: Icons.text_fields,
            isDarkMode: _isDarkMode,
            iconColor: TutorialTheme.tutorialSuccess,
          ),
          
          TutorialFloatingCard(
            title: 'Animations',
            content: 'Smooth transitions and micro-interactions that make learning enjoyable.',
            icon: Icons.animation,
            isDarkMode: _isDarkMode,
            iconColor: TutorialTheme.tutorialAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildComponentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          TutorialSectionHeader(
            title: 'UI Components',
            subtitle: 'Explore the enhanced tutorial components',
            icon: Icons.widgets,
            isDarkMode: _isDarkMode,
          ),
          const SizedBox(height: 24),
          
          // Different card types
          TutorialCard(
            title: 'Info Card',
            content: 'This is a standard info card with enhanced styling and better visual hierarchy.',
            icon: Icons.info_outline,
            iconColor: TutorialTheme.tutorialInfo,
            isDarkMode: _isDarkMode,
          ),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _isDarkMode 
                ? TutorialTheme.darkInfoCardDecoration 
                : TutorialTheme.successCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: TutorialTheme.tutorialSuccess,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Success Card',
                      style: TutorialTheme.cardTitle.copyWith(
                        color: TutorialTheme.tutorialSuccess,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'This card uses the success theme with green accents and enhanced shadows.',
                  style: TutorialTheme.cardContent.copyWith(
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _isDarkMode 
                ? TutorialTheme.darkInfoCardDecoration 
                : TutorialTheme.warningCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: TutorialTheme.tutorialWarning,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Warning Card',
                      style: TutorialTheme.cardTitle.copyWith(
                        color: TutorialTheme.tutorialWarning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'This card uses the warning theme with orange accents for important information.',
                  style: TutorialTheme.cardContent.copyWith(
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Button examples
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              TutorialButton(
                text: 'Primary',
                type: TutorialButtonType.primary,
                icon: Icons.star,
              ),
              TutorialButton(
                text: 'Success',
                type: TutorialButtonType.success,
                icon: Icons.check,
              ),
              TutorialButton(
                text: 'Warning',
                type: TutorialButtonType.warning,
                icon: Icons.warning,
              ),
              TutorialButton(
                text: 'Info',
                type: TutorialButtonType.info,
                icon: Icons.info,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamplesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          TutorialSectionHeader(
            title: 'Code Examples',
            subtitle: 'See the enhanced code blocks in action',
            icon: Icons.code,
            isDarkMode: _isDarkMode,
          ),
          const SizedBox(height: 24),
          
          // Code example
          TutorialCodeBlock(
            title: 'Enhanced C++ Example',
            code: '''#include <iostream>
#include <string>
using namespace std;

int main() {
    // Enhanced tutorial theme example
    string message = "Hello, Enhanced Tutorial!";
    
    cout << "🎨 " << message << endl;
    cout << "✨ Beautiful colors and typography!" << endl;
    
    // Progress tracking
    int progress = 75;
    cout << "📊 Progress: " << progress << "%" << endl;
    
    return 0;
}''',
            isDarkMode: _isDarkMode,
            onRun: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Code executed successfully! 🎉'),
                  backgroundColor: TutorialTheme.tutorialSuccess,
                ),
              );
            },
            onCopy: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Code copied to clipboard! 📋'),
                  backgroundColor: TutorialTheme.tutorialInfo,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          
          // Gradient examples
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: TutorialTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Primary Gradient',
                  style: TutorialTheme.cardTitle.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Beautiful gradient backgrounds for headers and special sections.',
                  style: TutorialTheme.cardContent.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: TutorialTheme.successGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Success Gradient',
                  style: TutorialTheme.cardTitle.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Perfect for achievement cards and success messages.',
                  style: TutorialTheme.cardContent.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}