import 'package:flutter/material.dart';

class TopViewCarWidget extends StatelessWidget {
  final double size;
  final Color color;

  const TopViewCarWidget({
    super.key,
    this.size = 50,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 0.6,
      height: size,
      child: Stack(
        children: [
          // Main Body
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(size * 0.15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
          // Windshield (Front)
          Positioned(
            top: size * 0.15,
            left: size * 0.05,
            right: size * 0.05,
            height: size * 0.2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.6),
                borderRadius: BorderRadius.circular(size * 0.05),
              ),
            ),
          ),
          // Rear Window
          Positioned(
            bottom: size * 0.15,
            left: size * 0.08,
            right: size * 0.08,
            height: size * 0.1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.4),
                borderRadius: BorderRadius.circular(size * 0.03),
              ),
            ),
          ),
          // Roof
          Positioned(
            top: size * 0.35,
            bottom: size * 0.25,
            left: size * 0.05,
            right: size * 0.05,
            child: Container(
              decoration: BoxDecoration(
                color: color.withBlue(color.blue + 20),
                borderRadius: BorderRadius.circular(size * 0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
