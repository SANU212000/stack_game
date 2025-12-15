import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';

/// Restart button widget
class RestartButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEnabled;

  const RestartButton({
    super.key,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColorProvider>();
    return IconButton(
      onPressed: isEnabled ? onPressed : null,
      icon: const Icon(Icons.refresh),
      iconSize: 28,
      color: isEnabled ? colors.primary : colors.textMuted,
      style: IconButton.styleFrom(
        backgroundColor: colors.textPrimary.withAlpha(204),
        padding: const EdgeInsets.all(12),
      ),
      tooltip: 'Restart Game',
    );
  }
}
