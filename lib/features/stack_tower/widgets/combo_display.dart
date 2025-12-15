import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';

/// Animated combo display widget
/// Shows current combo count and "PERFECT!" text on perfect landings
class ComboDisplay extends StatelessWidget {
  final int combo;
  final bool showPerfect;
  final double perfectOpacity;
  final double perfectScale;

  const ComboDisplay({
    super.key,
    required this.combo,
    required this.showPerfect,
    required this.perfectOpacity,
    required this.perfectScale,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColorProvider>();
    return Stack(
      alignment: Alignment.center,
      children: [
        // Combo counter
        if (combo > 1)
          Positioned(
            top: 120,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 200),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _getComboColors(combo, colors),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: _getComboColors(
                            combo,
                            colors,
                          ).first.withAlpha(128),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Fire icon for hot streaks
                        if (combo >= 3)
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Text('🔥', style: TextStyle(fontSize: 24)),
                          ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${combo}x',
                              style:   TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'COMBO',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: colors.textSecondary,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        if (combo >= 5)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text('⭐', style: TextStyle(fontSize: 24)),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        // Perfect landing text
        if (showPerfect)
          Positioned(
            top: 200,
            child: Opacity(
              opacity: perfectOpacity,
              child: Transform.scale(
                scale: perfectScale,
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: colors.perfectTextGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child:   Text(
                    '✨ PERFECT! ✨',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Get gradient colors based on combo count
  List<Color> _getComboColors(int combo, AppColorProvider colors) {
    if (combo >= 10) return colors.comboLegendary;
    if (combo >= 7) return colors.comboGold;
    if (combo >= 5) return colors.comboHot;
    if (combo >= 3) return colors.comboWarm;
    return colors.comboNormal;
  }
}
