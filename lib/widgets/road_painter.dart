import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/utils/road_path_builder.dart';

class RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE0C9A6) // Sand color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 80 // Broader road
      ..strokeCap = StrokeCap.round;

    final dashPaint = Paint()
      ..color = const Color(0xFF8D6E63).withOpacity(0.4) // Subtle dark brown dashes
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final path = RoadPathBuilder.buildRoadPath(size);

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
