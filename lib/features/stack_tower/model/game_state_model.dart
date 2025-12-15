import '../../../core/constants/app_constants.dart';

/// Model representing the current game state
/// Enhanced with combo system, levels, and statistics
class GameStateModel {
  final int score;
  final int bestScore;
  final String status; // 'initial', 'playing', 'paused', 'game_over'
  final bool isMoving; // Whether current block is moving horizontally
  
  // Combo system
  final int combo; // Current combo count
  final int maxCombo; // Highest combo achieved this game
  final int perfectLandings; // Total perfect landings this game
  
  // Level/difficulty progression
  final int level; // Current level (increases every 10 blocks)
  final double speedMultiplier; // Speed increases with level

  const GameStateModel({
    this.score = 0,
    this.bestScore = 0,
    this.status = AppConstants.gameStateInitial,
    this.isMoving = false,
    this.combo = 0,
    this.maxCombo = 0,
    this.perfectLandings = 0,
    this.level = 1,
    this.speedMultiplier = 1.0,
  });

  /// Creates a copy with updated values
  GameStateModel copyWith({
    int? score,
    int? bestScore,
    String? status,
    bool? isMoving,
    int? combo,
    int? maxCombo,
    int? perfectLandings,
    int? level,
    double? speedMultiplier,
  }) {
    return GameStateModel(
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      status: status ?? this.status,
      isMoving: isMoving ?? this.isMoving,
      combo: combo ?? this.combo,
      maxCombo: maxCombo ?? this.maxCombo,
      perfectLandings: perfectLandings ?? this.perfectLandings,
      level: level ?? this.level,
      speedMultiplier: speedMultiplier ?? this.speedMultiplier,
    );
  }

  bool get isPlaying => status == AppConstants.gameStatePlaying;
  bool get isGameOver => status == AppConstants.gameStateGameOver;
  bool get isInitial => status == AppConstants.gameStateInitial;
  
  /// Calculate score bonus multiplier based on combo
  double get comboMultiplier => 1.0 + (combo * 0.1);
  
  /// Check if player is on a hot streak (3+ combo)
  bool get isOnStreak => combo >= 3;

  @override
  String toString() {
    return 'GameStateModel(score: $score, bestScore: $bestScore, status: $status, combo: $combo, level: $level)';
  }
}

