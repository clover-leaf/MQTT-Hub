import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';

class RadialGaugeNeedle extends CustomPainter {
  const RadialGaugeNeedle({
    required this.thickness,
    required this.length,
    required this.centerRadius,
    this.color = ColorName.neural700,
  });
  // final double angle;
  final double thickness;
  final double length;
  final double centerRadius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(size.width / 2, size.height / 2);
    final p2 = Offset(size.width / 2, size.height / 2 - length);
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy);

    final paint = Paint()
      ..color = ColorName.neural600
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickness;
    canvas
      // draw needle
      ..drawPath(path, paint)
      // draw center circle
      ..drawCircle(p1, centerRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
