import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/dashboard/ui/dashboard_screen.dart';
import 'package:mindsense_app/features/games/logic/gamification_provider.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';
import 'package:mindsense_app/features/games/ui/widgets/game_canvas.dart';
import 'package:mindsense_app/features/games/ui/widgets/player_stats_bar.dart';
import 'package:mindsense_app/features/games/ui/widgets/recent_sessions_wid.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:mindsense_app/features/games/ui/rank_screen.dart';
import 'package:provider/provider.dart';

class GamesHubScreen extends StatefulWidget {
  final  bool ?canpop;
  const GamesHubScreen({super.key, this.canpop,});
  
  @override
  State<GamesHubScreen> createState() => _GamesHubScreenState();
}

class _GamesHubScreenState extends State<GamesHubScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GamificationProvider>().fetchProfile();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onGameSelected(GameType game) {
    final spec = GameSpec(
      gameType: game,
      difficulty: DifficultyLevel.medium,
      xpReward: game.baseXp,
      pointsReward: (game.baseXp * 2.5).round(),
      emotion: 'neutral',
      energyLevel: EnergyLevel.medium,
    );
    context.read<GamificationProvider>().setActiveSpec(spec);
    
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canpop??true,      
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final provider = context.read<Mainscreenprovider>();
        // Delay to let navigation settle
        await Future.delayed(const Duration(milliseconds: 50));
        if (!context.mounted) return;
        provider.changeIndex(0);
        log(provider.index.toString());
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  RankScreen(),
                  ),
                );
              },
              color: Color(0xff1E293B),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),                   
              child: Row(
                
                children: [
                  Icon(Icons.emoji_events),
                  SizedBox(width: 6.8.w),
                  Text(
                    'Ranking',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),],)
                        ),
            SizedBox(width: 10.w,)
          ],
        ),
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: true,
                snap: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Colors.transparent,
                title: Row(
                  children: [
                    Text(
                      'Games Hub',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text('🎮', style: TextStyle(fontSize: 20.sp)),
                  ],
                ),
                actions: [
                  Consumer<GamificationProvider>(
                    builder: (_, gp, __) => Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xff55EEDA)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                                color: const Color(0xff55EEDA)
                                    .withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            '⭐ ${gp.points} pts',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff55EEDA),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const PlayerStatsBar(),
                    SizedBox(height: 20.h),
      
                    Text(
                      'Active Game',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    const GameCanvas(),
                    SizedBox(height: 24.h),
      
                    Text(
                      'All Games',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _AllGamesGrid(onGameSelected: _onGameSelected),
                    SizedBox(height: 24.h),
      
                    // 4. Recent Sessions
                    const RecentSessionsWid(),
                    SizedBox(height: 24.h),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AllGamesGrid extends StatelessWidget {
  final void Function(GameType) onGameSelected;

  const _AllGamesGrid({required this.onGameSelected});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.1,
      ),
      itemCount: GameType.values.length,
      itemBuilder: (context, index) {
        final game = GameType.values[index];
        return GestureDetector(
          onTap: () => onGameSelected(game),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff1E293B),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            padding: EdgeInsets.all(12.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(game.emoji, style: TextStyle(fontSize: 36.sp)),
                SizedBox(height: 8.h),
                Text(
                  game.displayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
