import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';

class IceBreakerGame extends StatefulWidget {
  final GameSpec spec;
  final VoidCallback? onComplete;

  const IceBreakerGame({super.key, required this.spec, this.onComplete});

  @override
  State<IceBreakerGame> createState() => _IceBreakerGameState();
}

class _IceBreakerGameState extends State<IceBreakerGame>
    with SingleTickerProviderStateMixin {
  // Phase 1: Ice tapping
  final List<Offset> _cracks = [];
  int _taps = 0;
  static const _requiredTaps = 20;
  bool _iceBroken = false;

  // Phase 2: Breathing
  late AnimationController _breathController;
  late Animation<double> _breathAnim;
  int _breathCycle = 0;
  static const _totalBreathCycles = 3;
  String _breathLabel = 'Inhale';
  bool _done = false;
  Timer? _phaseTimer;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _nextBreathPhase(true);
        } else if (status == AnimationStatus.dismissed) {
          _nextBreathPhase(false);
        }
      });
    _breathAnim = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  void _onIceTap(TapDownDetails details) {
    if (_iceBroken) return;
    setState(() {
      _cracks.add(details.localPosition);
      _taps++;
      if (_taps >= _requiredTaps) {
        _iceBroken = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _startBreathing();
        });
      }
    });
  }

  void _startBreathing() {
    setState(() => _breathLabel = 'Inhale');
    _breathController.forward(from: 0);
  }

  void _nextBreathPhase(bool justForwarded) {
    if (_done) return;
    if (justForwarded) {
      // hold then exhale
      setState(() => _breathLabel = 'Hold');
      _phaseTimer = Timer(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _breathLabel = 'Exhale');
        _breathController.reverse();
      });
    } else {
      // rest then next cycle
      setState(() => _breathLabel = 'Rest');
      _phaseTimer = Timer(const Duration(seconds: 2), () {
        if (!mounted) return;
        _breathCycle++;
        if (_breathCycle >= _totalBreathCycles) {
          setState(() {
            _done = true;
            _breathLabel = 'Done!';
          });
          widget.onComplete?.call();
        } else {
          setState(() => _breathLabel = 'Inhale');
          _breathController.forward(from: 0);
        }
      });
    }
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_iceBroken) ...[
          Text(
            'Tap the ice to release tension!',
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          SizedBox(height: 8.h),
          Text(
            '${_taps} / $_requiredTaps taps',
            style: TextStyle(fontSize: 13.sp, color: Colors.white54),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTapDown: _onIceTap,
            child: CustomPaint(
              painter: _IcePainter(_cracks, _taps / _requiredTaps),
              child: Container(
                width: 220.w,
                height: 220.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          LinearProgressIndicator(
            value: _taps / _requiredTaps,
            backgroundColor: Colors.white12,
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xff67B6F7)),
            minHeight: 6.h,
          ),
        ] else ...[
          Text(
            _done ? '✅ Great job! Anger released.' : _breathLabel,
            style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          SizedBox(height: 8.h),
          if (!_done)
            Text(
              'Cycle ${_breathCycle + 1} of $_totalBreathCycles',
              style: TextStyle(fontSize: 13.sp, color: Colors.white54),
            ),
          SizedBox(height: 30.h),
          AnimatedBuilder(
            animation: _breathAnim,
            builder: (_, __) => Container(
              width: 160.w * _breathAnim.value,
              height: 160.w * _breathAnim.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xff67B6F7).withValues(alpha: 0.25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff67B6F7)
                        .withValues(alpha: 0.4 * _breathAnim.value),
                    blurRadius: 30 * _breathAnim.value,
                    spreadRadius: 10 * _breathAnim.value,
                  ),
                ],
              ),
              child:
                  Center(child: Text('🧊', style: TextStyle(fontSize: 40.sp))),
            ),
          ),
        ],
      ],
    );
  }
}

class _IcePainter extends CustomPainter {
  final List<Offset> cracks;
  final double progress;
  final Random _rng = Random(42);

  _IcePainter(this.cracks, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Ice block
    final icePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color.lerp(const Color(0xffADD8E6), const Color(0xff87CEEB), progress)!,
          Color.lerp(const Color(0xff89CFF0), const Color(0xff6495ED), progress)!,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height),
            const Radius.circular(16)),
        icePaint);

    // Crack lines from each tap point
    final crackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (final origin in cracks) {
      final numLines = 4 + _rng.nextInt(4);
      for (int i = 0; i < numLines; i++) {
        final angle = _rng.nextDouble() * 2 * pi;
        final length = 10 + _rng.nextDouble() * 30;
        final end = Offset(
          origin.dx + cos(angle) * length,
          origin.dy + sin(angle) * length,
        );
        canvas.drawLine(origin, end, crackPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_IcePainter old) => true;
}
