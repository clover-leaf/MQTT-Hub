import 'package:flutter/cupertino.dart';

class LinearGaugeRuler extends CustomPainter {
  const LinearGaugeRuler({
    required this.ranges,
    required this.thickness,
    required this.unitLength,
    required this.paddingTop,
  });

  // [{'color': Color, 'range': 2},...]
  final List<Map<String, dynamic>> ranges;
  // ruler thickness
  final double thickness;
  // length of one unit of range
  final double unitLength;
  // top padding
  final double paddingTop;

  @override
  void paint(Canvas canvas, Size size) {
    final root = Offset(0, paddingTop);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = thickness;

    var prevOffset = root;

    for (final range in ranges) {
      final color = range['color']! as Color;
      final value = range['range']! as double;
      final dx = prevOffset.dx + value * unitLength;
      final offset = Offset(dx, root.dy);
      final path = Path()
        ..moveTo(prevOffset.dx, prevOffset.dy)
        ..lineTo(offset.dx, offset.dy);
      canvas.drawPath(path, paint..color = color);
      prevOffset = offset;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
