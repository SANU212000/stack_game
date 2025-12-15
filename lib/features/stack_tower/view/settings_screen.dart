import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/settings_model.dart';
import '../services/settings_service.dart';
import '../../../core/constants/app_colors.dart';

/// Settings screen with difficulty selection and theme toggle
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColorProvider>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          colors.primaryGradient.createShader(bounds),
                      child: const Text(
                        'SETTINGS',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Theme Section
              Consumer<AppColorProvider>(
                builder: (context, appColors, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.surface.withAlpha(50),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withAlpha(20)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            appColors.isDark
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: colors.accent,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'THEME',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textSecondary,
                                    letterSpacing: 2,
                                  ),
                                ),
                                Text(
                                  appColors.isDark ? 'Dark Mode' : 'Light Mode',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            activeThumbColor: colors.accent,
                            value: appColors.isDark,
                            onChanged: appColors.toggleTheme,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Difficulty Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withAlpha(15),
                        Colors.white.withAlpha(5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withAlpha(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.speed, color: colors.accent, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'DIFFICULTY',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colors.textSecondary,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Controls how fast the blocks move',
                        style: TextStyle(fontSize: 12, color: colors.textMuted),
                      ),
                      const SizedBox(height: 24),

                      // Difficulty options
                      Consumer<SettingsService>(
                        builder: (context, settings, child) {
                          return Column(
                            children: Difficulty.values.map((difficulty) {
                              final isSelected =
                                  settings.difficulty == difficulty;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _DifficultyOption(
                                  difficulty: difficulty,
                                  isSelected: isSelected,
                                  onTap: () =>
                                      settings.setDifficulty(difficulty),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Version info
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Stack Tower v1.0.0',
                  style: TextStyle(fontSize: 12, color: colors.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyOption extends StatelessWidget {
  final Difficulty difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyOption({
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColorProvider>();
    final difficultyColor = colors.getDifficultyColor(difficulty);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    difficultyColor.withAlpha(80),
                    difficultyColor.withAlpha(40),
                  ],
                )
              : null,
          color: isSelected ? null : colors.surface.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? difficultyColor.withAlpha(150)
                : colors.textSecondary.withAlpha(50),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: difficultyColor.withAlpha(50),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              difficulty.icon,
              color: isSelected
                  ? difficultyColor
                  : colors.textSecondary.withAlpha(150),
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    difficulty.displayName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? colors.textPrimary
                          : colors.textPrimary.withAlpha(180),
                    ),
                  ),
                  Text(
                    _getDescription(difficulty),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? colors.textPrimary.withAlpha(180)
                          : colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: difficultyColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: colors.textPrimary, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  String _getDescription(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Slower blocks, perfect for beginners';
      case Difficulty.medium:
        return 'Balanced speed for most players';
      case Difficulty.hard:
        return 'Fast blocks for experts only!';
    }
  }
}
