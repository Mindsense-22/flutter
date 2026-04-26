import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/games/logic/gamification_provider.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';
import 'package:mindsense_app/features/games/ui/games/balloon_pop_game.dart';
import 'package:mindsense_app/features/games/ui/games/cloud_breathing_game.dart';
import 'package:mindsense_app/features/games/ui/games/focus_flow_game.dart';
import 'package:mindsense_app/features/games/ui/games/ice_breaker_game.dart';
import 'package:mindsense_app/features/games/ui/games/memory_match_game.dart';
import 'package:mindsense_app/features/games/ui/games/pattern_chain_game.dart';
import 'package:mindsense_app/features/games/ui/games/sorting_storm_game.dart';
import 'package:mindsense_app/features/games/ui/games/speed_tap_game.dart';
import 'package:mindsense_app/features/games/ui/games/word_builder_game.dart';
import 'package:provider/provider.dart';

class GameCanvas extends StatefulWidget {
  const GameCanvas({super.key});

  @override
  State<GameCanvas> createState() => _GameCanvasState();
}

class _GameCanvasState extends State<GameCanvas> {
  bool _playing = false;
  bool _completed = false;
  int _finalScore = 0;

  void _startGame() => setState(() {
        _playing = true;
        _completed = false;
        _finalScore = 0;
      });

  Future<void> _onComplete(
      BuildContext ctx, GamificationProvider gp, int score) async {
    setState(() {
      _playing = false;
      _completed = true;
      _finalScore = score;
    });

    final spec = gp.activeSpec!;
    final leveledUp = await gp.completeGame(spec, score);

    if (!ctx.mounted) return;

    if (leveledUp) {
      _showNotification(
          ctx,
          '⬆️ Level Up! You\'re now Level ${gp.level}!',
          const Color(0xff55EEDA));
    } else if (gp.isStreakMilestone()) {
      _showNotification(
          ctx,
          '🔥 ${gp.streakDays}-Day Streak! You\'re on fire!',
          Colors.orange);
    }
  }

  void _showNotification(BuildContext ctx, String msg, Color color) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r)),
        content: Text(
          msg,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamificationProvider>(
      builder: (context, gp, _) {
        final spec = gp.activeSpec;

        if (spec == null) {
          return _EmptyCanvas();
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: const Color(0xff0F172A),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            children: [
              // Game header
              Row(
                children: [
                  Text(
                    spec.gameType.emoji,
                    style: TextStyle(fontSize: 28.sp),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spec.gameType.displayName,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Text(
                          '${spec.difficulty.name.toUpperCase()} • ${spec.gameType.duration} • +${spec.xpReward} XP',
                          style: TextStyle(
                              fontSize: 11.sp, color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                  if (!_playing && !_completed)
                    _PlayButton(onTap: _startGame),
                ],
              ),

              SizedBox(height: 16.h),

              if (!_playing && !_completed)
                _GameStartScreen(spec: spec, onPlay: _startGame)
              else if (_completed)
                _CompletedScreen(
                  spec: spec,
                  score: _finalScore,
                  onReplay: () {
                    setState(() {
                      _playing = false;
                      _completed = false;
                    });
                  },
                )
              else
                _buildGame(context, gp, spec),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGame(
      BuildContext ctx, GamificationProvider gp, GameSpec spec) {
    switch (spec.gameType) {
      case GameType.cloudBreathing:
        return CloudBreathingGame(
          spec: spec,
          onComplete: () => _onComplete(ctx, gp, 100),
        );
      case GameType.memoryMatch:
        return MemoryMatchGame(
          spec: spec,
          onComplete: (s) => _onComplete(ctx, gp, s),
        );
      case GameType.balloonPop:
        return BalloonPopGame(
          spec: spec,
          onComplete: (s) => _onComplete(ctx, gp, s),
        );
      case GameType.sortingStorm:
        return SortingStormGame(
          spec: spec,
          onComplete: (s) => _onComplete(ctx, gp, s),
        );
      case GameType.speedTap:
        return SpeedTapGame(
          spec: spec,
          onComplete: (s) => _onComplete(ctx, gp, s),
        );
      case GameType.wordBuilder:
        return WordBuilderGame(
          spec: spec,
          onComplete: (s) => _onComplete(ctx, gp, s),
        );
      case GameType.iceBreaker:
        return IceBreakerGame(
          spec: spec,
          onComplete: () => _onComplete(ctx, gp, 200),
        );
      case GameType.focusFlow:
        return FocusFlowGame(
          spec: spec,
          onComplete: (s) => _onComplete(ctx, gp, s),
        );
      case GameType.patternChain:
        return PatternChainGame(
          spec: spec,
          onComplete: (s) => _onComplete(ctx, gp, s),
        );
    }
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _EmptyCanvas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30.r),
      decoration: BoxDecoration(
        color: const Color(0xff0F172A),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Text('🎮', style: TextStyle(fontSize: 48.sp)),
          SizedBox(height: 12.h),
          Text(
            'Complete an analysis to get your\npersonalized game recommendation!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final VoidCallback onTap;

  const _PlayButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xff55EEDA),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          'Play',
          style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black),
        ),
      ),
    );
  }
}

class _GameStartScreen extends StatelessWidget {
  final GameSpec spec;
  final VoidCallback onPlay;

  const _GameStartScreen({required this.spec, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          spec.gameType.goal,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.sp, color: Colors.white60),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatChip('⏱ ${spec.gameType.duration}'),
            SizedBox(width: 10.w),
            _StatChip('✨ +${spec.xpReward} XP'),
            SizedBox(width: 10.w),
            _StatChip('⭐ +${spec.pointsReward} pts'),
          ],
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPlay,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff55EEDA),
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text(
              'Start Game',
              style: TextStyle(
                  fontSize: 15.sp, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  const _StatChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11.sp, color: Colors.white60),
      ),
    );
  }
}

class _CompletedScreen extends StatelessWidget {
  final GameSpec spec;
  final int score;
  final VoidCallback onReplay;

  const _CompletedScreen(
      {required this.spec, required this.score, required this.onReplay});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('🎉', style: TextStyle(fontSize: 48.sp)),
        SizedBox(height: 8.h),
        Text(
          'Game Complete!',
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatChip('🏆 Score: $score'),
            SizedBox(width: 10.w),
            _StatChip('✨ +${spec.xpReward} XP'),
          ],
        ),
        SizedBox(height: 16.h),
        OutlinedButton(
          onPressed: onReplay,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xff55EEDA)),
            foregroundColor: const Color(0xff55EEDA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
          ),
          child: Text('Play Again', style: TextStyle(fontSize: 14.sp)),
        ),
      ],
    );
  }
}
