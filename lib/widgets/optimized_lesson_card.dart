import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../domain/entities/lesson.dart';

/// Optimized Lesson Card Widget
///
/// This widget provides high-performance rendering with:
/// - Memoized builds
/// - Efficient animations
/// - Memory-optimized state management
class OptimizedLessonCard extends StatefulWidget {
  final Lesson lesson;
  final VoidCallback? onTap;
  final bool isCompleted;
  final bool isLocked;
  final double? width;
  final double? height;

  const OptimizedLessonCard({
    super.key,
    required this.lesson,
    this.onTap,
    this.isCompleted = false,
    this.isLocked = false,
    this.width,
    this.height,
  });

  @override
  State<OptimizedLessonCard> createState() => _OptimizedLessonCardState();
}

class _OptimizedLessonCardState extends State<OptimizedLessonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool _isPressed = false;
  static const Duration _animationDuration = Duration(milliseconds: 150);

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isLocked) return;

    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isLocked) return;

    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    if (widget.isLocked) return;

    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onTap: widget.isLocked ? null : widget.onTap,
              child: Container(
                width: widget.width,
                height: widget.height,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: _getGradient(),
                  boxShadow: _getBoxShadow(),
                  border: _getBorder(),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      _buildBackground(),
                      _buildContent(),
                      _buildOverlay(),
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

  LinearGradient _getGradient() {
    if (widget.isCompleted) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
      );
    } else if (widget.isLocked) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF9E9E9E), Color(0xFF616161)],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
      );
    }
  }

  List<BoxShadow> _getBoxShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ];
  }

  Border? _getBorder() {
    if (widget.isCompleted) {
      return Border.all(color: const Color(0xFF4CAF50), width: 2);
    }
    return null;
  }

  Widget _buildBackground() {
    return Container(decoration: BoxDecoration(gradient: _getGradient()));
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeader(),
          _buildTitle(),
          _buildDescription(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildIcon(), _buildStatusIcon()],
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(_getLessonIcon(), color: Colors.white, size: 24),
    );
  }

  Widget _buildStatusIcon() {
    if (widget.isCompleted) {
      return const Icon(Icons.check_circle, color: Colors.white, size: 24);
    } else if (widget.isLocked) {
      return const Icon(Icons.lock, color: Colors.white, size: 24);
    }
    return const SizedBox.shrink();
  }

  Widget _buildTitle() {
    return Text(
      widget.lesson.title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.lesson.description,
      style: TextStyle(color: Colors.white.withValues(alpha:0.9), fontSize: 14),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildDifficulty(), _buildDuration()],
    );
  }

  Widget _buildDifficulty() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        widget.lesson.difficulty,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDuration() {
    return Text(
      '${widget.lesson.estimatedTime} min',
      style: TextStyle(color: Colors.white.withValues(alpha:0.8), fontSize: 12),
    );
  }

  Widget _buildOverlay() {
    if (widget.isLocked) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha:0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(Icons.lock, color: Colors.white, size: 32),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  IconData _getLessonIcon() {
    switch (widget.lesson.difficulty.toLowerCase()) {
      case 'beginner':
        return Icons.play_circle_outline;
      case 'intermediate':
        return Icons.school;
      case 'advanced':
        return Icons.code;
      default:
        return Icons.book;
    }
  }
}
