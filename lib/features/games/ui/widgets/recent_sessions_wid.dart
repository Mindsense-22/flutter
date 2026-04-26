import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/games/logic/gamification_provider.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';
import 'package:provider/provider.dart';

class RecentSessionsWid extends StatelessWidget {
  const RecentSessionsWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GamificationProvider>(
      builder: (context, gp, _) {
        final sessions = gp.recentSessions;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                'Recent Sessions',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            if (sessions.isEmpty)
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: const Color(0xff1E293B),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text('🎮', style: TextStyle(fontSize: 32.sp)),
                      SizedBox(height: 8.h),
                      Text(
                        'No sessions yet — play your first game!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: sessions.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final s = sessions[index];
                  final gameType = s.gameType;
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff1E293B),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          gameType.emoji,
                          style: TextStyle(fontSize: 24.sp),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gameType.displayName,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Row(
                                children: [
                                  Text(
                                    s.emotion.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: const Color(0xff55EEDA),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    ' • ${_formatDate(s.playedAt)}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '+${s.xpEarned} XP',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff55EEDA),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Score: ${s.score}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }
}
