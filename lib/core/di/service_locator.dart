import 'package:get_it/get_it.dart';
import 'package:slack_game/features/stack_tower/provider/side_menu_provider.dart';
import '../../features/stack_tower/services/storage_service.dart';
import '../../features/stack_tower/services/effects_service.dart';
import '../../features/stack_tower/services/settings_service.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/leaderboard/services/database_service.dart';
import '../constants/app_colors.dart';

/// Service Locator for Dependency Injection
/// Using GetIt for simple, efficient DI without heavy frameworks
///
/// Why GetIt over Riverpod/Provider?
/// - Lighter weight, no widget tree dependency
/// - Better for MVVM where ViewModels are pure Dart classes
/// - Easier testing with mock registration
/// - Can be swapped to Riverpod later if needed via adapter pattern
final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> setupServiceLocator() async {
  // Services
  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<EffectsService>(() => EffectsService());
  sl.registerLazySingleton<SettingsService>(() => SettingsService());
  sl.registerLazySingleton<AppColorProvider>(() => AppColorProvider());
  sl.registerLazySingleton<SideMenuProvider>(() => SideMenuProvider());
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<DatabaseService>(() => DatabaseService());

  // Initialize storage service
  await sl<StorageService>().init();

  // Initialize settings service
  await sl<SettingsService>().loadSettings();

  // StackTowerProvider is created at screen level due to TickerProvider requirement
}
