import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';

class SortingStormGame extends StatefulWidget {
  final GameSpec spec;
  final void Function(int score)? onComplete;

  const SortingStormGame({super.key, required this.spec, this.onComplete});

  @override
  State<SortingStormGame> createState() => _SortingStormGameState();
}

class _SortingStormGameState extends State<SortingStormGame> {
  static const _calmEmojis = ['😌', '🌸', '☁️', '🌊', '🕊️', '🌙'];
  static const _energeticEmojis = ['⚡', '🔥', '💥', '🚀', '💪', '🏃'];

  final Random _rng = Random();
  late List<_SortItem> _items;
  int _current = 0;
  int _score = 0;
  int _timeLeft = 45;
  Timer? _timer;
  bool _done = false;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    _buildItems();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) _finish();
      });
    });
  }

  void _buildItems() {
    final calm = _calmEmojis.map((e) => _SortItem(e, 'calm'));
    final energetic =
        _energeticEmojis.map((e) => _SortItem(e, 'energetic'));
    _items = [...calm, ...energetic]..shuffle(_rng);
  }

  void _sort(String category) {
    if (_done || _current >= _items.length) return;
    final correct = _items[_current].category == category;
    setState(() {
      _feedback = correct ? '✅ Correct!' : '❌ Wrong!';
      if (correct) _score += 10;
      _current++;
      if (_current >= _items.length) _finish();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _feedback = null);
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
        SizedBox(height: 8.h),
        LinearProgressIndicator(
          value: _current / _items.length,
          backgroundColor: Colors.white12,
          valueColor:
              const AlwaysStoppedAnimation<Color>(Color(0xff55EEDA)),
          minHeight: 4.h,
        ),
        SizedBox(height: 30.h),
        if (_done)
          Text(
            '🎉 Done! Final Score: $_score',
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white),
            textAlign: TextAlign.center,
          )
        else ...[
          if (_feedback != null)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _feedback!,
                key: ValueKey(_feedback),
                style: TextStyle(fontSize: 16.sp, color: Colors.white70),
              ),
            )
          else
            SizedBox(height: 24.h),
          SizedBox(height: 10.h),
          Container(
            width: 130.w,
            height: 130.w,
            decoration: BoxDecoration(
              color: const Color(0xff1E293B),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff55EEDA).withValues(alpha: 0.2),
                  blurRadius: 20,
                )
              ],
            ),
            child: Center(
              child: Text(
                _current < _items.length
                    ? _items[_current].emoji
                    : '',
                style: TextStyle(fontSize: 60.sp),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            'Is this CALM or ENERGETIC?',
            style: TextStyle(fontSize: 14.sp, color: Colors.white54),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SortButton(
                label: '😌 Calm',
                color: const Color(0xff55EEDA),
                onTap: () => _sort('calm'),
              ),
              SizedBox(width: 16.w),
              _SortButton(
                label: '⚡ Energetic',
                color: const Color(0xffFBBF24),
                onTap: () => _sort('energetic'),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SortButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SortButton(
      {required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 14.sp, color: color, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _SortItem {
  final String emoji;
  final String category;
  _SortItem(this.emoji, this.category);
}
