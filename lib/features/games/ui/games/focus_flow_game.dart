import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';

class FocusFlowGame extends StatefulWidget {
  final GameSpec spec;
  final void Function(int score)? onComplete;

  const FocusFlowGame({super.key, required this.spec, this.onComplete});

  @override
  State<FocusFlowGame> createState() => _FocusFlowGameState();
}

class _FocusFlowGameState extends State<FocusFlowGame> {
  static const _colorMap = {
    'RED': Color(0xffF87171),
    'GREEN': Color(0xff4ADE80),
    'BLUE': Color(0xff60A5FA),
    'YELLOW': Color(0xffFBBF24),
    'PURPLE': Color(0xffA78BFA),
  };

  final Random _rng = Random();
  late String _word;
  late String _inkColor;
  late String _correct;

  int _score = 0;
  int _round = 0;
  int _total = 15;
  int _timeLeft = 40;
  Timer? _timer;
  bool _done = false;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    _nextRound();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) _finish();
      });
    });
  }

  void _nextRound() {
    if (_round >= _total) {
      _finish();
      return;
    }
    final keys = _colorMap.keys.toList();
    _word = keys[_rng.nextInt(keys.length)];
    // Ink color is always different from the word
    String ink;
    do {
      ink = keys[_rng.nextInt(keys.length)];
    } while (ink == _word);
    _inkColor = ink;
    _correct = _inkColor; // User must tap the INK COLOR NAME
  }

  void _onTap(String tapped) {
    final isCorrect = tapped == _correct;
    setState(() {
      _feedback = isCorrect ? '✅' : '❌';
      if (isCorrect) _score += 10;
      _round++;
    });
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        _feedback = null;
        _nextRound();
      });
    });
  }

  void _finish() {
    if (_done) return;
    setState(() => _done = true);
    _timer?.cancel();
    widget.onComplete?.call(_score);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keys = _colorMap.keys.toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '🎯 Score: $_score',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            Text(
              '⏱ ${_timeLeft}s  •  $_round/$_total',
              style: TextStyle(fontSize: 13.sp, color: Colors.white54),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        if (_done)
          Center(
            child: Text(
              '🎉 Done! Score: $_score',
              style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          )
        else ...[
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: const Color(0xff1E293B),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Text(
                  'Tap the INK COLOR',
                  style:
                      TextStyle(fontSize: 12.sp, color: Colors.white38),
                ),
                SizedBox(height: 16.h),
                Text(
                  _word,
                  style: TextStyle(
                    fontSize: 42.sp,
                    fontWeight: FontWeight.w900,
                    color: _colorMap[_inkColor],
                    letterSpacing: 4,
                  ),
                ),
                SizedBox(height: 8.h),
                if (_feedback != null)
                  Text(
                    _feedback!,
                    style: TextStyle(fontSize: 20.sp),
                  ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10.w,
            runSpacing: 10.h,
            children: keys.map((colorName) {
              return GestureDetector(
                onTap: () => _onTap(colorName),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 18.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: _colorMap[colorName]!.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: _colorMap[colorName]!),
                  ),
                  child: Text(
                    colorName,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: _colorMap[colorName],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
