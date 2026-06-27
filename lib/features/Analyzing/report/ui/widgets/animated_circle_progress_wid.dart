import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedCircleProgress extends StatefulWidget {
  final double target; 
  final String state;
  const AnimatedCircleProgress({super.key, required this.target, required this.state});

  @override
  State<AnimatedCircleProgress> createState() =>
      _AnimatedCircleProgressState();
}

class _AnimatedCircleProgressState extends State<AnimatedCircleProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation = Tween<double>(begin: 0, end: widget.target).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic, 
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(160.w, 160.h),
          painter: CirclePainter(animation.value),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${(animation.value * 100).toInt()}%",
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  widget.state,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.green,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;

  CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 24.w;

    Offset center = size.center(Offset.zero);
    double radius = size.width / 4.9;

    
    Paint bg = Paint()
      ..color = Color(0xffB7BAC3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bg);

    
    Paint fg = Paint()
      ..shader = SweepGradient(
        colors: [
          Color(0xff66BB6A),
          Color(0xff66BB6A),
        ],
        startAngle: 0,
        endAngle: 2 * pi,
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double sweep = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweep,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}