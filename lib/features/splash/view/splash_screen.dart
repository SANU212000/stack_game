import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slack_game/features/splash/widgets/space_components.dart';
import '../provider/splash_provider.dart';
import '../../stack_tower/view/main_menu_screen.dart';
import 'dart:math' as math;

class ArcadeSplashScreen extends StatefulWidget {
  const ArcadeSplashScreen({super.key});

  @override
  State<ArcadeSplashScreen> createState() => _ArcadeSplashScreenState();
}

class _ArcadeSplashScreenState extends State<ArcadeSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _rocketController;
  late AnimationController _loadingController;

  @override
  void initState() {
    super.initState();

    // Initialize Controllers safely in the State
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _rocketController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SplashProvider>();

      // Pass controllers to provider
      provider.setControllers(
        main: _mainController,
        rocket: _rocketController,
        loading: _loadingController,
      );

      provider.startAnimation(() {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const MainMenuScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    // Dispose controllers that we created
    _mainController.dispose();
    _rocketController.dispose();
    _loadingController.dispose();

    // Notify provider to clear references
    if (mounted) {
      // Just a best effort clear, not strictly creating issues if skipped
      // as we only hold references in provider
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a0a2e),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Deep Space Background (Gradient) - Always visible
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.3, -0.3),
                radius: 1.5,
                colors: [
                  Color(0xFF311B92), // Deep Purple
                  Color(0xFF000000), // Black
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),

          // 2. Stars - Always visible
          ...List.generate(30, (index) {
            final random = math.Random(index);
            return Positioned(
              left: random.nextDouble() * 1.sw,
              top: random.nextDouble() * 1.sh,
              child: Opacity(
                opacity: 0.3 + random.nextDouble() * 0.7,
                child: Container(
                  width: random.nextDouble() * 3 + 1,
                  height: random.nextDouble() * 3 + 1,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),

          // 3. Floating Rocks - Always visible
          Positioned(
            top: 0.15.sh,
            left: 0.1.sw,
            child: _buildRock(size: 40, color: Colors.purple.withAlpha(0x33)),
          ),
          Positioned(
            bottom: 0.3.sh,
            right: 0.15.sw,
            child: _buildRock(
              size: 60,
              color: Colors.deepPurple.withAlpha(0x33),
            ),
          ),
          Positioned(
            top: 0.6.sh,
            left: -20,
            child: _buildRock(size: 80, color: Colors.indigo.withAlpha(0x33)),
          ),

          // Animated elements - Only show after provider is ready
          Consumer<SplashProvider>(
            builder: (context, provider, child) {
              if (!provider.isInitialized) {
                // Show static placeholder while initializing
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 250.w,
                        height: 250.w,
                        child: CustomPaint(painter: PlanetPainter()),
                      ),
                    ],
                  ),
                );
              }

              return Stack(
                fit: StackFit.expand,
                children: [
                  // 4. Central Composition (Planet + Text)
                  Center(
                    child: ScaleTransition(
                      scale: provider.planetScaleAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 250.w,
                            height: 250.w,
                            child: CustomPaint(
                              painter: PlanetPainter(),
                              child: Center(
                                child: FadeTransition(
                                  opacity: provider.textOpacityAnimation,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "STACK",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 48.sp,
                                          color: const Color(0xFFFFCC80),
                                          letterSpacing: 2,
                                          shadows: [
                                            Shadow(
                                              color: Colors.orange.withAlpha(
                                                0x33,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(2, 2),
                                            ),
                                            const Shadow(
                                              color: Colors.black54,
                                              blurRadius: 2,
                                              offset: Offset(4, 4),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "TOWER",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 56.sp,
                                          color: const Color(0xFF40C4FF),
                                          letterSpacing: 2,
                                          height: 0.8,
                                          shadows: [
                                            Shadow(
                                              color: Colors.blue.withAlpha(
                                                0x33,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(2, 2),
                                            ),
                                            const Shadow(
                                              color: Colors.black54,
                                              blurRadius: 2,
                                              offset: Offset(4, 4),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 5. Rocket (Animated position)
                  Positioned(
                    top: 0.15.sh,
                    right: 0.2.sw,
                    child: SlideTransition(
                      position: provider.rocketHoverAnimation,
                      child: SizedBox(
                        width: 80.w,
                        height: 120.h,
                        child: Stack(
                          children: [
                            // Flame
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 40.h,
                              child: AnimatedBuilder(
                                animation: provider.rocketFlameAnimation,
                                builder: (context, child) {
                                  return CustomPaint(
                                    painter: FlamePainter(
                                      flicker:
                                          provider.rocketFlameAnimation.value,
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Ship
                            Positioned.fill(
                              bottom: 20.h,
                              child: Transform.rotate(
                                angle: math.pi / 8,
                                child: CustomPaint(painter: RocketPainter()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 6. Loading Bar (Bottom)
                  Positioned(
                    bottom: 80.h,
                    left: 0.2.sw,
                    right: 0.2.sw,
                    child: FadeTransition(
                      opacity: provider.textOpacityAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                            child: AnimatedBuilder(
                              animation: provider.loadingProgressAnimation,
                              builder: (context, child) {
                                return FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor:
                                      provider.loadingProgressAnimation.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFB300),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withAlpha(0x33),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "LOADING...",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRock({required double size, required Color color}) {
    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8), // Geometric
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: const Offset(4, 4),
            ),
          ],
        ),
      ),
    );
  }
}
