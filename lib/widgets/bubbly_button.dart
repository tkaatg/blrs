import 'package:flutter/material.dart';

class BubblyButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Color color;
  final double? width;
  final double? height;

  const BubblyButton({
    super.key,
    this.onTap,
    required this.child,
    this.color = Colors.blue,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(0.8),
              color,
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Gloss effect
            Positioned(
              top: 0,
              left: 4,
              right: 4,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
              ),
            ),
            Center(child: child),
          ],
        ),
      ),
    );
  }
}
