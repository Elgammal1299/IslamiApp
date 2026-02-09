import 'dart:math';

import 'package:flutter/material.dart';

class WaveformPainter extends CustomPainter {
  final int numberOfBars;
  final double maxHeight;
  final Animation<double> animation;

  WaveformPainter({
    required this.numberOfBars,
    required this.maxHeight,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    for (int i = 0; i < numberOfBars; i++) {
      final angle = (i * 2 * pi) / numberOfBars;
      final barHeight =
          maxHeight * (0.3 + 0.7 * (sin(animation.value * pi + i) + 1) / 2);

      // إنشاء تدرج لوني للموجات
      final paint =
          Paint()
            ..shader = LinearGradient(
              colors: [Colors.purple.shade400, Colors.blue.shade400],
            ).createShader(
              Rect.fromCircle(center: center, radius: radius + maxHeight),
            )
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round;

      final startPoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      final endPoint = Offset(
        center.dx + (radius + barHeight) * cos(angle),
        center.dy + (radius + barHeight) * sin(angle),
      );

      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
