import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';

class BalloonPopGame extends StatefulWidget {
  final GameSpec spec;
  final void Function(int score)? onComplete;

  const BalloonPopGame({super.key, required this.spec, this.onComplete});

  @override
  State<BalloonPopGame> createState() => _BalloonPopGameState();
}

class _BalloonPopGameState extends State<BalloonPopGame> {
  final Random _rng = Random();
  final List<_Balloon> _balloons = [];
  int _score = 0;
  int _misses = 0;
  int _timeLeft = 60;
  Timer? _spawnTimer;
  Timer? _countdownTimer;
  bool _done = false;

  static const _balloonEmojis = ['🟣', '🔵', '🟢', '🟡', '🟠', '🔴'];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 1200), (_) {
      if (!_done) _spawnBalloon();
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) _endGame();
      });
    });
  }

  void _spawnBalloon() {
    final isEvil = _rng.nextDouble() < 0.2;
    final xPos = _rng.nextDouble();
    final id = _rng.nextInt(999999);
    final balloon = _Balloon(
      id: id,
      xFraction: xPos,
      isEvil: isEvil,
    );
    setState(() => _balloons.add(balloon));

    Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      if (_balloons.any((b) => b.id == id)) {
        setState(() {
          _balloons.removeWhere((b) => b.id == id);
          if (!isEvil) _misses++;
        });
      }
    });
  }

  void _popBalloon(_Balloon b) {
    setState(() {
      _balloons.remove(b);
      if (b.isEvil) {
        _score = (_score - 10).clamp(0, 9999);
      } else {
        _score += 10;
      }
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
    final screenH = 320.h;
    final screenW = 300.w;

    return Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🎈 Score: $_score',
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              Text(
                '⏱ ${_timeLeft}s',
                style: TextStyle(
                    fontSize: 14.sp,
                    color:
                        _timeLeft <= 10 ? Colors.red : Colors.white54),
              ),
            ],
          ),
        ),
        Text(
          'Tap colorful balloons, avoid ☠️',
          style: TextStyle(fontSize: 12.sp, color: Colors.white38),
        ),
        SizedBox(height: 8.h),
        Container(
          width: screenW,
          height: screenH,
          decoration: BoxDecoration(
            color: const Color(0xff0F172A),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: _done
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🎉',
                          style: TextStyle(fontSize: 40.sp)),
                      SizedBox(height: 8.h),
                      Text(
                        'Time\'s up!\nFinal Score: $_score',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: _balloons.map((b) {
                    return AnimatedPositioned(
                      key: ValueKey(b.id),
                      duration: const Duration(seconds: 4),
                      curve: Curves.linear,
                      bottom: screenH,
                      left: b.xFraction * (screenW - 50.w),
                      child: GestureDetector(
                        onTap: () => _popBalloon(b),
                        child: Text(
                          b.isEvil ? '☠️' : _balloonEmojis[b.id % _balloonEmojis.length],
                          style: TextStyle(fontSize: 36.sp),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

class _Balloon {
  final int id;
  final double xFraction;
  final bool isEvil;
  _Balloon({required this.id, required this.xFraction, required this.isEvil});
}
