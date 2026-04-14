import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceWave extends StatelessWidget {
  final List<double> amplitudes;

  const VoiceWave({super.key, required this.amplitudes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.h,
      width: 200.w,
      child: CustomPaint(
        painter: WavePainter(amplitudes),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final List<double> amplitudes;

  WavePainter(this.amplitudes);

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    final paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.5;

    double middle = size.height / 2;
    double spacing = 10.w;
    
    
    double waveContentWidth = amplitudes.length * spacing;

    double startX = (size.width - waveContentWidth) / 2;

    for (int i = 0; i < amplitudes.length; i++) {
      double x = startX + (i * spacing);

      
      if (x < 0 || x > size.width) continue;

      double barHeight = amplitudes[i] * 0.25;

      canvas.drawLine(
        Offset(x, middle - barHeight),
        Offset(x, middle + barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {    
    return oldDelegate.amplitudes != amplitudes;
  }
}