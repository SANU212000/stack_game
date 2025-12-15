import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';

class LevelBadge extends StatelessWidget {
  final int level;

  const LevelBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final appColors = context.watch<AppColorProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getLevelColors(appColors),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: appColors.textPrimary.withAlpha(60),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getLevelColors(appColors).first.withAlpha(60),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_getLevelEmoji(), style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'LVL',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: appColors.textSecondary,
                  letterSpacing: 1,
                ),
              ),
              Text(
                '$level',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: appColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Color> _getLevelColors(AppColorProvider appColors) {
    if (level >= 10) return appColors.levelBadgeHigh;
    if (level >= 7) return appColors.levelBadgeMedium;
    if (level >= 5) return appColors.levelBadgeLow;
    if (level >= 3) return appColors.levelBadgeBeginner;
    return appColors.levelBadgeDefault;
  }

  String _getLevelEmoji() {
    if (level >= 10) return '👑';
    if (level >= 7) return '🔥';
    if (level >= 5) return '⭐';
    if (level >= 3) return '🎯';
    return '🎮';
  }
}
