import 'package:flutter/material.dart';
import '../core/theme/tutorial_theme.dart';

/// Reusable tutorial widgets for consistent theming across all tutorial screens

class TutorialCard extends StatefulWidget {
  final String title;
  final String content;
  final IconData? icon;
  final Color? iconColor;
  final bool isDarkMode;
  final VoidCallback? onTap;

  const TutorialCard({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.iconColor,
    this.isDarkMode = false,
    this.onTap,
  });

  @override
  State<TutorialCard> createState() => _TutorialCardState();
}

class _TutorialCardState extends State<TutorialCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TutorialTheme.mediumAnimation,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TutorialTheme.defaultCurve,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TutorialTheme.defaultCurve,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(16),
                  onTapDown: (_) => _animationController.reverse(),
                  onTapUp: (_) => _animationController.forward(),
                  onTapCancel: () => _animationController.forward(),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: widget.isDarkMode 
                        ? TutorialTheme.darkInfoCardDecoration 
                        : TutorialTheme.infoCardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                color: widget.iconColor ?? (widget.isDarkMode 
                                    ? TutorialTheme.darkTutorialPrimary 
                                    : TutorialTheme.tutorialPrimary),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: Text(
                                widget.title,
                                style: TutorialTheme.cardTitle.copyWith(
                                  color: widget.isDarkMode 
                                      ? TutorialTheme.darkTutorialPrimary 
                                      : TutorialTheme.tutorialPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.content,
                          style: TutorialTheme.cardContent.copyWith(
                            color: widget.isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TutorialCodeBlock extends StatefulWidget {
  final String title;
  final String code;
  final bool isDarkMode;
  final double fontSize;
  final VoidCallback? onRun;
  final VoidCallback? onCopy;

  const TutorialCodeBlock({
    super.key,
    required this.title,
    required this.code,
    this.isDarkMode = false,
    this.fontSize = 14.0,
    this.onRun,
    this.onCopy,
  });

  @override
  State<TutorialCodeBlock> createState() => _TutorialCodeBlockState();
}

class _TutorialCodeBlockState extends State<TutorialCodeBlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TutorialTheme.longAnimation,
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TutorialTheme.slideCurve,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TutorialTheme.defaultCurve,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: widget.isDarkMode 
                  ? TutorialTheme.darkCodeCardDecoration 
                  : TutorialTheme.codeCardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: widget.isDarkMode 
                          ? TutorialTheme.darkGradient 
                          : TutorialTheme.primaryGradient,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.code, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: TutorialTheme.navigationTitle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (widget.onRun != null)
                          IconButton(
                            onPressed: widget.onRun,
                            icon: const Icon(Icons.play_arrow, color: Colors.white),
                            tooltip: 'Run Code',
                          ),
                        if (widget.onCopy != null)
                          IconButton(
                            onPressed: widget.onCopy,
                            icon: const Icon(Icons.copy, color: Colors.white),
                            tooltip: 'Copy Code',
                          ),
                      ],
                    ),
                  ),
                  // Code content
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: widget.isDarkMode 
                          ? TutorialTheme.codeBackground 
                          : Colors.grey[50],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: SelectableText(
                      widget.code,
                      style: TutorialTheme.codeText.copyWith(
                        fontSize: widget.fontSize,
                        color: widget.isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TutorialHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDarkMode;
  final Widget? action;

  const TutorialHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.isDarkMode = false,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: isDarkMode 
            ? TutorialTheme.darkGradient 
            : TutorialTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode 
                ? TutorialTheme.darkTutorialPrimary 
                : TutorialTheme.tutorialPrimary).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TutorialTheme.tutorialTitle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TutorialTheme.tutorialSubtitle,
                    ),
                  ],
                ),
              ),
              if (action != null) action!,
            ],
          ),
        ],
      ),
    );
  }
}

class TutorialNavigationItem extends StatefulWidget {
  final String title;
  final IconData? icon;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback? onTap;

  const TutorialNavigationItem({
    super.key,
    required this.title,
    this.icon,
    this.isSelected = false,
    this.isDarkMode = false,
    this.onTap,
  });

  @override
  State<TutorialNavigationItem> createState() => _TutorialNavigationItemState();
}

class _TutorialNavigationItemState extends State<TutorialNavigationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TutorialTheme.shortAnimation,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TutorialTheme.defaultCurve,
    ));
    _colorAnimation = ColorTween(
      begin: widget.isDarkMode 
          ? TutorialTheme.darkTutorialPrimary.withOpacity(0.2)
          : TutorialTheme.tutorialPrimary.withOpacity(0.1),
      end: widget.isDarkMode 
          ? TutorialTheme.darkTutorialPrimary.withOpacity(0.3)
          : TutorialTheme.tutorialPrimary.withOpacity(0.2),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TutorialTheme.defaultCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: widget.isSelected
                ? (widget.isDarkMode 
                    ? TutorialTheme.darkActiveNavigationItemDecoration 
                    : TutorialTheme.activeNavigationItemDecoration)
                : TutorialTheme.navigationItemDecoration,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: (_) => _animationController.forward(),
                onTapUp: (_) => _animationController.reverse(),
                onTapCancel: () => _animationController.reverse(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: widget.isSelected
                              ? (widget.isDarkMode 
                                  ? TutorialTheme.darkTutorialPrimary 
                                  : TutorialTheme.tutorialPrimary)
                              : (widget.isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          widget.title,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: widget.isSelected
                                ? (widget.isDarkMode 
                                    ? TutorialTheme.darkTutorialPrimary 
                                    : TutorialTheme.tutorialPrimary)
                                : (widget.isDarkMode ? Colors.white70 : Colors.black87),
                          ),
                        ),
                      ),
                      if (widget.isSelected)
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: widget.isDarkMode 
                              ? TutorialTheme.darkTutorialPrimary 
                              : TutorialTheme.tutorialPrimary,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TutorialProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isDarkMode;

  const TutorialProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: currentStep / totalSteps,
              backgroundColor: isDarkMode 
                  ? Colors.grey[700] 
                  : Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                isDarkMode 
                    ? TutorialTheme.darkTutorialPrimary 
                    : TutorialTheme.tutorialPrimary,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(width: 16),
                      Text(
                        '$currentStep / $totalSteps',
                        style: TutorialTheme.progressText.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
        ],
      ),
    );
  }
}

class TutorialButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TutorialButtonType type;
  final IconData? icon;
  final bool isLoading;

  const TutorialButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = TutorialButtonType.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle style;
    switch (type) {
      case TutorialButtonType.primary:
        style = TutorialTheme.primaryButtonStyle;
        break;
      case TutorialButtonType.secondary:
        style = TutorialTheme.secondaryButtonStyle;
        break;
      case TutorialButtonType.accent:
        style = TutorialTheme.accentButtonStyle;
        break;
      case TutorialButtonType.success:
        style = TutorialTheme.successButtonStyle;
        break;
      case TutorialButtonType.warning:
        style = TutorialTheme.warningButtonStyle;
        break;
      case TutorialButtonType.info:
        style = TutorialTheme.infoButtonStyle;
        break;
    }

    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: style,
      icon: isLoading 
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Icon(icon ?? Icons.arrow_forward),
      label: Text(text),
    );
  }
}

enum TutorialButtonType { primary, secondary, accent, success, warning, info }

class TutorialTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<String> tabs;
  final bool isDarkMode;
  final bool isScrollable;

  const TutorialTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.isDarkMode = false,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode 
            ? TutorialTheme.darkTutorialSurface 
            : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode 
                ? Colors.grey[700]! 
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
        isScrollable: isScrollable,
        labelColor: isDarkMode 
            ? TutorialTheme.darkTutorialPrimary 
            : TutorialTheme.tutorialPrimary,
        unselectedLabelColor: isDarkMode 
            ? Colors.grey[400] 
            : Colors.grey[600],
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: isDarkMode 
                ? TutorialTheme.darkTutorialPrimary 
                : TutorialTheme.tutorialPrimary,
            width: 3,
          ),
          insets: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

// New enhanced widgets for better tutorial experience

class TutorialAchievementBadge extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;

  const TutorialAchievementBadge({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: TutorialTheme.achievementBadgeDecoration,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TutorialTheme.cardTitle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TutorialTheme.cardContent.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
        ],
      ),
    );
  }
}

class TutorialFloatingCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData? icon;
  final Color? iconColor;
  final bool isDarkMode;
  final VoidCallback? onTap;

  const TutorialFloatingCard({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.iconColor,
    this.isDarkMode = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: isDarkMode 
          ? TutorialTheme.darkFloatingCardDecoration 
          : TutorialTheme.floatingCardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: iconColor ?? (isDarkMode 
                            ? TutorialTheme.darkTutorialPrimary 
                            : TutorialTheme.tutorialPrimary),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: TutorialTheme.cardTitle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: TutorialTheme.cardContent.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TutorialProgressBar extends StatelessWidget {
  final double progress;
  final bool isDarkMode;
  final String? label;

  const TutorialProgressBar({
    super.key,
    required this.progress,
    this.isDarkMode = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TutorialTheme.progressText.copyWith(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: 8,
          decoration: isDarkMode 
              ? TutorialTheme.darkProgressBarDecoration 
              : TutorialTheme.progressBarDecoration,
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: isDarkMode 
                    ? TutorialTheme.darkGradient 
                    : TutorialTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TutorialSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final bool isDarkMode;
  final Color? accentColor;

  const TutorialSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.isDarkMode = false,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? (isDarkMode 
        ? TutorialTheme.darkTutorialPrimary 
        : TutorialTheme.tutorialPrimary);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TutorialTheme.sectionTitle.copyWith(
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TutorialTheme.sectionSubtitle.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
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