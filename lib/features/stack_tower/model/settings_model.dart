import 'package:flutter/material.dart';

/// Game difficulty levels
enum Difficulty { easy, medium, hard }

/// Extension to get display names and speed multipliers for difficulty
extension DifficultyExtension on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
    }
  }

  /// Speed multiplier for each difficulty
  double get speedMultiplier {
    switch (this) {
      case Difficulty.easy:
        return 0.7; // 30% slower
      case Difficulty.medium:
        return 1.0; // Normal speed
      case Difficulty.hard:
        return 1.5; // 50% faster
    }
  }

  IconData get icon {
    switch (this) {
      case Difficulty.easy:
        return Icons.sentiment_satisfied;
      case Difficulty.medium:
        return Icons.sentiment_neutral;
      case Difficulty.hard:
        return Icons.whatshot;
    }
  }
}
