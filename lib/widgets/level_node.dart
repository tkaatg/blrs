import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/level_model.dart';

class LevelNode extends StatefulWidget {
  final LevelStatus level;
  final VoidCallback onTap;

  const LevelNode({
    super.key,
    required this.level,
    required this.onTap,
  });

  @override
  State<LevelNode> createState() => _LevelNodeState();
}

class _LevelNodeState extends State<LevelNode> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color baseColor;
    bool isLocked = widget.level.state == LevelState.locked;

    switch (widget.level.state) {
      case LevelState.completed:
        baseColor = _getScoreColor();
        break;
      case LevelState.available:
        baseColor = const Color(0xFFF25022); // Red for current/ready
        break;
      case LevelState.locked:
        baseColor = Colors.grey[400]!;
        break;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // THE 10 STARS IN ARROW/ARC
                    if (!isLocked)
                      ...List.generate(10, (index) {
                        // Angle from -120 to -60 degrees (approx upper arc)
                        // Actually let's do 180 degrees spread
                        double angle = -math.pi + (index * (math.pi / 9)); 
                        double radius = 52.0;
                        return Transform.translate(
                          offset: Offset(
                            radius * math.cos(angle),
                            radius * math.sin(angle) - 5, // Lifted up a bit
                          ),
                          child: Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: index < widget.level.score ? Colors.amber : Colors.white.withOpacity(0.5),
                            shadows: const [Shadow(color: Colors.black45, blurRadius: 2)],
                          ),
                        );
                      }),

                    // MAIN BUTTON
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: baseColor,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(color: Colors.black38, blurRadius: 8, offset: const Offset(0, 4)),
                          BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 0, offset: const Offset(0, -4)),
                        ],
                      ),
                      child: Center(
                        child: !isLocked 
                          ? Text(
                              '${widget.level.id}',
                              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                            )
                          : const Icon(Icons.lock_rounded, color: Colors.white, size: 30),
                      ),
                    ),

                    // CURRENT INDICATOR
                    if (widget.level.isCurrent)
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(Icons.keyboard_arrow_down_rounded, color: baseColor, size: 20),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getScoreColor() {
    if (widget.level.score >= 8) return const Color(0xFF7FBA00); // Green
    if (widget.level.score >= 5) return const Color(0xFFFFB900); // Yellow
    return const Color(0xFFF25022); // Red
  }
}
