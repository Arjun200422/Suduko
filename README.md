# Sudoku Game Flutter

A mobile Sudoku game application built with Flutter, featuring multiple difficulty levels and game history tracking.

## Features

- Three difficulty levels: Easy, Medium, and Hard
- Game history tracking and statistics
- Hint system for assistance
- Timer to track game duration
- Clean and intuitive user interface
- Board validation to check for conflicts

## Screenshots

*Screenshots will be added after the first build*

## Requirements

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

## Installation

1. Clone this repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## How to Play

1. Select a difficulty level (Easy, Medium, or Hard)
2. Tap on a cell to select it
3. Tap a number in the number pad to place it in the selected cell
4. Use the hint button if you need assistance
5. Use the clear button to remove a number from a cell
6. Use the check button to validate your current board

## Game Rules

- Fill the 9×9 grid with digits 1-9
- Each row must contain all digits 1-9 without repetition
- Each column must contain all digits 1-9 without repetition
- Each 3×3 box must contain all digits 1-9 without repetition

## Project Structure

- `lib/models/`: Contains the game logic and data models
- `lib/providers/`: Contains state management using Provider
- `lib/screens/`: Contains the UI screens
- `lib/widgets/`: Contains reusable UI components

## Difficulty Levels

- **Easy**: 35-40 cells removed (41-46 clues remain)
- **Medium**: 45-50 cells removed (31-36 clues remain)
- **Hard**: 55-60 cells removed (21-26 clues remain)

## Statistics Tracking

The app tracks and displays the following statistics:

- Total games played
- Completion rate
- Games played by difficulty
- Best completion times for each difficulty level

## License

This project is licensed under the MIT License - see the LICENSE file for details.