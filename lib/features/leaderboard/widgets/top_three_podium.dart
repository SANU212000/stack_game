import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/leaderboard_entry.dart';

class TopThreePodium extends StatelessWidget {
  final List<LeaderboardEntry> users;

  const TopThreePodium({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return const SizedBox.shrink();

    // Mapping based on the order [Rank 2, Rank 1, Rank 3]
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (users.length > 0) _buildPodiumItem(users[0], isFirst: false),
          if (users.length > 1) _buildPodiumItem(users[1], isFirst: true),
          if (users.length > 2) _buildPodiumItem(users[2], isFirst: false),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(LeaderboardEntry user, {required bool isFirst}) {
    final size = isFirst ? 90.r : 70.r;
    final badgeColor = isFirst
        ? const Color(0xFFFFD700)
        : (user.rank == 2 ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isFirst)
          Icon(
            Icons.workspace_premium,
            color: const Color(0xFFFFD700),
            size: 30.r,
          ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15.h, left: 10.w, right: 10.w),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: badgeColor, width: 3.r),
                  boxShadow: [
                    BoxShadow(
                      color: badgeColor.withAlpha(100),
                      blurRadius: 15.r,
                      spreadRadius: 2.r,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Text(
                    user.name[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (size / 2.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10.h,
              child: Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.r),
                ),
                child: Text(
                  '${user.rank}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          user.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isFirst ? FontWeight.bold : FontWeight.w500,
            fontSize: isFirst ? 16.sp : 14.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '${user.score}',
          style: TextStyle(
            color: const Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
            fontSize: isFirst ? 18.sp : 15.sp,
          ),
        ),
      ],
    );
  }
}
