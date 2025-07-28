import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../services/settings_manager.dart';
import 'animated_sudoku_cell.dart';
import 'animated_grid_line.dart';

class SudokuBoard extends StatelessWidget {
  List<Widget> _buildGridLines(BuildContext context) {
    final List<Widget> lines = [];
    final size = MediaQuery.of(context).size.width * 0.9;
    final cellSize = size / 9;

    // Add thick vertical lines
    for (int i = 1; i < 3; i++) {
      lines.add(AnimatedGridLine(
        isHorizontal: false,
        length: size,
        isThick: true,
      ));
    }

    // Add thick horizontal lines
    for (int i = 1; i < 3; i++) {
      lines.add(AnimatedGridLine(
        isHorizontal: true,
        length: size,
        isThick: true,
      ));
    }

    return lines;
  }
  const SudokuBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildBoard(context, constraints.maxWidth),
              ),
              ..._buildGridLines(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBoard(BuildContext context, double size) {
    final cellSize = size / 9;
    final gameProvider = Provider.of<GameProvider>(context);
    final settings = Provider.of<SettingsManager>(context);
    final board = gameProvider.game.board;
    final isOriginal = gameProvider.game.isOriginal;
    final selectedRow = gameProvider.selectedRow;
    final selectedCol = gameProvider.selectedCol;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
      ),
      itemCount: 81,
      itemBuilder: (context, index) {
        final row = index ~/ 9;
        final col = index % 9;
        final value = board[row][col];
        final isSelected = selectedRow == row && selectedCol == col;
        final isInSameRow = selectedRow == row;
        final isInSameCol = selectedCol == col;
        final isInSameBox = selectedRow != null && selectedCol != null ? (row ~/ 3 == selectedRow! ~/ 3) && (col ~/ 3 == selectedCol! ~/ 3) : false;
        final isSameValue = value != 0 && selectedRow != null && selectedCol != null && 
                           value == board[selectedRow][selectedCol] && board[selectedRow][selectedCol] != 0;

        // Determine cell background color
        Color backgroundColor;
        if (isSelected) {
          backgroundColor = Colors.blue.shade200;
        } else if (isSameValue && settings.showMistakes) {
          backgroundColor = Colors.blue.shade100;
        } else if (isInSameRow || isInSameCol || isInSameBox) {
          backgroundColor = Colors.blue.shade50;
        } else {
          backgroundColor = Colors.white;
        }

        // Determine border
        Border border = Border(
          top: BorderSide(
            width: row % 3 == 0 ? 2.0 : 1.0,
            color: Colors.black,
          ),
          left: BorderSide(
            width: col % 3 == 0 ? 2.0 : 1.0,
            color: Colors.black,
          ),
          bottom: BorderSide(
            width: row % 3 == 2 || row == 8 ? 2.0 : 1.0,
            color: Colors.black,
          ),
          right: BorderSide(
            width: col % 3 == 2 || col == 8 ? 2.0 : 1.0,
            color: Colors.black,
          ),
        );

        return AnimatedSudokuCell(
          value: value,
          isOriginal: isOriginal[row][col],
          isSelected: isSelected,
          isHighlighted: isInSameRow || isInSameCol || isInSameBox,
          isSameValue: isSameValue,
          onTap: () => gameProvider.selectCell(row, col),
          size: cellSize * 0.5,
          border: border,
        );
      },
    );
  }
}