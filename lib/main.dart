import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'models/sudoku_game.dart';
import 'providers/game_provider.dart';
import 'theme/app_theme.dart';
import 'services/settings_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsManager = SettingsManager();
  await settingsManager.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => settingsManager),
      ChangeNotifierProvider(create: (_) => GameProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsManager>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'Sudoku Game',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}