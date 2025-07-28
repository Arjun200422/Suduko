import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SudokuGame {
  List<List<int>> board = [];
  List<List<int>> solution = [];
  List<List<bool>> isOriginal = [];
  String difficulty = '';
  DateTime? startTime;
  DateTime? endTime;
  bool isComplete = false;
  
  SudokuGame() {
    _createEmptyBoard();
  }
  
  void _createEmptyBoard() {
    board = List.generate(9, (_) => List.filled(9, 0));
    solution = List.generate(9, (_) => List.filled(9, 0));
    isOriginal = List.generate(9, (_) => List.filled(9, false));
  }
  
  bool isValid(List<List<int>> board, int row, int col, int num) {
    // Check row
    for (int x = 0; x < 9; x++) {
      if (board[row][x] == num) {
        return false;
      }
    }
    
    // Check column
    for (int x = 0; x < 9; x++) {
      if (board[x][col] == num) {
        return false;
      }
    }
    
    // Check 3x3 box
    int startRow = 3 * (row ~/ 3);
    int startCol = 3 * (col ~/ 3);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i + startRow][j + startCol] == num) {
          return false;
        }
      }
    }
    
    return true;
  }
  
  bool solveBoard(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (isValid(board, row, col, num)) {
              board[row][col] = num;
              if (solveBoard(board)) {
                return true;
              }
              board[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }
  
  void generateSolution() {
    _createEmptyBoard();
    
    // Fill diagonal 3x3 boxes first
    Random random = Random();
    for (int i = 0; i < 9; i += 3) {
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          int num = random.nextInt(9) + 1;
          while (!isValid(solution, row + i, col + i, num)) {
            num = random.nextInt(9) + 1;
          }
          solution[row + i][col + i] = num;
        }
      }
    }
    
    // Solve the rest of the board
    solveBoard(solution);
    
    // Copy solution to board
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        board[i][j] = solution[i][j];
      }
    }
  }
  
  void removeNumbers(String difficulty) {
    this.difficulty = difficulty;
    
    // Define how many cells to remove based on difficulty
    int cellsToRemove;
    Random random = Random();
    
    if (difficulty == 'easy') {
      cellsToRemove = random.nextInt(6) + 35; // 35-40 cells removed (41-46 clues remain)
    } else if (difficulty == 'medium') {
      cellsToRemove = random.nextInt(6) + 45; // 45-50 cells removed (31-36 clues remain)
    } else { // hard
      cellsToRemove = random.nextInt(6) + 55; // 55-60 cells removed (21-26 clues remain)
    }
    
    // Create a list of all positions
    List<List<int>> positions = [];
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        positions.add([i, j]);
      }
    }
    
    // Shuffle the positions
    positions.shuffle(random);
    
    // Remove numbers
    for (int i = 0; i < cellsToRemove; i++) {
      if (i < positions.length) {
        int row = positions[i][0];
        int col = positions[i][1];
        board[row][col] = 0;
        isOriginal[row][col] = false;
      }
    }
    
    // Mark remaining numbers as original
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] != 0) {
          isOriginal[i][j] = true;
        }
      }
    }
  }
  
  void newGame(String difficulty) {
    generateSolution();
    removeNumbers(difficulty);
    startTime = DateTime.now();
    endTime = null;
    isComplete = false;
  }
  
  bool isBoardValid() {
    // Check if the current board state is valid (no conflicts)
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] != 0) {
          // Temporarily remove the number
          int temp = board[i][j];
          board[i][j] = 0;
          
          // Check if the number is valid in its position
          bool valid = isValid(board, i, j, temp);
          
          // Restore the number
          board[i][j] = temp;
          
          if (!valid) {
            return false;
          }
        }
      }
    }
    return true;
  }
  
  bool isBoardComplete() {
    // Check if the board is filled completely
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] == 0) {
          return false;
        }
      }
    }
    
    // Check if the solution is correct
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] != solution[i][j]) {
          return false;
        }
      }
    }
    
    return true;
  }
  
  void makeMove(int row, int col, int value) {
    if (!isOriginal[row][col]) {
      board[row][col] = value;
      
      // Check if the game is complete after this move
      if (isBoardComplete()) {
        endTime = DateTime.now();
        isComplete = true;
        saveGameToHistory();
      }
    }
  }
  
  void clearCell(int row, int col) {
    if (!isOriginal[row][col]) {
      board[row][col] = 0;
    }
  }
  
  List<int> getHint() {
    // Find a random empty cell and provide its solution
    List<List<int>> emptyCells = [];
    
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] == 0) {
          emptyCells.add([i, j]);
        }
      }
    }
    
    if (emptyCells.isEmpty) {
      return [];
    }
    
    Random random = Random();
    List<int> cell = emptyCells[random.nextInt(emptyCells.length)];
    int row = cell[0];
    int col = cell[1];
    int value = solution[row][col];
    
    return [row, col, value];
  }
  
  String getElapsedTime() {
    if (startTime == null) {
      return '00:00';
    }
    
    DateTime now = endTime ?? DateTime.now();
    Duration elapsed = now.difference(startTime!);
    
    int minutes = elapsed.inMinutes;
    int seconds = elapsed.inSeconds % 60;
    
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  // Game history methods
  Future<Map<String, dynamic>> loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? historyJson = prefs.getString('game_history');
    
    if (historyJson != null) {
      try {
        Map<String, dynamic> history = jsonDecode(historyJson);
        return history;
      } catch (e) {
        return {'games': []};
      }
    } else {
      return {'games': []};
    }
  }
  
  Future<void> saveHistory(Map<String, dynamic> history) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('game_history', jsonEncode(history));
  }
  
  Future<void> saveGameToHistory() async {
    if (startTime == null || endTime == null) {
      return;
    }
    
    Map<String, dynamic> history = await loadHistory();
    List<dynamic> games = history['games'] as List<dynamic>;
    
    // Calculate duration in seconds
    int duration = endTime!.difference(startTime!).inSeconds;
    
    // Format date
    String date = DateFormat('yyyy-MM-dd HH:mm').format(endTime!);
    
    // Add game to history
    games.add({
      'date': date,
      'difficulty': difficulty,
      'duration': duration,
      'completed': isComplete,
    });
    
    // Save updated history
    history['games'] = games;
    await saveHistory(history);
  }
  
  Future<Map<String, dynamic>> getStatistics() async {
    Map<String, dynamic> history = await loadHistory();
    List<dynamic> games = history['games'] as List<dynamic>;
    
    int totalGames = games.length;
    int completedGames = 0;
    int easyGames = 0;
    int mediumGames = 0;
    int hardGames = 0;
    int bestTimeEasy = -1;
    int bestTimeMedium = -1;
    int bestTimeHard = -1;
    
    for (var game in games) {
      if (game['completed'] == true) {
        completedGames++;
        
        String difficulty = game['difficulty'];
        int duration = game['duration'];
        
        if (difficulty == 'easy') {
          easyGames++;
          if (bestTimeEasy == -1 || duration < bestTimeEasy) {
            bestTimeEasy = duration;
          }
        } else if (difficulty == 'medium') {
          mediumGames++;
          if (bestTimeMedium == -1 || duration < bestTimeMedium) {
            bestTimeMedium = duration;
          }
        } else if (difficulty == 'hard') {
          hardGames++;
          if (bestTimeHard == -1 || duration < bestTimeHard) {
            bestTimeHard = duration;
          }
        }
      }
    }
    
    return {
      'totalGames': totalGames,
      'completedGames': completedGames,
      'easyGames': easyGames,
      'mediumGames': mediumGames,
      'hardGames': hardGames,
      'bestTimeEasy': bestTimeEasy,
      'bestTimeMedium': bestTimeMedium,
      'bestTimeHard': bestTimeHard,
    };
  }
}