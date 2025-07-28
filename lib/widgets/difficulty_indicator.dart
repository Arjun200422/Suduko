import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DifficultyIndicator extends StatefulWidget {
  final String difficulty;

  const DifficultyIndicator({
    super.key,
    required this.difficulty,
  });

  @override
  State<DifficultyIndicator> createState() => _DifficultyIndicatorState();
}

class _DifficultyIndicatorState extends State<DifficultyIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final difficultyColor = AppTheme.getDifficultyColor(widget.difficulty);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: difficultyColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: difficultyColor.withOpacity(0.3 * _glowAnimation.value),
                blurRadius: 8 * _glowAnimation.value,
                spreadRadius: 2 * _glowAnimation.value,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getDifficultyIcon(),
                color: difficultyColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.difficulty,
                style: TextStyle(
                  color: difficultyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getDifficultyIcon() {
    switch (widget.difficulty.toLowerCase()) {
      case 'easy':
        return Icons.star_border;
      case 'medium':
        return Icons.star_half;
      case 'hard':
        return Icons.star;
      default:
        return Icons.star_border;
    }
  }
}