import 'dart:math' as math;

import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';

class LinearGaugeNeedle extends CustomPainter {
  const LinearGaugeNeedle({
    required this.length,
    this.color = ColorName.neural700,
  });

  final double length;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(-length/2, 0);
    final p2 = Offset(length/2, 0);
    final p3 = Offset(0, length * math.sqrt(3) / 2);
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(p1.dx, p1.dy);

    final paint = Paint()
      ..color = ColorName.neural600
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
