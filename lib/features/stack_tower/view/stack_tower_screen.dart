import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/constants/app_colors.dart';
import '../viewmodel/stack_tower_viewmodel.dart';
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
class StackTowerScreen extends StatefulWidget {
  const StackTowerScreen({super.key});

  @override
  State<StackTowerScreen> createState() => _StackTowerScreenState();
}

class _StackTowerScreenState extends State<StackTowerScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgAnimationController;
  late Animation<double> _bgAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Menu State
  bool _isMenuOpen = false;
  late AnimationController _menuController;
  late Animation<double> _menuAnimation;

  @override
  void initState() {
    super.initState();

    // Background gradient animation
    _bgAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _bgAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bgAnimationController, curve: Curves.easeInOut),
    );

    // Pulse animation for start button
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Menu Animation
    _menuController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _menuAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    _pulseController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _toggleMenu(StackTowerViewModel viewModel) {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });

    if (_isMenuOpen) {
      _menuController.forward();
      viewModel.pauseGame();
    } else {
      _menuController.reverse();
      viewModel.resumeGame();
    }
  }

  void _closeMenu(StackTowerViewModel viewModel) {
    if (!_isMenuOpen) return;

    setState(() {
      _isMenuOpen = false;
    });
    _menuController.reverse();
    viewModel.resumeGame();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColorProvider>();
    return ChangeNotifierProvider(
      create: (_) => sl<StackTowerViewModel>(),
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _bgAnimation,
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
                      _bgAnimation.value,
                    )!,
                    Color.lerp(
                      colors.backgroundAlt,
                      colors.backgroundMedium,
                      _bgAnimation.value,
                    )!,
                  ],
                ),
              ),
              child: SafeArea(
                child: Consumer<StackTowerViewModel>(
                  builder: (context, viewModel, child) {
                    final gameState = viewModel.gameState;
                    final placedBlocks = viewModel.placedBlocks;
                    final currentBlock = viewModel.currentBlock;
                    final effectsService = viewModel.effectsService;
                    final isPaused = gameState.status == 'paused';

                    return Row(
                      children: [
                        // Side Menu Panel (1/3 width when open)
                        SizeTransition(
                          sizeFactor: _menuAnimation,
                          axis: Axis.horizontal,
                          axisAlignment: -1.0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: SideMenuPanel(
                              onResume: () => _closeMenu(viewModel),
                              onRestart: () {
                                _closeMenu(viewModel);
                                viewModel.restartGame();
                              },
                              onSettings: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen(),
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
                                      _buildBackgroundDecorations(),

                                    // Game Content
                                    SafeArea(
                                      child: Column(
                                        children: [
                                          // Top Bar: Menu, Restart & Level
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Left side controls
                                                if (gameState.isPlaying ||
                                                    gameState.isGameOver ||
                                                    isPaused)
                                                  Row(
                                                    children: [
                                                      // Menu Button
                                                      _buildMenuButton(
                                                        colors,
                                                        viewModel,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      // RestartButton(
                                                      //   onPressed: () =>
                                                      //       viewModel
                                                      //           .restartGame(),
                                                      //   isEnabled: !viewModel
                                                      //       .animationModel
                                                      //       .isAnimating,
                                                      // ),
                                                    ],
                                                  ),

                                                if (gameState.isPlaying ||
                                                    gameState.isGameOver ||
                                                    isPaused)
                                                  LevelBadge(
                                                    level: gameState.level,
                                                  ),
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
                                                          placedBlocks:
                                                              placedBlocks,
                                                          currentBlock:
                                                              currentBlock,
                                                          particles:
                                                              effectsService
                                                                  .particles,
                                                          level:
                                                              gameState.level,
                                                          combo:
                                                              gameState.combo,
                                                          onTap: () {
                                                            if (!isPaused) {
                                                              viewModel.onTap();
                                                            }
                                                          },
                                                        ),

                                                        // Pause Overlay
                                                        if (isPaused)
                                                          Center(
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        24,
                                                                    vertical:
                                                                        12,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withAlpha(
                                                                      150,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      20,
                                                                    ),
                                                                border: Border.all(
                                                                  color: colors
                                                                      .accent
                                                                      .withAlpha(
                                                                        100,
                                                                      ),
                                                                  width: 2,
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    Icons.pause,
                                                                    color: colors
                                                                        .accent,
                                                                    size: 32,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 12,
                                                                  ),
                                                                  Text(
                                                                    'PAUSED',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                      letterSpacing:
                                                                          4,
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
                                    if ((gameState.isPlaying ||
                                            gameState.isGameOver) &&
                                        !isPaused)
                                      ComboDisplay(
                                        combo: gameState.combo,
                                        showPerfect:
                                            effectsService.showPerfectText,
                                        perfectOpacity:
                                            effectsService.perfectTextOpacity,
                                        perfectScale:
                                            effectsService.perfectTextScale,
                                      ),

                                    // Game over modal (Overlay)
                                    if (gameState.isGameOver)
                                      Container(
                                        color: colors.overlayDark,
                                        child: GameOverCard(
                                          score: gameState.score,
                                          bestScore: gameState.bestScore,
                                          maxCombo: gameState.maxCombo,
                                          perfectLandings:
                                              gameState.perfectLandings,
                                          level: gameState.level,
                                          onRestart: () =>
                                              viewModel.restartGame(),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    AppColorProvider colors,
    StackTowerViewModel viewModel,
  ) {
    return GestureDetector(
      onTap: () => _toggleMenu(viewModel),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: colors.surface.withAlpha(200),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colors.textSecondary.withAlpha(50),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _isMenuOpen ? Icons.close : Icons.menu_rounded,
          color: colors.textPrimary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildStartScreen(BuildContext context) {
    final colors = context.watch<AppColorProvider>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated title
        ShaderMask(
          shaderCallback: (bounds) =>
              colors.primaryGradient.createShader(bounds),
          child: const Text(
            'STACK',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 8,
              height: 1,
            ),
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) =>
              colors.accentGradient.createShader(bounds),
          child: const Text(
            'TOWER',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 8,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: context.watch<AppColorProvider>().overlayLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '✨ PRO EDITION ✨',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: context.watch<AppColorProvider>().textSecondary,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 40),

        // Animated start button
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: GestureDetector(
                onTap: () => context.read<StackTowerViewModel>().startGame(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: context.watch<AppColorProvider>().successGradient,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: context
                            .watch<AppColorProvider>()
                            .success
                            .withAlpha(100),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white, size: 32),
                      SizedBox(width: 12),
                      Text(
                        'START GAME',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
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

  Widget _buildBackgroundDecorations() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _BackgroundDecoPainter(
            animationValue: _bgAnimation.value,
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
