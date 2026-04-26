import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/games/logic/gamification_provider.dart';
import 'package:mindsense_app/features/games/logic/game_engine.dart';
import 'package:provider/provider.dart';

class PlayerStatsBar extends StatelessWidget {
  const PlayerStatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GamificationProvider>(
      builder: (context, gp, _) {
        final level = gp.level;
        final progress = gp.xpProgress;
        final xpNeeded = gp.xpForNext - GameEngine.xpForCurrentLevel(level);
        final xpDone = gp.xpSinceLevel;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff1E293B), Color(0xff0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColers.primaryColor.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Avatar + Level badge
                  Stack(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xff55EEDA), Color(0xff67B6F7)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '🧠',
                            style: TextStyle(fontSize: 24.sp),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xff55EEDA),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            'L$level',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),

                  // XP Bar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level $level',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '$xpDone / $xpNeeded XP',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: progress),
                            duration: const Duration(milliseconds: 800),
                            builder: (_, val, __) => LinearProgressIndicator(
                              value: val,
                              minHeight: 8.h,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.1),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xff55EEDA)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Streak & Points
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text('🔥',
                              style: TextStyle(fontSize: 16.sp)),
                          SizedBox(width: 3.w),
                          Text(
                            '${gp.streakDays}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text('⭐',
                              style: TextStyle(fontSize: 12.sp)),
                          SizedBox(width: 3.w),
                          Text(
                            '${gp.points}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
