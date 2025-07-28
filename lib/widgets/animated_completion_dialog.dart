import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedCompletionDialog extends StatefulWidget {
  final String difficulty;
  final Duration completionTime;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToMenu;

  const AnimatedCompletionDialog({
    super.key,
    required this.difficulty,
    required this.completionTime,
    required this.onPlayAgain,
    required this.onBackToMenu,
  });

  @override
  State<AnimatedCompletionDialog> createState() => _AnimatedCompletionDialogState();
}

class _AnimatedCompletionDialogState extends State<AnimatedCompletionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final difficultyColor = AppTheme.getDifficultyColor(widget.difficulty);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Congratulations!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You completed ${widget.difficulty} difficulty',
                    style: TextStyle(
                      fontSize: 16,
                      color: difficultyColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Time: ${_formatDuration(widget.completionTime)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: widget.onBackToMenu,
                        child: const Text('Menu'),
                      ),
                      ElevatedButton(
                        onPressed: widget.onPlayAgain,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: difficultyColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Play Again'),
                      ),
                    ],
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