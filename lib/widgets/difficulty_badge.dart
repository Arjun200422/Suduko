import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DifficultyBadge extends StatelessWidget {
  final String difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  const DifficultyBadge({
    super.key,
    required this.difficulty,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getDifficultyColor(difficulty);
    final textColor = isSelected ? Colors.white : color;
    final backgroundColor = isSelected ? color : color.withOpacity(0.1);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          difficulty,
          style: TextStyle(
            color: textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}