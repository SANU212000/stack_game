import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:slack_game/core/di/service_locator.dart';
import 'package:slack_game/features/stack_tower/view/stack_tower_screen.dart';
import 'package:slack_game/features/stack_tower/viewmodel/stack_tower_viewmodel.dart';
import 'package:slack_game/features/stack_tower/services/storage_service.dart';

void main() {
  setUpAll(() async {
    // Setup service locator for tests
    sl.registerLazySingleton<StorageService>(() => StorageService());
    await sl<StorageService>().init();
  });

  testWidgets('Stack Tower app starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => sl<StackTowerViewModel>(),
        child: const MaterialApp(
          home: StackTowerScreen(),
        ),
      ),
    );

    // Verify that the game title appears
    expect(find.text('Stack Tower'), findsOneWidget);
    
    // Verify that start button appears
    expect(find.text('Start Game'), findsOneWidget);
  });
}
