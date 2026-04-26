import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';

class WordBuilderGame extends StatefulWidget {
  final GameSpec spec;
  final void Function(int score)? onComplete;

  const WordBuilderGame({super.key, required this.spec, this.onComplete});

  @override
  State<WordBuilderGame> createState() => _WordBuilderGameState();
}

class _WordBuilderGameState extends State<WordBuilderGame> {
  static const _words = [
    'CALM', 'BREATHE', 'PEACE', 'FOCUS', 'SMILE',
    'HOPE', 'JOY', 'RELAX', 'GROW', 'KIND'
  ];

  int _wordIndex = 0;
  late List<String> _scrambled;
  final List<String> _selected = [];
  final List<int> _selectedIndices = [];
  int _score = 0;
  int _timeLeft = 60;
  Timer? _timer;
  bool _done = false;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    _loadWord();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) _finish();
      });
    });
  }

  void _loadWord() {
    if (_wordIndex >= _words.length) {
      _finish();
      return;
    }
    final word = _words[_wordIndex];
    final letters = word.split('')..shuffle();
    setState(() {
      _scrambled = letters;
      _selected.clear();
      _selectedIndices.clear();
    });
  }

  void _tapLetter(int index) {
    if (_selectedIndices.contains(index)) return;
    setState(() {
      _selected.add(_scrambled[index]);
      _selectedIndices.add(index);
    });

    if (_selected.length == _words[_wordIndex].length) {
      final guess = _selected.join();
      if (guess == _words[_wordIndex]) {
        setState(() {
          _feedback = '✅ Correct!';
          _score += 50;
        });
        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          setState(() {
            _wordIndex++;
            _feedback = null;
          });
          _loadWord();
        });
      } else {
        setState(() => _feedback = '❌ Try again!');
        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          setState(() {
            _selected.clear();
            _selectedIndices.clear();
            _feedback = null;
          });
        });
      }
    }
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
              '🔤 Score: $_score',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            Text(
              '⏱ ${_timeLeft}s  •  ${_wordIndex + 1}/${_words.length}',
              style: TextStyle(fontSize: 13.sp, color: Colors.white54),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        if (_done)
          Text(
            '🎉 Done! Score: $_score',
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          )
        else ...[
          Text(
            '${_feedback ?? 'Spell the word!'}',
            style: TextStyle(
                fontSize: 15.sp,
                color: _feedback != null
                    ? (_feedback!.startsWith('✅')
                        ? const Color(0xff55EEDA)
                        : Colors.red)
                    : Colors.white54),
          ),
          SizedBox(height: 20.h),
          // Answer slots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _words[_wordIndex].length,
              (i) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: 36.w,
                height: 40.h,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: i < _selected.length
                          ? const Color(0xff55EEDA)
                          : Colors.white38,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    i < _selected.length ? _selected[i] : '',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          // Scrambled letters
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.w,
            runSpacing: 8.h,
            children: List.generate(
              _scrambled.length,
              (i) => GestureDetector(
                onTap: () => _tapLetter(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: _selectedIndices.contains(i)
                        ? const Color(0xff55EEDA).withValues(alpha: 0.15)
                        : const Color(0xff1E293B),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: _selectedIndices.contains(i)
                          ? const Color(0xff55EEDA)
                          : Colors.white24,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _selectedIndices.contains(i) ? '' : _scrambled[i],
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
