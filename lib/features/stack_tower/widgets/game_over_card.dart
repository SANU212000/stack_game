import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';

/// Enhanced modal card displayed when game ends
/// Features statistics, celebration effects, and polished UI
class GameOverCard extends StatefulWidget {
  final int score;
  final int bestScore;
  final int maxCombo;
  final int perfectLandings;
  final int level;
  final VoidCallback onRestart;

  const GameOverCard({
    super.key,
    required this.score,
    required this.bestScore,
    this.maxCombo = 0,
    this.perfectLandings = 0,
    this.level = 1,
    required this.onRestart,
  });

  @override
  State<GameOverCard> createState() => _GameOverCardState();
}

class _GameOverCardState extends State<GameOverCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isNewHighScore =>
      widget.score >= widget.bestScore && widget.score > 1;

  @override
  Widget build(BuildContext context) {
    final appColors = context.watch<AppColorProvider>();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient:   LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: appColors.gameOverGradient,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isNewHighScore
                        ? appColors.statBest.withAlpha(150)
                        : appColors.textPrimary.withAlpha(30),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isNewHighScore
                          ? appColors.statBest.withAlpha(60)
                          : Colors.black.withAlpha(100),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // New High Score celebration
                    if (_isNewHighScore) ...[
                      ShaderMask(
                        shaderCallback: (bounds) =>   LinearGradient(
                          colors: appColors.newHighScoreGradient,
                        ).createShader(bounds),
                        child:  Text(
                          '🎉 NEW HIGH SCORE! 🎉',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: appColors.textPrimary,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Game Over Title
                    Text(
                      'GAME OVER',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: appColors.textPrimary,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(
                            color: appColors.error.withAlpha(150),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Main score display
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            appColors.primary.withAlpha(50),
                            appColors.primary.withAlpha(20),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: appColors.primary.withAlpha(100),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'FINAL SCORE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: appColors.textSecondary,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TweenAnimationBuilder<int>(
                            tween: IntTween(begin: 0, end: widget.score),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Text(
                                '$value',
                                style: TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold,
                                  color: appColors.textPrimary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(
                          icon: Icons.emoji_events,
                          label: 'Best',
                          value: '${widget.bestScore}',
                          color: appColors.statBest,
                        ),
                        _StatItem(
                          icon: Icons.local_fire_department,
                          label: 'Max Combo',
                          value: '${widget.maxCombo}x',
                          color: appColors.statCombo,
                        ),
                        _StatItem(
                          icon: Icons.star,
                          label: 'Perfect',
                          value: '${widget.perfectLandings}',
                          color: appColors.statPerfect,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Level reached
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.textPrimary.withAlpha(10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Level ${widget.level} Reached ${_getLevelEmoji()}',
                        style: TextStyle(
                          fontSize: 14,
                          color: appColors.textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Restart Button
                    GestureDetector(
                      onTap: widget.onRestart,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient:    LinearGradient(
                            colors: appColors.scoreCurrentGradient,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: appColors.primary.withAlpha(100),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child:   Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.replay,
                              color: appColors.textPrimary,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'PLAY AGAIN',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: appColors.textPrimary,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getLevelEmoji() {
    if (widget.level >= 10) return '👑';
    if (widget.level >= 7) return '🔥';
    if (widget.level >= 5) return '⭐';
    if (widget.level >= 3) return '🎯';
    return '🎮';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.watch<AppColorProvider>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style:   TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: appColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: appColors.textSecondary),
        ),
      ],
    );
  }
}
