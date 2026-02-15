import 'package:flutter/material.dart';
import 'dart:ui';

class RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A4A4A) // Dark gray bitumen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 70
      ..strokeCap = StrokeCap.round;

    final dashPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final path = Path();
    
    // Bottom start
    path.moveTo(size.width / 2, size.height + 50);

    // Winding path (S-shape)
    path.cubicTo(
      size.width * 0.9, size.height * 0.75,
      size.width * 0.1, size.height * 0.5,
      size.width / 2, size.height * 0.4,
    );
    path.cubicTo(
      size.width * 0.9, size.height * 0.3,
      size.width * 0.1, size.height * 0.1,
      size.width / 2, -50,
    );

    canvas.drawPath(path, paint);

    // Dashed line logic
    final dashPath = Path();
    const double dashWidth = 15;
    const double dashSpace = 15;
    double distance = 0;

    for (PathMetric measurePath in path.computeMetrics()) {
      while (distance < measurePath.length) {
        dashPath.addPath(
          measurePath.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    
    canvas.drawPath(dashPath, dashPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
