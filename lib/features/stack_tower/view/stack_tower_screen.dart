import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slack_game/features/stack_tower/provider/side_menu_provider.dart';
import '../services/storage_service.dart';
import '../services/effects_service.dart';
import '../services/settings_service.dart';
import '../../leaderboard/services/database_service.dart';
import '../../auth/services/auth_service.dart';
import '../../../core/constants/app_colors.dart';
import '../provider/stack_tower_provider.dart';
import '../provider/animation_provider.dart';
import '../widgets/score_board.dart';
import '../widgets/level_badge.dart';
import '../widgets/game_over_card.dart';
import '../widgets/tower_area.dart';
import '../widgets/combo_display.dart';
import '../widgets/side_menu_panel.dart';
import 'settings_screen.dart';

/// Main game screen with enhanced animations and effects
///
/// Features:
/// - Screen shake effects
/// - Particle system integration
/// - Combo display
/// - Animated background
/// - Polished UI transitions
/// - Side Menu with Split Screen
/// - MVVM Architecture with Provider
class StackTowerScreen extends StatefulWidget {
  const StackTowerScreen({super.key});

  @override
  State<StackTowerScreen> createState() => _StackTowerScreenState();
}

class _StackTowerScreenState extends State<StackTowerScreen>
    with TickerProviderStateMixin {
  late AnimationProvider _animationProvider;
  late StackTowerProvider _stackTowerProvider;

  @override
  void initState() {
    super.initState();

    // Create animation provider with TickerProvider
    _animationProvider = AnimationProvider(this);

    // Create stack tower provider with dependencies
    _stackTowerProvider = StackTowerProvider(
      storageService: context.read<StorageService>(),
      effectsService: context.read<EffectsService>(),
      settingsService: context.read<SettingsService>(),
      appColorProvider: context.read<AppColorProvider>(),
      animationProvider: _animationProvider,
      databaseService: context.read<DatabaseService>(),
      authService: context.read<AuthService>(),
    );

    // Initialize side menu provider with menu controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SideMenuProvider>().init(
          _animationProvider.menuController,
        );
      }
    });
  }

  @override
  void dispose() {
    _animationProvider.dispose();
    _stackTowerProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColorProvider>();
    final sideMenuProvider = context.watch<SideMenuProvider>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _animationProvider),
        ChangeNotifierProvider.value(value: _stackTowerProvider),
      ],
      child: Scaffold(
        body: _GameContent(
          colors: colors,
          sideMenuProvider: sideMenuProvider,
          animationProvider: _animationProvider,
        ),
      ),
    );
  }
}

/// Extracted game content widget to use providers
class _GameContent extends StatelessWidget {
  final AppColorProvider colors;
  final SideMenuProvider sideMenuProvider;
  final AnimationProvider animationProvider;

  const _GameContent({
    required this.colors,
    required this.sideMenuProvider,
    required this.animationProvider,
  });

  @override
  Widget build(BuildContext context) {
    final stackTowerProvider = context.watch<StackTowerProvider>();
    final gameState = stackTowerProvider.gameState;
    final placedBlocks = stackTowerProvider.placedBlocks;
    final currentBlock = stackTowerProvider.currentBlock;
    final effectsService = stackTowerProvider.effectsService;
    final isPaused = gameState.status == 'paused';

    return AnimatedBuilder(
      animation: animationProvider.bgAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  colors.backgroundMedium,
                  colors.backgroundLight,
                  animationProvider.bgAnimation.value,
                )!,
                Color.lerp(
                  colors.backgroundAlt,
                  colors.backgroundMedium,
                  animationProvider.bgAnimation.value,
                )!,
              ],
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Side Menu Panel (1/3 width when open)
                SizeTransition(
                  sizeFactor: animationProvider.menuAnimation,
                  axis: Axis.horizontal,
                  axisAlignment: -1.0,
                  child: SizedBox(
                    width: 0.33.sw,
                    child: SideMenuPanel(
                      viewModel: stackTowerProvider,
                      onRestart: () {
                        sideMenuProvider.closeMenu(stackTowerProvider);
                        stackTowerProvider.restartGame();
                      },
                      onSettings: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      onExit: () => Navigator.pop(context),
                    ),
                  ),
                ),

                // Game Area (Full width or 2/3 width)
                Expanded(
                  child: ListenableBuilder(
                    listenable: effectsService,
                    builder: (context, child) {
                      // Apply screen shake
                      return Transform.translate(
                        offset: Offset(
                          effectsService.shakeOffsetX,
                          effectsService.shakeOffsetY,
                        ),
                        child: Stack(
                          children: [
                            // Animated background particles (decorative)
                            if (!gameState.isInitial)
                              _buildBackgroundDecorations(context),

                            // Game Content
                            SafeArea(
                              child: Column(
                                children: [
                                  // Top Bar: Menu, Restart & Level
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 10.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Left side controls
                                        if (gameState.isPlaying ||
                                            gameState.isGameOver ||
                                            isPaused)
                                          Row(
                                            children: [
                                              // Menu Button
                                              if (!sideMenuProvider.isMenuOpen)
                                                _buildMenuButton(
                                                  context,
                                                  colors,
                                                  stackTowerProvider,
                                                ),

                                              // RestartButton(
                                              //   onPressed: () =>
                                              //       stackTowerProvider
                                              //           .restartGame(),
                                              //   isEnabled: !stackTowerProvider
                                              //       .animationModel
                                              //       .isAnimating,
                                              // ),
                                            ],
                                          ),

                                        if (gameState.isPlaying ||
                                            gameState.isGameOver ||
                                            isPaused)
                                          LevelBadge(level: gameState.level),
                                      ],
                                    ),
                                  ),

                                  // Main game area (Expanded)
                                  Expanded(
                                    child: Center(
                                      child: gameState.isInitial
                                          ? _buildStartScreen(context)
                                          : Stack(
                                              children: [
                                                TowerArea(
                                                  placedBlocks: placedBlocks,
                                                  currentBlock: currentBlock,
                                                  particles:
                                                      effectsService.particles,
                                                  level: gameState.level,
                                                  combo: gameState.combo,
                                                  onTap: () {
                                                    if (!isPaused) {
                                                      stackTowerProvider
                                                          .onTap();
                                                    }
                                                  },
                                                ),

                                                // Pause Overlay
                                                if (isPaused)
                                                  Center(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 24.w,
                                                            vertical: 12.h,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withAlpha(150),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20.r,
                                                            ),
                                                        border: Border.all(
                                                          color: colors.accent
                                                              .withAlpha(100),
                                                          width: 2.w,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.pause,
                                                            color:
                                                                colors.accent,
                                                            size: 32.sp,
                                                          ),
                                                          SizedBox(width: 12.w),
                                                          Text(
                                                            'PAUSED',
                                                            style: TextStyle(
                                                              fontSize: 24.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              letterSpacing:
                                                                  4.w,
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

                                  // Bottom: Score Board
                                  if (gameState.isPlaying ||
                                      gameState.isGameOver ||
                                      isPaused)
                                    ScoreBoard(
                                      score: gameState.score,
                                      bestScore: gameState.bestScore,
                                    ),
                                ],
                              ),
                            ),

                            // Combo display (Overlay)
                            if ((gameState.isPlaying || gameState.isGameOver) &&
                                !isPaused)
                              ComboDisplay(
                                combo: gameState.combo,
                                showPerfect: effectsService.showPerfectText,
                                perfectOpacity:
                                    effectsService.perfectTextOpacity,
                                perfectScale: effectsService.perfectTextScale,
                              ),

                            // Game over modal (Overlay)
                            if (gameState.isGameOver)
                              Container(
                                color: colors.overlayDark,
                                child: GameOverCard(
                                  score: gameState.score,
                                  bestScore: gameState.bestScore,
                                  maxCombo: gameState.maxCombo,
                                  perfectLandings: gameState.perfectLandings,
                                  level: gameState.level,
                                  onRestart: () =>
                                      stackTowerProvider.restartGame(),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildMenuButton(
    BuildContext context,
    AppColorProvider colors,
    StackTowerProvider stackTowerProvider,
  ) {
    final sideMenuProvider = context.read<SideMenuProvider>();
    return GestureDetector(
      onTap: () => sideMenuProvider.toggleMenu(stackTowerProvider),
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: colors.surface.withAlpha(200),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colors.textSecondary.withAlpha(50),
            width: 1.5.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 4.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Icon(
          sideMenuProvider.isMenuOpen ? Icons.close : Icons.menu_rounded,
          color: colors.textPrimary,
          size: 24.sp,
        ),
      ),
    );
  }

  static Widget _buildStartScreen(BuildContext context) {
    final colors = context.watch<AppColorProvider>();
    final animationProvider = context.watch<AnimationProvider>();
    final stackTowerProvider = context.read<StackTowerProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated title
        ShaderMask(
          shaderCallback: (bounds) =>
              colors.primaryGradient.createShader(bounds),
          child: Text(
            'STACK',
            style: TextStyle(
              fontSize: 64.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 8.w,
              height: 1,
            ),
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) =>
              colors.accentGradient.createShader(bounds),
          child: Text(
            'TOWER',
            style: TextStyle(
              fontSize: 64.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 8.w,
              height: 1,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: colors.overlayLight,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            '✨ PRO EDITION ✨',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: colors.textSecondary,
              letterSpacing: 2.w,
            ),
          ),
        ),
        SizedBox(height: 40.h),

        // Animated start button
        AnimatedBuilder(
          animation: animationProvider.pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: animationProvider.pulseAnimation.value,
              child: GestureDetector(
                onTap: () => stackTowerProvider.startGame(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 48.w,
                    vertical: 20.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: colors.successGradient,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: colors.success.withAlpha(100),
                        blurRadius: 20.r,
                        spreadRadius: 2.r,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white, size: 32.sp),
                      SizedBox(width: 12.w),
                      Text(
                        'START GAME',
                        style: TextStyle(
                          fontSize: 22.sp,
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
          },
        ),
      ],
    );
  }

  static Widget _buildBackgroundDecorations(BuildContext context) {
    final animationProvider = context.watch<AnimationProvider>();
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _BackgroundDecoPainter(
            animationValue: animationProvider.bgAnimation.value,
            colors: context.watch<AppColorProvider>(),
          ),
        ),
      ),
    );
  }
}

class _BackgroundDecoPainter extends CustomPainter {
  final double animationValue;
  final AppColorProvider colors;

  _BackgroundDecoPainter({required this.animationValue, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colors.overlayLight
      ..style = PaintingStyle.fill;

    // Floating circles
    for (int i = 0; i < 5; i++) {
      final x = (size.width / 6) * (i + 1);
      final y =
          (size.height / 2) +
          (100 * (animationValue * 2 - 1) * ((i % 2 == 0) ? 1 : -1));
      final radius = 20.0 + (i * 10);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_BackgroundDecoPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
