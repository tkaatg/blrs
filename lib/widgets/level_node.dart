import 'package:flutter/material.dart';
import '../models/level_model.dart';

class LevelNode extends StatelessWidget {
  final LevelStatus level;
  final VoidCallback onTap;

  const LevelNode({
    super.key,
    required this.level,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color baseColor;
    IconData? mainIcon;
    bool isLocked = level.state == LevelState.locked;

    switch (level.state) {
      case LevelState.completed:
        baseColor = _getScoreColor();
        break;
      case LevelState.available:
        baseColor = const Color(0xFFF25022); // Red for current/ready
        break;
      case LevelState.locked:
        baseColor = Colors.grey[400]!;
        mainIcon = Icons.lock_rounded;
        break;
    }

    return GestureDetector(
      onTap: isLocked ? () => _showLockedDialog(context) : onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stars Row (Above the node for better visibility)
          if (level.state == LevelState.completed)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Icon(
                  Icons.star_rounded,
                  size: 26,
                  color: index < level.starsCount ? Colors.amber : Colors.white.withOpacity(0.5),
                  shadows: const [Shadow(color: Colors.black26, blurRadius: 3)],
                );
              }),
            ),
          const SizedBox(height: 4),
          // The Level Button (Glossy & Thick)
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: baseColor,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
                // Inner highlight for glossy look
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  blurRadius: 0,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Level Number - Always visible
                  Text(
                    '${level.id}',
                    style: TextStyle(
                      color: isLocked ? Colors.white.withOpacity(0.5) : Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      shadows: isLocked 
                        ? [] 
                        : [const Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(2, 2))],
                    ),
                  ),
                  // Small Padlock on top if locked
                  if (isLocked)
                    Transform.translate(
                      offset: const Offset(15, -15),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.lock_rounded, color: baseColor, size: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Indicator for current level
          if (level.isCurrent)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(Icons.keyboard_arrow_down_rounded, color: baseColor, size: 24),
            ),
        ],
      ),
    );
  }

  Color _getScoreColor() {
    if (level.score >= 5) return const Color(0xFF7FBA00); // Green
    if (level.score >= 3) return const Color(0xFFFFB900); // Yellow
    return const Color(0xFFF25022); // Red
  }

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Niveau verrouillé !'),
        content: const Text('Veux-tu débloquer ce niveau pour 500 étoiles ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Pas maintenant'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Débloquer'),
          ),
        ],
      ),
    );
  }
}
