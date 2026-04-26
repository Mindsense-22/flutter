import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';

class MemoryMatchGame extends StatefulWidget {
  final GameSpec spec;
  final void Function(int score)? onComplete;

  const MemoryMatchGame({super.key, required this.spec, this.onComplete});

  @override
  State<MemoryMatchGame> createState() => _MemoryMatchGameState();
}

class _MemoryMatchGameState extends State<MemoryMatchGame> {
  static const _emojis = [
    '🌸', '🦋', '🌟', '🌈', '🌺', '🍀', '🌙', '☀️'
  ];

  late List<String> _cards;
  late List<bool> _flipped;
  late List<bool> _matched;
  final List<int> _selected = [];
  bool _checking = false;
  int _matches = 0;
  int _attempts = 0;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final pairs = [..._emojis, ..._emojis]..shuffle(Random());
    _cards = pairs;
    _flipped = List.filled(_cards.length, false);
    _matched = List.filled(_cards.length, false);
  }

  void _onCardTap(int index) {
    if (_checking || _flipped[index] || _matched[index]) return;
    setState(() {
      _flipped[index] = true;
      _selected.add(index);
    });

    if (_selected.length == 2) {
      _attempts++;
      _checking = true;
      Timer(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        if (_cards[_selected[0]] == _cards[_selected[1]]) {
          setState(() {
            _matched[_selected[0]] = true;
            _matched[_selected[1]] = true;
            _matches++;
          });
          if (_matches == _emojis.length) {
            setState(() => _done = true);
            final score = ((_emojis.length * 100) - _attempts * 5).clamp(0, 1000);
            widget.onComplete?.call(score);
          }
        } else {
          setState(() {
            _flipped[_selected[0]] = false;
            _flipped[_selected[1]] = false;
          });
        }
        _selected.clear();
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Matches: $_matches / ${_emojis.length}',
                style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xff55EEDA),
                    fontWeight: FontWeight.w700),
              ),
              Text(
                'Attempts: $_attempts',
                style: TextStyle(fontSize: 13.sp, color: Colors.white54),
              ),
            ],
          ),
        ),
        if (_done)
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Text(
              '🎉 All matched! Great memory!',
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          )
        else
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.w,
              childAspectRatio: 1,
            ),
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              final isFlipped = _flipped[index] || _matched[index];
              return GestureDetector(
                onTap: () => _onCardTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _matched[index]
                        ? const Color(0xff55EEDA).withValues(alpha: 0.2)
                        : isFlipped
                            ? const Color(0xff1E293B)
                            : const Color(0xff2D3B55),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: _matched[index]
                          ? const Color(0xff55EEDA)
                          : Colors.white.withValues(alpha: 0.08),
                      width: _matched[index] ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isFlipped
                          ? Text(
                              _cards[index],
                              key: ValueKey('open_$index'),
                              style: TextStyle(fontSize: 24.sp),
                            )
                          : Text(
                              '?',
                              key: ValueKey('closed_$index'),
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.white38,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
