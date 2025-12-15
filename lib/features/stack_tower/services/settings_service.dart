import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/settings_model.dart';

/// Service to manage game settings including difficulty
class SettingsService extends ChangeNotifier {
  static const String _difficultyKey = 'game_difficulty';

  Difficulty _difficulty = Difficulty.medium;
  bool _isLoaded = false;

  Difficulty get difficulty => _difficulty;
  bool get isLoaded => _isLoaded;

  /// Get the speed multiplier based on current difficulty
  double get speedMultiplier => _difficulty.speedMultiplier;

  /// Load settings from storage
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final difficultyIndex =
          prefs.getInt(_difficultyKey) ?? 1; // Default to medium
      _difficulty = Difficulty.values[difficultyIndex.clamp(0, 2)];
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      _difficulty = Difficulty.medium;
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// Save difficulty setting
  Future<void> setDifficulty(Difficulty difficulty) async {
    _difficulty = difficulty;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_difficultyKey, difficulty.index);
    } catch (e) {
      // Silently fail
    }
  }
}
