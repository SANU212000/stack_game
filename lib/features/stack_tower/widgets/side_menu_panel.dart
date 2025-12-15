import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';

class SideMenuPanel extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onSettings;
  final VoidCallback onExit;

  const SideMenuPanel({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onSettings,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColorProvider>();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          right: BorderSide(
            color: colors.textSecondary.withAlpha(30),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.menu, color: colors.accent, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'MENU',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _MenuButton(
                    icon: Icons.play_arrow_rounded,
                    label: 'RESUME',
                    onTap: onResume,
                    color: colors.success,
                  ),
                  const SizedBox(height: 16),
                  _MenuButton(
                    icon: Icons.refresh_rounded,
                    label: 'RESTART',
                    onTap: onRestart,
                    color: colors.accent,
                  ),
                  const SizedBox(height: 16),
                  _MenuButton(
                    icon: Icons.settings_rounded,
                    label: 'SETTINGS',
                    onTap: onSettings,
                    color: colors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _MenuButton(
                    icon: Icons.close_rounded,
                    label: 'EXIT',
                    onTap: onExit,
                    color: colors.error,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // final colors = context.watch<AppColorProvider>(); // Unused

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: color.withAlpha(50)),
            borderRadius: BorderRadius.circular(12),
            color: color.withAlpha(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
