import 'package:flutter/material.dart';

class AnimatedSudokuCell extends StatefulWidget {
  final int value;
  final bool isOriginal;
  final bool isSelected;
  final bool isHighlighted;
  final bool isSameValue;
  final VoidCallback onTap;
  final double size;
  final Border border;

  const AnimatedSudokuCell({
    super.key,
    required this.value,
    required this.isOriginal,
    required this.isSelected,
    required this.isHighlighted,
    required this.isSameValue,
    required this.onTap,
    required this.size,
    required this.border,
  });

  @override
  State<AnimatedSudokuCell> createState() => _AnimatedSudokuCellState();
}

class _AnimatedSudokuCellState extends State<AnimatedSudokuCell> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Start animation if there's a value
    if (widget.value != 0) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedSudokuCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If value changed from 0 to non-zero, animate
    if (oldWidget.value == 0 && widget.value != 0) {
      _controller.reset();
      _controller.forward();
    }
    // If value changed to 0, reset animation
    else if (oldWidget.value != 0 && widget.value == 0) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine cell background color
    Color backgroundColor;
    if (widget.isSelected) {
      backgroundColor = Colors.blue.shade200;
    } else if (widget.isSameValue) {
      backgroundColor = Colors.blue.shade100;
    } else if (widget.isHighlighted) {
      backgroundColor = Colors.blue.shade50;
    } else {
      backgroundColor = Colors.white;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: widget.border,
        ),
        child: Center(
          child: widget.value != 0
              ? AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    widget.value.toString(),
                    style: TextStyle(
                      fontSize: widget.size * 0.5,
                      fontWeight: widget.isOriginal ? FontWeight.bold : FontWeight.normal,
                      color: widget.isOriginal ? Colors.black : Colors.blue,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}