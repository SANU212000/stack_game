import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:slack_game/features/stack_tower/provider/side_menu_provider.dart';
import 'core/di/service_locator.dart';
import 'core/constants/app_colors.dart';
import 'features/stack_tower/view/main_menu_screen.dart';
import 'features/stack_tower/services/settings_service.dart';
import 'features/stack_tower/services/storage_service.dart';
import 'features/stack_tower/services/effects_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI to match dark theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0a0a1a), // Dark background
    ),
  );

  // Initialize dependency injection (includes SettingsService)
  await setupServiceLocator();

  // Get services from service locator
  final settingsService = sl<SettingsService>();
  final storageService = sl<StorageService>();
  final effectsService = sl<EffectsService>();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsService),
        ChangeNotifierProvider.value(value: sl<AppColorProvider>()),
        ChangeNotifierProvider.value(value: sl<SideMenuProvider>()),
        // Core services for StackTower (ViewModel will be created at screen level due to TickerProvider requirement)
        Provider.value(value: storageService),
        Provider.value(value: effectsService),
      ],
      child: StackTowerApp(settingsService: settingsService),
    ),
  );
}

/// Root application widget
class StackTowerApp extends StatelessWidget {
  final SettingsService settingsService;

  const StackTowerApp({super.key, required this.settingsService});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Consumer<AppColorProvider>(
          builder: (context, colors, _) {
            return MaterialApp(
              title: 'Stack Tower Pro',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: colors.isDark
                    ? Brightness.dark
                    : Brightness.light,
                colorScheme: colors.isDark
                    ? ColorScheme.dark(
                        primary: colors.primary,
                        secondary: colors.success,
                        surface: colors.backgroundMedium,
                      )
                    : ColorScheme.light(
                        primary: colors.primary,
                        secondary: colors.success,
                        surface: colors.backgroundMedium,
                      ),
                scaffoldBackgroundColor: colors.backgroundDark,
                useMaterial3: true,
                fontFamily: 'Roboto',
              ),
              home: const MainMenuScreen(),
            );
          },
        );
      },
    );
  }
}
