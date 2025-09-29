import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../domain/entities/lesson.dart';

class AnimatedLessonCard extends StatefulWidget {
  final Lesson lesson;
  final int index;

  const AnimatedLessonCard({
    super.key,
    required this.lesson,
    required this.index,
  });

  @override
  State<AnimatedLessonCard> createState() => _AnimatedLessonCardState();
}

class _AnimatedLessonCardState extends State<AnimatedLessonCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _hoverAnimation;
  late Animation<double> _shimmerAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 100)),
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animation with delay
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    setState(() {
      _isHovered = true;
    });
    _hoverController.forward();
  }

  void _onHoverExit() {
    setState(() {
      _isHovered = false;
    });
    _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_animationController, _hoverController]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: ScaleTransition(
                scale: _hoverAnimation,
                child: MouseRegion(
                  onEnter: (_) => _onHoverEnter(),
                  onExit: (_) => _onHoverExit(),
                  child: Container(
                    width: 280,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).cardColor,
                          Theme.of(context).cardColor.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getDifficultyColor(
                            widget.lesson.difficulty,
                          ).withOpacity(0.1),
                          blurRadius: _isHovered ? 20 : 10,
                          offset: Offset(0, _isHovered ? 8 : 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.go('/lesson/${widget.lesson.id}'),
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            // Shimmer effect
                            if (_isHovered)
                              AnimatedBuilder(
                                animation: _shimmerAnimation,
                                builder: (context, child) {
                                  return Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          begin: Alignment(
                                            -1.0 + _shimmerAnimation.value,
                                            -1.0,
                                          ),
                                          end: Alignment(
                                            1.0 + _shimmerAnimation.value,
                                            1.0,
                                          ),
                                          colors: [
                                            Colors.transparent,
                                            Colors.white.withOpacity(0.1),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            // Content
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              _getDifficultyColor(
                                                widget.lesson.difficulty,
                                              ).withOpacity(0.2),
                                              _getDifficultyColor(
                                                widget.lesson.difficulty,
                                              ).withOpacity(0.1),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          border: Border.all(
                                            color: _getDifficultyColor(
                                              widget.lesson.difficulty,
                                            ).withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          widget.lesson.difficulty,
                                          style: TextStyle(
                                            color: _getDifficultyColor(
                                              widget.lesson.difficulty,
                                            ),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      if (widget.lesson.isCompleted)
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.check_circle_rounded,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    widget.lesson.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Text(
                                      widget.lesson.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.grey[600],
                                            height: 1.4,
                                          ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.access_time_rounded,
                                              size: 14,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              widget.lesson.duration,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: _getDifficultyColor(
                                            widget.lesson.difficulty,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 16,
                                          color: _getDifficultyColor(
                                            widget.lesson.difficulty,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
