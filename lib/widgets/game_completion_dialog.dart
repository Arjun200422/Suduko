import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';

class GameCompletionDialog extends StatelessWidget {
  final String difficulty;
  final String time;

  const GameCompletionDialog({
    super.key,
    required this.difficulty,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '🎉 Puzzle Completed! 🎉',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
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
          Text(
            'Congratulations!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You completed the $difficulty puzzle in:',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop(); // Return to home screen
          },
          child: const Text('RETURN TO MENU'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Start a new game with the same difficulty
            Provider.of<GameProvider>(context, listen: false)
                .newGame(difficulty.toLowerCase());
          },
          child: const Text('PLAY AGAIN'),
        ),
      ],
    );
  }

  // Show the dialog
  static void show(BuildContext context, String difficulty, String time) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameCompletionDialog(
        difficulty: difficulty,
        time: time,
      ),
    );
  }
}