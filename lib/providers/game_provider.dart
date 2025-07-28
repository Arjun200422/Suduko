import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../models/sudoku_game.dart';
import '../services/settings_manager.dart';

class GameProvider extends ChangeNotifier {
  int? selectedNumber;

  void selectNumber(int number) {
    selectedNumber = number;
    notifyListeners();
  }
  final SudokuGame _game = SudokuGame();
  late final SettingsManager _settings;
  int? _selectedRow;
  int? _selectedCol;
  bool _isTimerRunning = false;
  String _elapsedTime = '00:00';
  Timer? _timer;

  GameProvider() {
    _settings = SettingsManager();
  }
  
  // Getters
  SudokuGame get game => _game;
  int? get selectedRow => _selectedRow;
  int? get selectedCol => _selectedCol;
  bool get isTimerRunning => _isTimerRunning;
  String get elapsedTime => _elapsedTime;
  
  // Cell selection
  void selectCell(int row, int col) {
    _selectedRow = row;
    _selectedCol = col;
    notifyListeners();
  }
  
  void clearSelection() {
    _selectedRow = null;
    _selectedCol = null;
    notifyListeners();
  }
  
  // Game actions
  void newGame(String difficulty) {
    _game.newGame(difficulty);
    clearSelection();
    startTimer();
    notifyListeners();
  }
  
  void enterNumber(int number) {
    if (_selectedRow != null && _selectedCol != null) {
      _game.makeMove(_selectedRow!, _selectedCol!, number);
      
      if (_settings.vibrationEnabled) {
        HapticFeedback.lightImpact();
      }

      if (_settings.autoCheckEnabled && !_game.isValid(_game.board, _selectedRow!, _selectedCol!, number)) {
        if (_settings.vibrationEnabled) {
          HapticFeedback.heavyImpact();
        }
      }
      
      if (_game.isComplete) {
        stopTimer();
        // We'll handle showing the completion dialog in the UI layer
      }
      
      notifyListeners();
    }
  }
  
  void clearCell() {
    if (_selectedRow != null && _selectedCol != null) {
      _game.clearCell(_selectedRow!, _selectedCol!);
      notifyListeners();
    }
  }
  
  void getHint() {
    List<int> hint = _game.getHint();
    if (hint.isNotEmpty) {
      int row = hint[0];
      int col = hint[1];
      int value = hint[2];
      
      _game.makeMove(row, col, value);
      _selectedRow = row;
      _selectedCol = col;
      
      if (_game.isComplete) {
        stopTimer();
      }
      
      notifyListeners();
    }
  }
  
  bool checkBoardValidity() {
    return _game.isBoardValid();
  }
  
  // Timer functions
  void startTimer() {
    _isTimerRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedTime = _game.getElapsedTime();
      notifyListeners();
    });
  }
  
  void stopTimer() {
    _isTimerRunning = false;
    _timer?.cancel();
    notifyListeners();
  }
  
  void pauseTimer() {
    _isTimerRunning = false;
    _timer?.cancel();
    notifyListeners();
  }
  
  void resumeTimer() {
    if (!_game.isComplete) {
      startTimer();
    }
  }
  
  // Statistics
  Future<Map<String, dynamic>> getStatistics() async {
    return await _game.getStatistics();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}