import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slack_game/features/stack_tower/provider/side_menu_provider.dart';
import 'package:slack_game/features/stack_tower/provider/stack_tower_provider.dart';
import '../../../core/constants/app_colors.dart';

class SideMenuPanel extends StatelessWidget {
  final VoidCallback onRestart;
  final VoidCallback onSettings;
  final VoidCallback onExit;
  final StackTowerProvider viewModel;

  const SideMenuPanel({
    super.key,

    required this.onRestart,
    required this.onSettings,
    required this.onExit,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColorProvider>();
    final sideMenuProvider = context.read<SideMenuProvider>();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          right: BorderSide(
            color: colors.textSecondary.withAlpha(10),
            width: 1.w,
          ),
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10.r,
            offset: Offset(4.w, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => sideMenuProvider.toggleMenu(viewModel),
                    child: Icon(Icons.menu, color: colors.accent, size: 24.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                children: [
                  _MenuButton(
                    icon: Icons.play_arrow_rounded,
                    label: 'RESUME',
                    onTap: () => sideMenuProvider.closeMenu(viewModel),
                    color: colors.success,
                  ),
                  SizedBox(height: 16.h),
                  _MenuButton(
                    icon: Icons.refresh_rounded,
                    label: 'RESTART',
                    onTap: onRestart,
                    color: colors.accent,
                  ),
                  SizedBox(height: 16.h),
                  _MenuButton(
                    icon: Icons.settings_rounded,
                    label: 'SETTINGS',
                    onTap: onSettings,
                    color: colors.textSecondary,
                  ),
                  SizedBox(height: 16.h),
                  const Divider(),
                  SizedBox(height: 16.h),
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
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: color.withAlpha(50)),
            borderRadius: BorderRadius.circular(12.r),
            color: color.withAlpha(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 28.sp),
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 1.w,
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
