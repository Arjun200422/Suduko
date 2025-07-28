import 'package:flutter/material.dart';

class HelpOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const HelpOverlay({super.key, required this.onClose});

  @override
  State<HelpOverlay> createState() => _HelpOverlayState();
}

class _HelpOverlayState extends State<HelpOverlay> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentStep = 0;

  final List<HelpStep> _helpSteps = [
    HelpStep(
      title: 'Welcome to Sudoku!',
      description: 'Let\'s learn how to play this classic puzzle game.',
      icon: Icons.emoji_objects,
    ),
    HelpStep(
      title: 'Select a Cell',
      description: 'Tap any empty cell on the board to select it.',
      icon: Icons.touch_app,
    ),
    HelpStep(
      title: 'Enter Numbers',
      description: 'Use the number pad below to fill in the selected cell.',
      icon: Icons.keyboard,
    ),
    HelpStep(
      title: 'Game Controls',
      description: 'Use Hint for help, Clear to remove numbers, and Check to verify your progress.',
      icon: Icons.games,
    ),
    HelpStep(
      title: 'Complete the Puzzle',
      description: 'Fill all cells following Sudoku rules to win!',
      icon: Icons.emoji_events,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _helpSteps.length - 1) {
      _slideController.reverse().then((_) {
        setState(() {
          _currentStep++;
        });
        _slideController.forward();
      });
    } else {
      _fadeController.reverse().then((_) {
        widget.onClose();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Stack(
        children: [
          GestureDetector(
            onTap: _nextStep,
            child: Container(
              color: Colors.black54,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _helpSteps[_currentStep].icon,
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _helpSteps[_currentStep].title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _helpSteps[_currentStep].description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _helpSteps.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentStep
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tap anywhere to continue',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HelpStep {
  final String title;
  final String description;
  final IconData icon;

  const HelpStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}