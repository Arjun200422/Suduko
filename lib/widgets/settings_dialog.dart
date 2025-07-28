import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_manager.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late SettingsManager _settings;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _settings = Provider.of<SettingsManager>(context, listen: false);
    _controller.forward();
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _scaleAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _scaleAnimation.value)),
            child: child,
          ),
        );
      },
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: trailing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        title: const Text('Settings'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSettingTile(
                title: 'Sound Effects',
                subtitle: 'Play sounds when interacting with the game',
                trailing: Switch(
                  value: _settings.soundEnabled,
                  onChanged: (value) => _settings.setSoundEnabled(value),
                ),
              ),
              _buildSettingTile(
                title: 'Vibration',
                subtitle: 'Vibrate on interactions and mistakes',
                trailing: Switch(
                  value: _settings.vibrationEnabled,
                  onChanged: (value) => _settings.setVibrationEnabled(value),
                ),
              ),
              _buildSettingTile(
                title: 'Show Mistakes',
                subtitle: 'Highlight incorrect numbers',
                trailing: Switch(
                  value: _settings.showMistakes,
                  onChanged: (value) => _settings.setShowMistakes(value),
                ),
              ),
              _buildSettingTile(
                title: 'Auto-Check',
                subtitle: 'Automatically check answers when entering numbers',
                trailing: Switch(
                  value: _settings.autoCheckEnabled,
                  onChanged: (value) => _settings.setAutoCheckEnabled(value),
                ),
              ),
              _buildSettingTile(
                title: 'Brightness',
                subtitle: 'Adjust the game brightness',
                trailing: SizedBox(
                  width: 120,
                  child: Slider(
                    value: _settings.brightness,
                    min: 0.5,
                    max: 1.0,
                    divisions: 5,
                    onChanged: (value) => _settings.setBrightness(value),
                  ),
                ),
              ),
              _buildSettingTile(
                title: 'Theme Mode',
                subtitle: 'Choose light, dark, or system theme',
                trailing: DropdownButton<ThemeMode>(
                  value: _settings.themeMode,
                  onChanged: (ThemeMode? newMode) {
                    if (newMode != null) {
                      _settings.setThemeMode(newMode);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _settings.resetSettings(),
            child: const Text('Reset All'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}