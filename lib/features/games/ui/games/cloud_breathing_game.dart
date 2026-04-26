import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/games/models/game_models.dart';

class CloudBreathingGame extends StatefulWidget {
  final GameSpec spec;
  final VoidCallback? onComplete;

  const CloudBreathingGame({
    super.key,
    required this.spec,
    this.onComplete,
  });

  @override
  State<CloudBreathingGame> createState() => _CloudBreathingGameState();
}

class _CloudBreathingGameState extends State<CloudBreathingGame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  // Breathing phases
  static const _phases = [
    _Phase('Inhale', 4, Color(0xff55EEDA)),
    _Phase('Hold', 2, Color(0xff67B6F7)),
    _Phase('Exhale', 6, Color(0xffA78BFA)),
    _Phase('Rest', 2, Color(0xff1E293B)),
  ];

  int _phaseIndex = 0;
  int _cycles = 0;
  final int _totalCycles = 3;
  String _phaseLabel = 'Inhale';
  Color _circleColor = const Color(0xff55EEDA);
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _runBreathingCycle();
  }

  Future<void> _runBreathingCycle() async {
    try {
      while (!_done && mounted) {
        if (_cycles >= _totalCycles) {
          setState(() => _done = true);
          widget.onComplete?.call();
          return;
        }

        for (int i = 0; i < _phases.length; i++) {
          if (!mounted) return;
          final phase = _phases[i];
          setState(() {
            _phaseIndex = i;
            _phaseLabel = phase.name;
            _circleColor = phase.color;
          });

          if (phase.name == 'Inhale') {
            _controller.duration = Duration(seconds: phase.seconds);
            await _controller.forward(from: 0.0);
          } else if (phase.name == 'Exhale') {
            _controller.duration = Duration(seconds: phase.seconds);
            await _controller.reverse(from: 1.0);
          } else {
            // Hold or Rest - do not update the animation, just wait.
            await Future.delayed(Duration(seconds: phase.seconds));
          }
        }
        
        if (mounted) _cycles++;
      }
    } catch (e) {
      // Catch TickerCanceled exceptions if disposed mid-animation
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _done ? '✅ Done! Great breathing session.' : _phaseLabel,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Cycle ${_cycles + 1} of $_totalCycles',
          style: TextStyle(fontSize: 13.sp, color: Colors.white54),
        ),
        SizedBox(height: 40.h),
        AnimatedBuilder(
          animation: _scaleAnim,
          builder: (context, _) {
            final scale = _scaleAnim.value;
            return Container(
              width: 180.w * scale,
              height: 180.w * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _circleColor.withValues(alpha: 0.3),
                boxShadow: [
                  BoxShadow(
                    color: _circleColor.withValues(alpha: 0.4),
                    blurRadius: 30 * scale,
                    spreadRadius: 10 * scale,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 120.w * scale,
                  height: 120.w * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _circleColor.withValues(alpha: 0.7),
                  ),
                  child: Center(
                    child: Text(
                      '☁️',
                      style: TextStyle(fontSize: 40.sp * scale.clamp(0.8, 1.2)),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 40.h),
        if (!_done)
          Text(
            _phaseIndex == 0
                ? 'Breathe in slowly...'
                : _phaseIndex == 1
                    ? 'Hold your breath...'
                    : _phaseIndex == 2
                        ? 'Breathe out slowly...'
                        : 'Rest...',
            style: TextStyle(fontSize: 14.sp, color: Colors.white54),
          ),
      ],
    );
  }
}

class _Phase {
  final String name;
  final int seconds;
  final Color color;

  const _Phase(this.name, this.seconds, this.color);
}
