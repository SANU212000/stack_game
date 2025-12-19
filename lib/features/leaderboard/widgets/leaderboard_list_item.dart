import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/leaderboard_entry.dart';

class LeaderboardListItem extends StatelessWidget {
  final LeaderboardEntry entry;

  const LeaderboardListItem({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              '${entry.rank}',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.white24,
            child: Text(
              entry.name[0],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Text(
              entry.name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.monetization_on,
                color: const Color(0xFFFFD700),
                size: 18.r,
              ),
              SizedBox(width: 4.w),
              Text(
                '${entry.score}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(width: 10.w),
              _buildRankIndicator(entry.rankChange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankIndicator(RankChange change) {
    switch (change) {
      case RankChange.up:
        return Icon(Icons.arrow_drop_up, color: Colors.green, size: 24.r);
      case RankChange.down:
        return Icon(Icons.arrow_drop_down, color: Colors.red, size: 24.r);
      case RankChange.neutral:
        return Icon(Icons.minimize, color: Colors.grey, size: 20.r);
    }
  }
}
