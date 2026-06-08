import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The multi-spoke asterisk / starburst mark used as the app logo.
class BurstLogo extends StatelessWidget {
  const BurstLogo({super.key, this.size = 56, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BurstPainter(color)),
    );
  }
}

class _BurstPainter extends CustomPainter {
  _BurstPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const spokes = 12;
    final center = Offset(size.width / 2, size.height / 2);
    final outer = size.width / 2;
    final inner = outer * 0.32;
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < spokes; i++) {
      final angle = (math.pi * 2 / spokes) * i - math.pi / 2;
      final dir = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(center + dir * inner, center + dir * outer, paint);
    }
  }

  @override
  bool shouldRepaint(_BurstPainter oldDelegate) => oldDelegate.color != color;
}
