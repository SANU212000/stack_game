/// Application-wide constants
/// Centralized location for all constant values used across the app
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // Game Configuration
  static const double initialBlockWidth = 200.0;
  static const double initialBlockHeight = 40.0;
  static const double minBlockWidth =
      20.0; // Game ends when block is smaller than this
  static const double blockSpeed = 2.0; // Pixels per frame
  static const double towerAreaWidth = 350.0;
  static const double towerAreaHeight = 700.0;
  static const double towerMiddleLine =
      300.0; // Middle of tower area - when reached, remove bottom blocks
  static const int scrollThreshold = 7; // Score threshold to start scrolling

  // Animation Durations (milliseconds)
  static const int dropAnimationDuration = 300;
  static const int trimAnimationDuration = 200;
  static const int gameOverAnimationDuration = 500;

  // Perfect Landing & Combo System
  static const double perfectLandingTolerance =
      5.0; // ±5 pixels for perfect landing
  static const int blocksPerLevel = 10; // Level up every 10 blocks
  static const double speedIncreasePerLevel =
      0.25; // 25% speed increase per level
  static const double maxSpeedMultiplier = 3.0; // Cap at 3x speed

  // Effect Settings
  static const int confettiCount = 25;
  static const int sparkCount = 10;
  static const double screenShakeIntensity = 8.0;
  static const int screenShakeDuration = 300;

  // Colors
  static const int primaryColorValue = 0xFF2196F3; // Blue
  static const int secondaryColorValue = 0xFF4CAF50; // Green
  static const int accentColorValue = 0xFFFF9800; // Orange
  static const int backgroundColorValue = 0xFFF5F5F5; // Light Gray
  static const int textColorValue = 0xFF212121; // Dark Gray
  static const int errorColorValue = 0xFFF44336; // Red

  // Storage Keys
  static const String highScoreKey = 'high_score';

  // Game States
  static const String gameStatePlaying = 'playing';
  static const String gameStatePaused = 'paused';
  static const String gameStateGameOver = 'game_over';
  static const String gameStateInitial = 'initial';
}
