import 'package:flutter/material.dart';

class AnimatedNumberButton extends StatefulWidget {
  final int number;
  final bool isSelected;
  final VoidCallback onPressed;

  const AnimatedNumberButton({
    super.key,
    required this.number,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  State<AnimatedNumberButton> createState() => _AnimatedNumberButtonState();
}

class _AnimatedNumberButtonState extends State<AnimatedNumberButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? Theme.of(context).primaryColor
                    : _isPressed
                        ? Colors.grey[300]
                        : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: widget.isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  widget.number.toString(),
                  style: TextStyle(
                    color: widget.isSelected ? Colors.white : Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}