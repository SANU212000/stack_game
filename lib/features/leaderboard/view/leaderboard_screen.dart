import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../viewmodel/leaderboard_view_model.dart';
import '../widgets/star_background.dart';
import '../widgets/leaderboard_header.dart';
import '../widgets/top_three_podium.dart';
import '../widgets/leaderboard_list_item.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarBackground(
        child: SafeArea(
          child: Consumer<LeaderboardViewModel>(
            builder: (context, model, child) {
              return Column(
                children: [
                  const LeaderboardHeader(),
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          TopThreePodium(users: model.topThree),
                          SizedBox(height: 10.h),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0a0a2a).withAlpha(200),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.r),
                                  topRight: Radius.circular(40.r),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(50),
                                    blurRadius: 10,
                                    offset: const Offset(0, -5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.r),
                                  topRight: Radius.circular(40.r),
                                ),
                                child: model.isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFFFD700),
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.only(
                                          top: 20.h,
                                          bottom: 20.h,
                                        ),
                                        itemCount:
                                            model.remainingEntries.length,
                                        itemBuilder: (context, index) {
                                          final entry =
                                              model.remainingEntries[index];
                                          return LeaderboardListItem(
                                            entry: entry,
                                          );
                                        },
                                      ),
                              ),
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
        ),
      ),
    );
  }
}
