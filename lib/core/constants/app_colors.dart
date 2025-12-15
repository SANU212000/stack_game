import 'package:flutter/material.dart';
import '../../features/stack_tower/model/settings_model.dart';

/// AppColorProvider - ChangeNotifier-based color theme provider
/// Supports dark and light themes with instant toggling
class AppColorProvider extends ChangeNotifier {
  bool _isDark = true; // Default to dark theme

  bool get isDark => _isDark;

  /// Toggle theme and notify listeners
  void toggleTheme(bool value) {
    _isDark = value;
    notifyListeners();
  }

  // Primary & Secondary Colors
  Color get primary =>
      _isDark ? const Color(0xFF2196F3) : const Color(0xFF1976D2);
  Color get secondary =>
      _isDark ? const Color(0xFF03DAC6) : const Color(0xFF018786);
  Color get accent =>
      _isDark ? const Color(0xFFFFB300) : const Color(0xFFFF8F00);

  // Background Colors
  Color get backgroundDark =>
      _isDark ? const Color(0xFF0a0a1a) : const Color(0xFFE0E0E0);
  Color get backgroundMedium =>
      _isDark ? const Color(0xFF1a1a2e) : const Color(0xFFF5F5F5);
  Color get backgroundLight =>
      _isDark ? const Color(0xFF16213e) : const Color(0xFFFFFFFF);
  Color get backgroundAlt =>
      _isDark ? const Color(0xFF0f3460) : const Color(0xFFEEEEEE);
  Color get surface =>
      _isDark ? const Color(0xFF1a1a2e) : const Color(0xFFFFFFFF);
  Color get scaffoldBackgroundColor =>
      _isDark ? const Color(0xFF0a0a1a) : const Color(0xFFFAFAFA);

  // State Colors
  Color get success =>
      _isDark ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32);
  Color get warning =>
      _isDark ? const Color(0xFFFF9800) : const Color(0xFFF57C00);
  Color get error =>
      _isDark ? const Color(0xFFF44336) : const Color(0xFFC62828);

  // Menu Button Colors
  Color get menuGreen =>
      _isDark ? const Color(0xFF4CAF50) : const Color(0xFF66BB6A);
  Color get menuGreenDark =>
      _isDark ? const Color(0xFF2E7D32) : const Color(0xFF388E3C);
  Color get menuBlue =>
      _isDark ? const Color(0xFF2196F3) : const Color(0xFF42A5F5);
  Color get menuBlueDark =>
      _isDark ? const Color(0xFF1565C0) : const Color(0xFF1976D2);
  Color get menuOrange =>
      _isDark ? const Color(0xFFFF9800) : const Color(0xFFFFA726);
  Color get menuOrangeDark =>
      _isDark ? const Color(0xFFF57C00) : const Color(0xFFFB8C00);
  Color get menuPurple =>
      _isDark ? const Color(0xFF9C27B0) : const Color(0xFFAB47BC);
  Color get menuPurpleDark =>
      _isDark ? const Color(0xFF7B1FA2) : const Color(0xFF8E24AA);

  // Block Colors
  List<Color> get blockColors => _isDark
      ? [
          const Color(0xFFE91E63),
          const Color(0xFF9C27B0),
          const Color(0xFF3F51B5),
          const Color(0xFF00BCD4),
          const Color(0xFF4CAF50),
          const Color(0xFFFFEB3B),
          const Color(0xFFFF9800),
        ]
      : [
          const Color(0xFFC2185B),
          const Color(0xFF7B1FA2),
          const Color(0xFF303F9F),
          const Color(0xFF0097A7),
          const Color(0xFF388E3C),
          const Color(0xFFFBC02D),
          const Color(0xFFF57C00),
        ];

  // Difficulty Colors
  Color get difficultyEasy =>
      _isDark ? const Color(0xFF4CAF50) : const Color(0xFF66BB6A);
  Color get difficultyMedium =>
      _isDark ? const Color(0xFFFF9800) : const Color(0xFFFFA726);
  Color get difficultyHard =>
      _isDark ? const Color(0xFFF44336) : const Color(0xFFE57373);

  // UI Text Colors
  Color get textPrimary => _isDark ? Colors.white : Colors.black87;
  Color get textSecondary =>
      _isDark ? Colors.white.withAlpha(200) : Colors.black54;
  Color get textMuted => _isDark ? Colors.white.withAlpha(120) : Colors.black38;

  // Overlay Colors
  Color get overlayLight =>
      _isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(10);
  Color get overlayDark =>
      _isDark ? Colors.black.withAlpha(180) : Colors.black.withAlpha(100);

  // Gradients
  LinearGradient get primaryGradient => LinearGradient(
        colors: _isDark
            ? [
                const Color(0xFF4FC3F7),
                const Color(0xFF2196F3),
                const Color(0xFF1976D2),
              ]
            : [
                const Color(0xFF2196F3),
                const Color(0xFF1976D2),
                const Color(0xFF1565C0),
              ],
      );

  LinearGradient get accentGradient => LinearGradient(
        colors: _isDark
            ? [
                const Color(0xFFFFD54F),
                const Color(0xFFFFB300),
                const Color(0xFFFF8F00),
              ]
            : [
                const Color(0xFFFFB300),
                const Color(0xFFFF8F00),
                const Color(0xFFF57C00),
              ],
      );

  LinearGradient get successGradient => LinearGradient(
        colors: _isDark
            ? [const Color(0xFF4CAF50), const Color(0xFF2E7D32)]
            : [const Color(0xFF66BB6A), const Color(0xFF388E3C)],
      );

  LinearGradient get backgroundGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [backgroundDark, backgroundMedium],
      );

  // Level background themes (Pair of colors for gradient)
  List<List<Color>> get levelThemes => _isDark
      ? [
          [const Color(0xFF1a1a2e), const Color(0xFF16213e)],
          [const Color(0xFF0f3460), const Color(0xFF1a1a40)],
          [const Color(0xFF2d132c), const Color(0xFF1a1a2e)],
          [const Color(0xFF1b262c), const Color(0xFF0f4c75)],
          [const Color(0xFF2c3e50), const Color(0xFF1a1a2e)],
        ]
      : [
          [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
          [const Color(0xFFE1F5FE), const Color(0xFFB3E5FC)],
          [const Color(0xFFFCE4EC), const Color(0xFFF8BBD0)],
          [const Color(0xFFE0F2F1), const Color(0xFFB2DFDB)],
          [const Color(0xFFECEFF1), const Color(0xFFCFD8DC)],
        ];

  // Animated background gradient sets
  List<List<Color>> get animatedBackgrounds => _isDark
      ? [
          [const Color(0xFF0a0a1a), const Color(0xFF1a1a3e)],
          [const Color(0xFF1a0a2e), const Color(0xFF0a1a2e)],
          [const Color(0xFF0a1a1a), const Color(0xFF1a0a1a)],
        ]
      : [
          [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
          [const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)],
          [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
        ];

  // Game UI Colors
  List<Color> get scoreBestGradient => _isDark
      ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
      : [const Color(0xFFFFB300), const Color(0xFFFF8F00)];
  List<Color> get scoreCurrentGradient => [
        primary,
        _isDark ? const Color(0xFF1565C0) : const Color(0xFF1976D2),
      ];

  List<Color> get gameOverGradient => _isDark
      ? [const Color(0xFF2d2d44), const Color(0xFF1a1a2e)]
      : [const Color(0xFFE0E0E0), const Color(0xFFF5F5F5)];
  List<Color> get newHighScoreGradient => const [
        Colors.amber,
        Colors.orange,
        Colors.amber,
      ];

  Color get statBest => Colors.amber;
  Color get statCombo => Colors.orange;
  Color get statPerfect => Colors.purple;

  // Level Badge Colors
  List<Color> get levelBadgeHigh => const [Colors.purple, Colors.deepPurple];
  List<Color> get levelBadgeMedium => const [Colors.red, Colors.deepOrange];
  List<Color> get levelBadgeLow => const [Colors.orange, Colors.amber];
  List<Color> get levelBadgeBeginner => const [Colors.green, Colors.teal];
  List<Color> get levelBadgeDefault => const [Colors.blueGrey, Colors.grey];

  // Combo Colors
  List<Color> get comboLegendary => const [
        Colors.purple,
        Colors.blue,
        Colors.cyan,
      ];
  List<Color> get comboGold => const [Colors.amber, Colors.orange];
  List<Color> get comboHot => const [Colors.orange, Colors.red];
  List<Color> get comboWarm => const [Colors.green, Colors.teal];
  List<Color> get comboNormal => const [Colors.blue, Colors.indigo];

  List<Color> get perfectTextGradient => const [
        Colors.amber,
        Colors.orange,
        Colors.red,
      ];

  /// Get color for specific difficulty
  Color getDifficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return difficultyEasy;
      case Difficulty.medium:
        return difficultyMedium;
      case Difficulty.hard:
        return difficultyHard;
    }
  }
}
