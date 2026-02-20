import 'package:flutter/material.dart';

class BubblyTitle extends StatelessWidget {
  final String title;
  
  const BubblyTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: Colors.amber,
        shadows: [
          Shadow(
            offset: Offset(0, 3),
            blurRadius: 2,
            color: Color(0xFF5D4037),
          ),
          Shadow(offset: Offset(-1.5, -1.5), color: Color(0xFF5D4037)),
          Shadow(offset: Offset(1.5, -1.5), color: Color(0xFF5D4037)),
          Shadow(offset: Offset(1.5, 1.5), color: Color(0xFF5D4037)),
          Shadow(offset: Offset(-1.5, 1.5), color: Color(0xFF5D4037)),
        ],
      ),
    );
  }
}
