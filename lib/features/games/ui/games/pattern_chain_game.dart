import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';

class PatternChainGame extends StatefulWidget {
  final GameSpec spec;
  final void Function(int score)? onComplete;

  const PatternChainGame({super.key, required this.spec, this.onComplete});

  @override
  State<PatternChainGame> createState() => _PatternChainGameState();
}

class _PatternChainGameState extends State<PatternChainGame> {
  static const _padColors = [
    Color(0xffF87171),
    Color(0xff4ADE80),
    Color(0xff60A5FA),
    Color(0xffFBBF24),
    Color(0xffA78BFA),
    Color(0xffF472B6),
  ];

  final List<int> _sequence = [];
  final List<int> _userInput = [];
  bool _isShowingSequence = false;
  int _highlightedPad = -1;
  int _round = 0;
  int _score = 0;
  bool _done = false;
  bool _waitingInput = false;
  String _statusText = 'Get ready...';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _nextRound();
    });
  }

  Future<void> _nextRound() async {
    _round++;
    _sequence.add(_sequence.isEmpty ? 0 : _sequence.last);
    // Add a random pad
    final next = (DateTime.now().millisecondsSinceEpoch) % 6;
    if (_sequence.isEmpty) {
      _sequence.add(next);
    } else {
      final last = _sequence.last;
      // pick a pad that's different from last to ensure variety
      _sequence.add((next + 1) % 6 == last ? next : (next + 1) % 6);
    }

    setState(() {
      _userInput.clear();
      _isShowingSequence = true;
      _waitingInput = false;
      _statusText = 'Watch the sequence...';
    });

    await _playSequence();
    setState(() {
      _isShowingSequence = false;
      _waitingInput = true;
      _statusText = 'Your turn! Repeat the sequence.';
    });
  }

  Future<void> _playSequence() async {
    for (final pad in _sequence) {
      if (!mounted) return;
      setState(() => _highlightedPad = pad);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() => _highlightedPad = -1);
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

  void _onPadTap(int index) {
    if (!_waitingInput || _done) return;
    setState(() => _userInput.add(index));

    final pos = _userInput.length - 1;
    if (_sequence[pos] != index) {
      // Wrong!
      setState(() {
        _statusText = '❌ Wrong! Game over.';
        _done = true;
        _waitingInput = false;
      });
      widget.onComplete?.call(_score);
      return;
    }

    if (_userInput.length == _sequence.length) {
      _score += _round * 10;
      setState(() => _statusText = '✅ Correct! Round ${_round + 1}...');
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        if (_round >= 8) {
          setState(() => _done = true);
          widget.onComplete?.call(_score);
        } else {
          _nextRound();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '🔮 Round: $_round',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 13.sp, color: Colors.white54),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          _statusText,
          style: TextStyle(
            fontSize: 14.sp,
            color: _statusText.startsWith('✅')
                ? const Color(0xff55EEDA)
                : _statusText.startsWith('❌')
                    ? Colors.red
                    : Colors.white60,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 1.6,
          ),
          itemCount: 6,
          itemBuilder: (_, index) {
            final isLit = _highlightedPad == index;
            return GestureDetector(
              onTap: () => _onPadTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: isLit
                      ? _padColors[index]
                      : _padColors[index].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: isLit
                      ? [
                          BoxShadow(
                            color: _padColors[index].withValues(alpha: 0.6),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                  border: Border.all(
                      color: _padColors[index].withValues(alpha: 0.5)),
                ),
              ),
            );
          },
        ),
        if (_done) ...[
          SizedBox(height: 20.h),
          Text(
            _score > 0 ? '🎉 Final Score: $_score' : 'Better luck next time!',
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
