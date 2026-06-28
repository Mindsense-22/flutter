import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/games/logic/gamification_provider.dart';
import 'package:provider/provider.dart';

class RankScreen extends StatefulWidget {
  const RankScreen({super.key});

  @override
  State<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GamificationProvider>().fetchLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<GamificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLeaderboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.leaderboardError != null) {
            return Center(
              child: Text(
                'Error: ${provider.leaderboardError}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final leaderboard = provider.leaderboard;

          if (leaderboard.isEmpty) {
            return const Center(
              child: Text('No ranking data available'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<GamificationProvider>().fetchLeaderboard();
            },
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                final user = leaderboard[index];
                return _buildRankItem(context, user, index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRankItem(BuildContext context, LeaderboardUser user, int index) {
    final rank = index + 1;
    Color rankColor;
    if (rank == 1) {
      rankColor = const Color(0xFFFFD700); 
    } else if (rank == 2) {
      rankColor = const Color(0xFFC0C0C0);
    } else if (rank == 3) {
      rankColor = const Color(0xFFCD7F32); 
    } else {
      rankColor = Colors.white;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xff1E293B),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: rank <= 3 ? rankColor.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: rankColor,
              ),
            ),
          ),          
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      'Lvl ${user.level}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      '${user.xp} XP',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${user.contribution}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff55EEDA),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.handshake, size: 12.sp, color: const Color(0xff55EEDA).withValues(alpha: 0.8)),
                  SizedBox(width: 4.w),
                  Text(
                    'contribution',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xff55EEDA).withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}