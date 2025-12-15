import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';

/// Enhanced widget displaying score and best score
class ScoreBoard extends StatelessWidget {
  final int score;
  final int bestScore;

  const ScoreBoard({super.key, required this.score, required this.bestScore});

  @override
  Widget build(BuildContext context) {
    final appColors = context.watch<AppColorProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Best Score
          _AnimatedScoreCard(
            label: 'BEST',
            value: bestScore,
            icon: Icons.emoji_events,
            gradientColors: appColors.scoreBestGradient,
          ),

          // Current Score
          _AnimatedScoreCard(
            label: 'SCORE',
            value: score,
            icon: Icons.diamond,
            gradientColors: appColors.scoreCurrentGradient,
            isHighlighted: score >= bestScore && score > 0,
          ),
        ],
      ),
    );
  }
}

class _AnimatedScoreCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final List<Color> gradientColors;
  final bool isHighlighted;

  const _AnimatedScoreCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradientColors,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.watch<AppColorProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withAlpha(80),
            blurRadius: isHighlighted ? 15 : 8,
            spreadRadius: isHighlighted ? 2 : 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: appColors.textSecondary, size: 24),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: appColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: value),
                duration: const Duration(milliseconds: 300),
                builder: (context, animatedValue, child) {
                  return Text(
                    '$animatedValue',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: appColors.textPrimary,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
