import 'package:flutter/material.dart';

class BubblyTitle extends StatelessWidget {
  final String title;
  
  const BubblyTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adapt font size to screen width
        double fontSize = constraints.maxWidth < 600 ? 28 : 36;
        
        return Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: Colors.amber,
            shadows: const [
              Shadow(
                offset: Offset(0, 3),
                blurRadius: 2,
                color: Color(0xFF5D4037),
              ),
              // Simulate thick border with multiple shadows
              Shadow(offset: Offset(-1.5, -1.5), color: Color(0xFF5D4037)),
              Shadow(offset: Offset(1.5, -1.5), color: Color(0xFF5D4037)),
              Shadow(offset: Offset(1.5, 1.5), color: Color(0xFF5D4037)),
              Shadow(offset: Offset(-1.5, 1.5), color: Color(0xFF5D4037)),
            ],
          ),
        );
      }
    );
  }
}
