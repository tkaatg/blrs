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
    Color nodeColor;
    Widget? centerWidget;

    switch (level.state) {
      case LevelState.locked:
        nodeColor = Colors.grey;
        centerWidget = const Icon(Icons.lock, color: Colors.white, size: 30);
        break;
      case LevelState.available:
        nodeColor = Theme.of(context).primaryColor;
        centerWidget = Text(
          '${level.id}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      case LevelState.completed:
        nodeColor = _getScoreColor();
        centerWidget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${level.id}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Icon(
                  Icons.star,
                  size: 14,
                  color: index < level.starsCount ? Colors.white : Colors.white24,
                );
              }),
            ),
          ],
        );
        break;
    }

    return GestureDetector(
      onTap: level.state != LevelState.locked ? onTap : () => _showLockedDialog(context),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: nodeColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
            if (level.isCurrent)
              BoxShadow(
                color: nodeColor.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
          ],
        ),
        child: Center(child: centerWidget),
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
              // Logic to unlock level will be added in US 2.2.3
              Navigator.pop(context);
            },
            child: const Text('Débloquer'),
          ),
        ],
      ),
    );
  }
}
