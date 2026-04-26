import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';

class GameRecommendationCard extends StatelessWidget {
  final GameSpec spec;
  final VoidCallback onPlayNow;

  const GameRecommendationCard({
    super.key,
    required this.spec,
    required this.onPlayNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff1E293B),
            const Color(0xff0F172A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xff55EEDA).withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff55EEDA).withValues(alpha: 0.1),
            blurRadius: 16,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xff55EEDA).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                      color: const Color(0xff55EEDA).withValues(alpha: 0.5)),
                ),
                child: Text(
                  '🎮 Recommended Game',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff55EEDA),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                spec.gameType.emoji,
                style: TextStyle(fontSize: 36.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spec.gameType.displayName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      spec.gameType.goal,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              _InfoChip('⏱ ${spec.gameType.duration}'),
              SizedBox(width: 8.w),
              _InfoChip('✨ +${spec.xpReward} XP'),
              SizedBox(width: 8.w),
              _InfoChip(spec.difficulty.name.toUpperCase()),
            ],
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPlayNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff55EEDA),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 13.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                '▶  Play Now',
                style: TextStyle(
                    fontSize: 15.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  const _InfoChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10.sp, color: Colors.white54),
      ),
    );
  }
}
