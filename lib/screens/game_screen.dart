import 'package:flutter/material.dart';
import '../widgets/help_overlay.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../widgets/animated_timer.dart';
import '../widgets/animated_game_button.dart';
import '../widgets/difficulty_indicator.dart';
import '../widgets/sudoku_board.dart';
import '../widgets/number_pad.dart';
import '../widgets/game_completion_dialog.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/animated_settings_button.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _showHelp = false;

  void _hideHelp() {
    setState(() {
      _showHelp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    
    // Check if game is complete and show dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (gameProvider.game.isComplete) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => GameCompletionDialog(
            difficulty: gameProvider.game.difficulty,
            time: gameProvider.elapsedTime,
          ),
        );
      }
    });
    
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            gameProvider.pauseTimer();
            final shouldPop = await _showExitConfirmationDialog(context);
            if (!shouldPop) {
              gameProvider.resumeTimer();
            }
            return shouldPop;
          },
          child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sudoku - ${gameProvider.game.difficulty.toUpperCase()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () => setState(() => _showHelp = true),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AnimatedSettingsButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const SettingsDialog(),
                  );
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Timer and difficulty info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Timer
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.blue),
                          const SizedBox(width: 8),
                          AnimatedTimer(
                            seconds: int.parse(gameProvider.elapsedTime.split(':')[0]) * 60 + int.parse(gameProvider.elapsedTime.split(':')[1]),
                            isRunning: !gameProvider.game.isComplete,
                          ),
                        ],
                      ),
                    ),
                    DifficultyIndicator(
                      difficulty: gameProvider.game.difficulty,
                    ),
                  ],
                ),
              ),
              
              // Sudoku board
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SudokuBoard(),
                ),
              ),
              
              // Controls
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnimatedGameButton(
                      icon: Icons.lightbulb_outline,
                      label: 'Hint',
                      onPressed: () => gameProvider.getHint(),
                      color: Colors.amber,
                    ),
                    AnimatedGameButton(
                      icon: Icons.clear,
                      label: 'Clear',
                      onPressed: () => gameProvider.clearCell(),
                      color: Colors.red,
                    ),
                    AnimatedGameButton(
                      icon: Icons.check_circle_outline,
                      label: 'Check',
                      onPressed: () => _checkBoard(context),
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
              
              // Number pad
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: NumberPad(),
              ),
            ],
          ),
        ),
          ),
        ),
        if (_showHelp)
          HelpOverlay(onClose: _hideHelp),
      ],
    );
  }
  
  Widget _buildControlButton(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
  
  void _checkBoard(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    bool isValid = gameProvider.checkBoardValidity();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isValid ? 'Board is valid so far!' : 'There are conflicts in the board!',
        ),
        backgroundColor: isValid ? Colors.green : Colors.red,
      ),
    );
  }
  
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Game?'),
        content: const Text('Your progress will be saved. Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('EXIT'),
          ),
        ],
      ),
    ) ?? false;
  }
  

}