import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager extends ChangeNotifier {
  static final SettingsManager _instance = SettingsManager._internal();
  late SharedPreferences _prefs;
  bool _initialized = false;

  // Settings
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _showMistakes = true;
  bool _autoCheckEnabled = false;
  double _brightness = 1.0;
  ThemeMode _themeMode = ThemeMode.system;

  // Getters
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get showMistakes => _showMistakes;
  bool get autoCheckEnabled => _autoCheckEnabled;
  double get brightness => _brightness;
  ThemeMode get themeMode => _themeMode;

  factory SettingsManager() {
    return _instance;
  }

  SettingsManager._internal();

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();
    _initialized = true;
  }

  Future<void> _loadSettings() async {
    _soundEnabled = _prefs.getBool('sound_enabled') ?? true;
    _vibrationEnabled = _prefs.getBool('vibration_enabled') ?? true;
    _showMistakes = _prefs.getBool('show_mistakes') ?? true;
    _autoCheckEnabled = _prefs.getBool('auto_check') ?? false;
    _brightness = _prefs.getDouble('brightness') ?? 1.0;
    _themeMode = ThemeMode.values[_prefs.getInt('theme_mode') ?? 0];
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    await _prefs.setBool('sound_enabled', value);
    notifyListeners();
  }

  Future<void> setVibrationEnabled(bool value) async {
    _vibrationEnabled = value;
    await _prefs.setBool('vibration_enabled', value);
    notifyListeners();
  }

  Future<void> setShowMistakes(bool value) async {
    _showMistakes = value;
    await _prefs.setBool('show_mistakes', value);
    notifyListeners();
  }

  Future<void> setAutoCheckEnabled(bool value) async {
    _autoCheckEnabled = value;
    await _prefs.setBool('auto_check', value);
    notifyListeners();
  }

  Future<void> setBrightness(double value) async {
    _brightness = value;
    await _prefs.setDouble('brightness', value);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setInt('theme_mode', mode.index);
    notifyListeners();
  }

  Future<void> resetSettings() async {
    _soundEnabled = true;
    _vibrationEnabled = true;
    _showMistakes = true;
    _autoCheckEnabled = false;
    _brightness = 1.0;
    _themeMode = ThemeMode.system;

    await Future.wait<void>([
      _prefs.setBool('sound_enabled', true),
      _prefs.setBool('vibration_enabled', true),
      _prefs.setBool('show_mistakes', true),
      _prefs.setBool('auto_check', false),
      _prefs.setDouble('brightness', 1.0),
      _prefs.setInt('theme_mode', ThemeMode.system.index),
    ]);

    notifyListeners();
  }
}