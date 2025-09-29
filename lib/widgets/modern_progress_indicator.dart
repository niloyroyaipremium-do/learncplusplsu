import 'package:flutter/material.dart';
import 'dart:math' as math;

class ModernProgressIndicator extends StatefulWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showPercentage;
  final String? label;
  final bool animated;

  const ModernProgressIndicator({
    super.key,
    required this.progress,
    this.size = 120.0,
    this.strokeWidth = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.showPercentage = true,
    this.label,
    this.animated = true,
  });

  @override
  State<ModernProgressIndicator> createState() =>
      _ModernProgressIndicatorState();
}

class _ModernProgressIndicatorState extends State<ModernProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ModernProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      if (widget.animated) {
        _animation =
            Tween<double>(
              begin: _animation.value,
              end: widget.progress,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOutCubic,
              ),
            );
        _animationController.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final progressColor =
        widget.progressColor ?? Theme.of(context).primaryColor;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          // Background circle
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _ProgressPainter(
              progress: widget.animated ? _animation.value : widget.progress,
              backgroundColor: backgroundColor,
              progressColor: progressColor,
              strokeWidth: widget.strokeWidth,
            ),
          ),
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.showPercentage)
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Text(
                        '${(widget.animated ? _animation.value * 100 : widget.progress * 100).toInt()}%',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: progressColor,
                            ),
                      );
                    },
                  ),
                if (widget.label != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.label!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _ProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // Progress dots
    if (progress > 0) {
      final dotPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.fill;

      final dotCount = (progress * 20).round();
      for (int i = 0; i < dotCount; i++) {
        final angle = startAngle + (sweepAngle * i / 20);
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);

        canvas.drawCircle(Offset(x, y), 2.0, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Linear progress indicator
class ModernLinearProgressIndicator extends StatefulWidget {
  final double progress;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool animated;
  final String? label;

  const ModernLinearProgressIndicator({
    super.key,
    required this.progress,
    this.height = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.animated = true,
    this.label,
  });

  @override
  State<ModernLinearProgressIndicator> createState() =>
      _ModernLinearProgressIndicatorState();
}

class _ModernLinearProgressIndicatorState
    extends State<ModernLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ModernLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      if (widget.animated) {
        _animation =
            Tween<double>(
              begin: _animation.value,
              end: widget.progress,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOutCubic,
              ),
            );
        _animationController.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final progressColor =
        widget.progressColor ?? Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: widget.animated
                    ? _animation.value
                    : widget.progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        progressColor,
                        progressColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Step progress indicator
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;
  final Color? activeColor;
  final Color? inactiveColor;
  final double size;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
    this.activeColor,
    this.inactiveColor,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = this.activeColor ?? Theme.of(context).primaryColor;
    final inactiveColor = this.inactiveColor ?? Colors.grey[300]!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index < currentStep;
        final isCurrent = index == currentStep;

        return Row(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: isActive ? activeColor : inactiveColor,
                shape: BoxShape.circle,
                border: isCurrent
                    ? Border.all(color: activeColor, width: 2)
                    : null,
              ),
              child: Center(
                child: isActive
                    ? Icon(Icons.check, color: Colors.white, size: size * 0.5)
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isCurrent ? activeColor : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: size * 0.4,
                        ),
                      ),
              ),
            ),
            if (index < totalSteps - 1)
              Container(
                width: 30,
                height: 2,
                color: isActive ? activeColor : inactiveColor,
              ),
          ],
        );
      }),
    );
  }
}
