import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slack_game/features/stack_tower/view/stack_tower_screen.dart';

void main() {
  testWidgets('Stack Tower screen renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: StackTowerScreen(),
      ),
    );

    // Wait for async operations
    await tester.pumpAndSettle();

    // Verify that the game title appears
    expect(find.text('STACK'), findsOneWidget);
    expect(find.text('TOWER'), findsOneWidget);

    // Verify that start button appears
    expect(find.text('START GAME'), findsOneWidget);
  });
}
