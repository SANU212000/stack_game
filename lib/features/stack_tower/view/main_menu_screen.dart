import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/settings_model.dart';
import '../services/settings_service.dart';
import '../widgets/animated_stars_background.dart';
import '../../../core/constants/app_colors.dart';
import 'stack_tower_screen.dart';
import 'settings_screen.dart';

/// Main menu screen with animated background and menu options
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _menuController;
  late Animation<double> _titleAnimation;
  late List<Animation<double>> _menuAnimations;

  @override
  void initState() {
    super.initState();

    // Title animation
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Menu items staggered animation
    _menuController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _menuAnimations = List.generate(4, (index) {
      final startInterval = 0.2 + (index * 0.15);
      final endInterval = (startInterval + 0.3).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _menuController,
          curve: Interval(
            startInterval,
            endInterval,
            curve: Curves.easeOutBack,
          ),
        ),
      );
    });

    // Start animations
    _titleController.forward();
    _menuController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _navigateToGame() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const StackTowerScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Text('$feature coming soon!'),
          ],
        ),
        backgroundColor: context.read<AppColorProvider>().primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColorProvider>();
    return Scaffold(
      body: AnimatedStarsBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Animated Title
              AnimatedBuilder(
                animation: _titleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _titleAnimation.value,
                    child: Opacity(
                      opacity: _titleAnimation.value.clamp(0.0, 1.0),
                      child: Column(
                        children: [
                          // STACK text
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                colors.primaryGradient.createShader(bounds),
                            child: const Text(
                              'STACK',
                              style: TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 12,
                                height: 1,
                              ),
                            ),
                          ),
                          // TOWER text
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                colors.accentGradient.createShader(bounds),
                            child: const Text(
                              'TOWER',
                              style: TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 12,
                                height: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // PRO EDITION badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.withAlpha(100),
                                  Colors.blue.withAlpha(100),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withAlpha(30),
                              ),
                            ),
                            child: Text(
                              '✨ PRO EDITION ✨',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withAlpha(200),
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const Spacer(flex: 2),

              // Menu Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    // Single Player
                    _buildAnimatedMenuItem(
                      animation: _menuAnimations[0],
                      icon: Icons.play_arrow,
                      label: 'SINGLE PLAYER',
                      gradient: [colors.menuGreen, colors.menuGreenDark],
                      onTap: _navigateToGame,
                    ),
                    const SizedBox(height: 16),

                    // Multiplayer
                    _buildAnimatedMenuItem(
                      animation: _menuAnimations[1],
                      icon: Icons.people,
                      label: 'MULTIPLAYER',
                      gradient: [colors.menuBlue, colors.menuBlueDark],
                      onTap: () => _showComingSoon('Multiplayer'),
                    ),
                    const SizedBox(height: 16),

                    // Leaderboard
                    _buildAnimatedMenuItem(
                      animation: _menuAnimations[2],
                      icon: Icons.leaderboard,
                      label: 'LEADERBOARD',
                      gradient: [colors.menuOrange, colors.menuOrangeDark],
                      onTap: () => _showComingSoon('Leaderboard'),
                    ),
                    const SizedBox(height: 16),

                    // Settings
                    _buildAnimatedMenuItem(
                      animation: _menuAnimations[3],
                      icon: Icons.settings,
                      label: 'SETTINGS',
                      gradient: [colors.menuPurple, colors.menuPurpleDark],
                      onTap: _navigateToSettings,
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Difficulty indicator
              Consumer<SettingsService>(
                builder: (context, settings, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colors.overlayLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          settings.difficulty.icon,
                          color: colors.getDifficultyColor(settings.difficulty),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Difficulty: ${settings.difficulty.displayName}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedMenuItem({
    required Animation<double> animation,
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withAlpha(80),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 26),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.watch<AppColorProvider>().textPrimary,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
