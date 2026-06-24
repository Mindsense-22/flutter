import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PulsingOrb extends StatefulWidget {
  final bool isAnimating;
  const PulsingOrb({super.key, this.isAnimating = false});

  @override
  State<PulsingOrb> createState() => _PulsingOrbState();
}

class _PulsingOrbState extends State<PulsingOrb> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant PulsingOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _controller.stop();
      _controller.animateTo(0, duration: const Duration(milliseconds: 500));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale1 = 1.0 + (_controller.value * 0.1);
        final scale2 = 1.0 + (_controller.value * 0.4);
        final scale3 = 1.0 + (_controller.value * 0.8);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Transform.scale(
              scale: scale3,
              child: Container(
                width: 250.w,
                height: 250.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: DarkThemeColors.primaryColor.withOpacity(0.05),
                    width: 1,
                  ),
                ),
              ),
            ),
            // Middle ring
            Transform.scale(
              scale: scale2,
              child: Container(
                width: 180.w,
                height: 180.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: DarkThemeColors.primaryColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
            ),
            // Inner glowing orb
            Transform.scale(
              scale: scale1,
              child: Container(
                width: 130.w,
                height: 130.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      DarkThemeColors.primaryColor,
                      Color(0xff411BB4), // Darker purple/blue
                    ],
                    center: Alignment(-0.2, -0.2),
                    radius: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: DarkThemeColors.primaryColor.withOpacity(0.3 + (_controller.value * 0.2)),
                      blurRadius: 40 + (_controller.value * 20),
                      spreadRadius: 5 + (_controller.value * 10),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
