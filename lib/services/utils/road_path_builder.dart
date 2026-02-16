import 'package:flutter/material.dart';

class RoadPathBuilder {
  static Path buildRoadPath(Size size) {
    final path = Path();
    
    // Bottom start (centered)
    path.moveTo(size.width / 2, size.height + 50);

    // Dynamic long path logic (Sync with RoadPainter)
    const double sectionHeight = 1000;
    int sections = (size.height / sectionHeight).ceil();

    for (int i = 0; i < sections; i++) {
      double startY = size.height - (i * sectionHeight);
      double endY = size.height - ((i + 1) * sectionHeight);
      
      path.cubicTo(
        i % 2 == 0 ? size.width * 0.8 : size.width * 0.2, startY - (sectionHeight * 0.35),
        i % 2 == 0 ? size.width * 0.2 : size.width * 0.8, startY - (sectionHeight * 0.65),
        size.width / 2, endY,
      );
    }
    
    return path;
  }
}
