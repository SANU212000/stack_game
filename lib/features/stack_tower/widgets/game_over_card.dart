import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: appColors.gameOverGradient,
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: _isNewHighScore
                        ? appColors.statBest.withAlpha(150)
                        : appColors.textPrimary.withAlpha(30),
                    width: 2.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isNewHighScore
                          ? appColors.statBest.withAlpha(60)
                          : Colors.black.withAlpha(100),
                      blurRadius: 30.r,
                      spreadRadius: 5.r,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // New High Score celebration
                    if (_isNewHighScore) ...[
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: appColors.newHighScoreGradient,
                        ).createShader(bounds),
                        child: Text(
                          '🎉 NEW HIGH SCORE! 🎉',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: appColors.textPrimary,
                            letterSpacing: 1.w,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Game Over Title
                    Text(
                      'GAME OVER',
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: appColors.textPrimary,
                        letterSpacing: 4.w,
                        shadows: [
                          Shadow(
                            color: appColors.error.withAlpha(150),
                            blurRadius: 20.r,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Main score display
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            appColors.primary.withAlpha(50),
                            appColors.primary.withAlpha(20),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: appColors.primary.withAlpha(100),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'FINAL SCORE',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: appColors.textSecondary,
                              letterSpacing: 2.w,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TweenAnimationBuilder<int>(
                            tween: IntTween(begin: 0, end: widget.score),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Text(
                                '$value',
                                style: TextStyle(
                                  fontSize: 56.sp,
                                  fontWeight: FontWeight.bold,
                                  color: appColors.textPrimary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

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

                    SizedBox(height: 8.h),

                    // Level reached
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.textPrimary.withAlpha(10),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Level ${widget.level} Reached ${_getLevelEmoji()}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: appColors.textSecondary,
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Restart Button
                    GestureDetector(
                      onTap: widget.onRestart,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 48.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: appColors.scoreCurrentGradient,
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: appColors.primary.withAlpha(100),
                              blurRadius: 15.r,
                              offset: Offset(0, 5.h),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.replay,
                              color: appColors.textPrimary,
                              size: 24.sp,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'PLAY AGAIN',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: appColors.textPrimary,
                                letterSpacing: 2.w,
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
        Icon(icon, color: color, size: 24.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: appColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: appColors.textSecondary),
        ),
      ],
    );
  }
}
