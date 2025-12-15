import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

/// Service for persistent storage operations
/// Handles high score persistence using SharedPreferences
class StorageService {
  SharedPreferences? _prefs;

  /// Initialize the storage service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get the stored high score
  Future<int> getHighScore() async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!.getInt(AppConstants.highScoreKey) ?? 0;
  }

  /// Save a new high score
  Future<bool> saveHighScore(int score) async {
    if (_prefs == null) {
      await init();
    }
    return await _prefs!.setInt(AppConstants.highScoreKey, score);
  }

  /// Clear all stored data (useful for testing)
  Future<bool> clearAll() async {
    if (_prefs == null) {
      await init();
    }
    return await _prefs!.clear();
  }
}

