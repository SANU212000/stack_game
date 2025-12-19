import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slack_game/features/auth/viewmodel/auth_view_model.dart';
import 'package:slack_game/features/leaderboard/view/leaderboard_screen.dart';
import 'package:slack_game/features/auth/view/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/settings_model.dart';
import '../services/settings_service.dart';
import '../widgets/animated_stars_background.dart';
import '../provider/main_menu_animation_provider.dart';
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
  late MainMenuAnimationProvider _animationProvider;

  @override
  void initState() {
    super.initState();
    _animationProvider = MainMenuAnimationProvider(this);
  }

  @override
  void dispose() {
    _animationProvider.dispose();
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
            SizedBox(width: 12.w),
            Text('$feature coming soon!', style: TextStyle(fontSize: 14.sp)),
          ],
        ),
        backgroundColor: context.read<AppColorProvider>().primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColorProvider>();
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: _animationProvider)],
      child: Scaffold(
        body: AnimatedStarsBackground(
          child: SafeArea(
            child: _MenuContent(
              colors: colors,
              onNavigateToGame: _navigateToGame,
              onNavigateToSettings: _navigateToSettings,
              onShowComingSoon: _showComingSoon,
            ),
          ),
        ),
      ),
    );
  }
}

/// Menu content widget that uses animation provider
class _MenuContent extends StatelessWidget {
  final AppColorProvider colors;
  final VoidCallback onNavigateToGame;
  final VoidCallback onNavigateToSettings;
  final Function(String) onShowComingSoon;

  const _MenuContent({
    required this.colors,
    required this.onNavigateToGame,
    required this.onNavigateToSettings,
    required this.onShowComingSoon,
  });

  @override
  Widget build(BuildContext context) {
    final animationProvider = context.watch<MainMenuAnimationProvider>();
    return Column(
      children: [
        const Spacer(flex: 2),

        // Animated Title
        AnimatedBuilder(
          animation: animationProvider.titleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: animationProvider.titleAnimation.value,
              child: Opacity(
                opacity: animationProvider.titleAnimation.value.clamp(0.0, 1.0),
                child: Column(
                  children: [
                    // STACK text
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          colors.primaryGradient.createShader(bounds),
                      child: Text(
                        'STACK',
                        style: TextStyle(
                          fontSize: 72.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 12.w,
                          height: 1,
                        ),
                      ),
                    ),
                    // TOWER text
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          colors.accentGradient.createShader(bounds),
                      child: Text(
                        'TOWER',
                        style: TextStyle(
                          fontSize: 72.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 12.w,
                          height: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // PRO EDITION badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.withAlpha(100),
                            Colors.blue.withAlpha(100),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: Colors.white.withAlpha(30),
                          width: 1.w,
                        ),
                      ),
                      child: Text(
                        '✨ PRO EDITION ✨',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withAlpha(200),
                          letterSpacing: 2.w,
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
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            children: [
              // Single Player
              _buildAnimatedMenuItem(
                animation: animationProvider.menuAnimations[0],
                icon: Icons.play_arrow,
                label: 'SINGLE PLAYER',
                gradient: [colors.menuGreen, colors.menuGreenDark],
                onTap: onNavigateToGame,
              ),
              SizedBox(height: 16.h),

              // Multiplayer
              _buildAnimatedMenuItem(
                animation: animationProvider.menuAnimations[1],
                icon: Icons.people,
                label: 'MULTIPLAYER',
                gradient: [colors.menuBlue, colors.menuBlueDark],
                onTap: () => onShowComingSoon('Multiplayer'),
              ),
              SizedBox(height: 16.h),

              // Leaderboard
              _buildAnimatedMenuItem(
                animation: animationProvider.menuAnimations[2],
                icon: Icons.leaderboard,
                label: 'LEADERBOARD',
                gradient: [colors.menuOrange, colors.menuOrangeDark],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LeaderboardScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),

              // Settings
              _buildAnimatedMenuItem(
                animation: animationProvider.menuAnimations[3],
                icon: Icons.settings,
                label: 'SETTINGS',
                gradient: [colors.menuPurple, colors.menuPurpleDark],
                onTap: onNavigateToSettings,
              ),
              SizedBox(height: 16.h),

              // Logout
              _buildAnimatedMenuItem(
                animation: animationProvider
                    .menuAnimations[3], // Reusing last animation for now or could add more
                icon: Icons.logout,
                label: 'LOGOUT',
                gradient: [Colors.redAccent, Colors.red],
                onTap: () async {
                  await context.read<AuthViewModel>().signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ),

        const Spacer(flex: 2),

        // Difficulty indicator
        Consumer<SettingsService>(
          builder: (context, settings, child) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colors.overlayLight,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    settings.difficulty.icon,
                    color: colors.getDifficultyColor(settings.difficulty),
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Difficulty: ${settings.difficulty.displayName}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        SizedBox(height: 20.h),
      ],
    );
  }

  static Widget _buildAnimatedMenuItem({
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
          offset: Offset(0, 50.h * (1 - animation.value)),
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
          padding: EdgeInsets.symmetric(vertical: 18.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withAlpha(80),
                blurRadius: 15.r,
                offset: Offset(0, 5.h),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 26.sp),
              SizedBox(width: 12.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
