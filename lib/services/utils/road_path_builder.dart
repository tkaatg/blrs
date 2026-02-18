import 'package:flutter/material.dart';

class RoadPathBuilder {
  static Path buildRoadPath(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    
    // START: Bottom CENTER
    path.moveTo(w * 0.50, h);

    // Sequence of points based on Level positions (top/left)
    // L1: 0.930, 0.605 | L2: 0.835, 0.770 | L3: 0.790, 0.435 | L4: 0.675, 0.220
    // L5: 0.620, 0.585 | L6: 0.505, 0.775 | L7: 0.425, 0.485
    // L8: 0.335, 0.245 | L9: 0.255, 0.725 | L10: 0.045, 0.500

    // Curve to L1 and L2 (Right)
    path.cubicTo(
      w * 0.50, h * 0.98,
      w * 0.85, h * 0.93,
      w * 0.77, h * 0.83,
    );
    // Curve to L3 and L4 (Left)
    path.cubicTo(
      w * 0.70, h * 0.79,
      w * 0.22, h * 0.75,
      w * 0.22, h * 0.67,
    );
    // Curve to L5 and L6 (Right)
    path.cubicTo(
      w * 0.22, h * 0.63,
      w * 0.77, h * 0.58,
      w * 0.77, h * 0.50,
    );
    // Curve to L7 and L8 (Left)
    path.cubicTo(
      w * 0.77, h * 0.45,
      w * 0.24, h * 0.40,
      w * 0.24, h * 0.33,
    );
    // Curve to L9 and L10 (Right then Arrival)
    path.cubicTo(
      w * 0.24, h * 0.28,
      w * 0.72, h * 0.26,
      w * 0.72, h * 0.25,
    );
    path.cubicTo(
      w * 0.72, h * 0.15,
      w * 0.50, h * 0.10,
      w * 0.50, h * 0.04,
    );
    
    return path;
  }
}
