import 'package:flutter/material.dart';

class AnimatedGridLine extends StatefulWidget {
  final bool isThick;
  final bool isHorizontal;
  final double length;

  const AnimatedGridLine({
    super.key,
    required this.isThick,
    required this.isHorizontal,
    required this.length,
  });

  @override
  State<AnimatedGridLine> createState() => _AnimatedGridLineState();
}

class _AnimatedGridLineState extends State<AnimatedGridLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _lineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.isHorizontal ? widget.length * _lineAnimation.value : (widget.isThick ? 2.0 : 1.0),
          height: widget.isHorizontal ? (widget.isThick ? 2.0 : 1.0) : widget.length * _lineAnimation.value,
          decoration: BoxDecoration(
            color: widget.isThick
                ? Theme.of(context).primaryColor
                : Theme.of(context).dividerColor,
            boxShadow: widget.isThick
                ? [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }
}