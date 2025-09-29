import 'package:flutter/material.dart';

class ModernProgressIndicator extends StatelessWidget {
  final double progress;
  final double size;
  final String? label;
  final Color? color;
  final Color? backgroundColor;
  final double strokeWidth;

  const ModernProgressIndicator({
    super.key,
    required this.progress,
    this.size = 80,
    this.label,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 8,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final progressColor = color ?? Theme.of(context).primaryColor;
    final bgColor = backgroundColor ?? Colors.grey[300]!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              // Background circle
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: strokeWidth,
                backgroundColor: bgColor,
                valueColor: AlwaysStoppedAnimation<Color>(bgColor),
              ),
              // Progress circle
              CircularProgressIndicator(
                value: clampedProgress,
                strokeWidth: strokeWidth,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
              // Center content
              Center(
                child: Text(
                  '${(clampedProgress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: size * 0.2,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 8),
          Text(
            label!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class ModernLinearProgressIndicator extends StatelessWidget {
  final double progress;
  final double height;
  final String? label;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const ModernLinearProgressIndicator({
    super.key,
    required this.progress,
    this.height = 8,
    this.label,
    this.color,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final progressColor = color ?? Theme.of(context).primaryColor;
    final bgColor = backgroundColor ?? Colors.grey[300]!;
    final borderRadiusValue = borderRadius ?? BorderRadius.circular(height / 2);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadiusValue,
          ),
          child: Stack(
            children: [
              // Background
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: borderRadiusValue,
                ),
              ),
              // Progress
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: MediaQuery.of(context).size.width * clampedProgress,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      progressColor,
                      progressColor.withOpacity(0.8),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: borderRadiusValue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(clampedProgress * 100).toInt()}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: progressColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}