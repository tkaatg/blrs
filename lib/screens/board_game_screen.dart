import 'package:flutter/material.dart';
import '../models/level_model.dart';
import '../models/player_model.dart';
import '../widgets/level_node.dart';
import '../widgets/road_painter.dart';

class BoardGameScreen extends StatelessWidget {
  final Player player;

  const BoardGameScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    // Mock level data - this will eventually come from the player object/service
    final List<LevelStatus> levels = List.generate(10, (index) {
      int levelId = index + 1;
      LevelState state = LevelState.locked;
      int score = 0;

      if (player.unlockedLevels.contains(levelId)) {
        state = player.statsLevels.containsKey('level_$levelId') 
            ? LevelState.completed 
            : LevelState.available;
        score = player.statsLevels['level_$levelId'] ?? 0;
      }

      return LevelStatus(
        id: levelId,
        state: state,
        score: score,
        isCurrent: levelId == player.maxLevelUnlocked,
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF8BC34A), // Natural Grass Green
      body: Stack(
        children: [
          // Background decorations (could be images later)
          Positioned.fill(
            child: CustomPaint(
              painter: RoadPainter(),
            ),
          ),
          
          // Levels mapped along the path
          SingleChildScrollView(
            reverse: true, // Start at the bottom
            child: Container(
              height: 1200, // Fixed height for the winding road
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Stack(
                children: [
                   _buildLevelPositioned(levels[0], left: 0.5, top: 0.9),
                   _buildLevelPositioned(levels[1], left: 0.7, top: 0.8),
                   _buildLevelPositioned(levels[2], left: 0.6, top: 0.7),
                   _buildLevelPositioned(levels[3], left: 0.3, top: 0.6),
                   _buildLevelPositioned(levels[4], left: 0.2, top: 0.5),
                   _buildLevelPositioned(levels[5], left: 0.4, top: 0.4),
                   _buildLevelPositioned(levels[6], left: 0.7, top: 0.3),
                   _buildLevelPositioned(levels[7], left: 0.8, top: 0.2),
                   _buildLevelPositioned(levels[8], left: 0.6, top: 0.1),
                   _buildLevelPositioned(levels[9], left: 0.5, top: 0.0),
                ],
              ),
            ),
          ),

          // Top Overlay (Stats)
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatChip(context, Icons.person, player.pseudo),
                _buildStatChip(context, Icons.star, '${player.stars}', color: Colors.amber),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelPositioned(LevelStatus level, {required double left, required double top}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Positioned(
          left: constraints.maxWidth * left - 50, // Center the 100px node
          top: 1000 * top,
          child: LevelNode(
            level: level,
            onTap: () {
              print('Level ${level.id} tapped');
              // Navigate to Quiz Screen (US 2.3.x)
            },
          ),
        );
      },
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color ?? Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
