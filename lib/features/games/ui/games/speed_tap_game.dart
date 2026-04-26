import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';

class SpeedTapGame extends StatefulWidget {
  final GameSpec spec;
  final void Function(int score)? onComplete;

  const SpeedTapGame({super.key, required this.spec, this.onComplete});

  @override
  State<SpeedTapGame> createState() => _SpeedTapGameState();
}

class _SpeedTapGameState extends State<SpeedTapGame> {
  final Random _rng = Random();
  final List<_Target> _targets = [];
  int _score = 0;
  int _timeLeft = 30;
  Timer? _spawnTimer;
  Timer? _countdownTimer;
  bool _done = false;

  static const _colors = [
    Color(0xff55EEDA),
    Color(0xff67B6F7),
    Color(0xffA78BFA),
    Color(0xffFBBF24),
    Color(0xffF87171),
  ];

  @override
  void initState() {
    super.initState();
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      if (!_done) _spawnTarget();
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) _endGame();
      });
    });
  }

  void _spawnTarget() {
    final id = _rng.nextInt(999999);
    final x = _rng.nextDouble();
    final y = _rng.nextDouble();
    final color = _colors[_rng.nextInt(_colors.length)];
    final target = _Target(id: id, x: x, y: y, color: color);
    setState(() => _targets.add(target));

    Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _targets.removeWhere((t) => t.id == id));
    });
  }

  void _tapTarget(int id) {
    setState(() {
      final initialCount = _targets.length;
      _targets.removeWhere((t) => t.id == id);
      if (_targets.length < initialCount) _score += 15;
    });
  }

  void _endGame() {
    if (_done) return;
    setState(() => _done = true);
    _spawnTimer?.cancel();
    _countdownTimer?.cancel();
    widget.onComplete?.call(_score);
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final areaH = 280.h;
    final areaW = double.infinity;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '⚡ Score: $_score',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            Text(
              '⏱ ${_timeLeft}s',
              style: TextStyle(
                  fontSize: 14.sp,
                  color: _timeLeft <= 10 ? Colors.red : Colors.white54),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          height: areaH,
          decoration: BoxDecoration(
            color: const Color(0xff0F172A),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: _done
              ? Center(
                  child: Text(
                    '⚡ Final Score: $_score',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final h = constraints.maxHeight;
                    return Stack(
                      children: _targets.map((t) {
                        return Positioned(
                          left: t.x * (w - 52.w),
                          top: t.y * (h - 52.h),
                          child: GestureDetector(
                            onTap: () => _tapTarget(t.id),
                            child: AnimatedOpacity(
                              opacity: 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Container(
                                width: 52.w,
                                height: 52.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: t.color.withValues(alpha: 0.25),
                                  border:
                                      Border.all(color: t.color, width: 2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: t.color.withValues(alpha: 0.4),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '🎯',
                                    style: TextStyle(fontSize: 22.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Tap the targets before they vanish!',
          style: TextStyle(fontSize: 12.sp, color: Colors.white38),
        ),
      ],
    );
  }
}

class _Target {
  final int id;
  final double x, y;
  final Color color;
  _Target({required this.id, required this.x, required this.y, required this.color});
}
